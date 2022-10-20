//
//  DBManager.swift
//  Aria2
//
//  Created by my on 2022/10/13.
//

import UIKit
import SQLite
import SwiftyJSON

let DataBasePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first?.appending("/db.sqlite3")

class DBManager: NSObject {
    var dbConnection = try! Connection(DataBasePath!)

    static let manager = DBManager()
    
    let t_server = Table("t_server")//登录账号
    
    override init() {
        super.init()

        print("数据库路径:\(DataBasePath!)")

        createTable(tableName: t_server)
    }
    
    func createTable(tableName: Table) {
        do {
            let ip = Expression<String>("ip")
            let port = Expression<String>("port")
            let token = Expression<String>("token")
            let name = Expression<String>("name")
            let id = Expression<String>("id")
            let updateAt = Expression<Date>("updateAt")
            let isSelected = Expression<Bool>("isSelected")
            
            try dbConnection.run(tableName.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (tableBuilder) in
                tableBuilder.column(id, unique: true)
                tableBuilder.column(ip)
                tableBuilder.column(port)
                tableBuilder.column(name)
                tableBuilder.column(token)
                tableBuilder.column(updateAt)
                tableBuilder.column(isSelected)
            }))
        } catch {

        }
    }
    
    func insertServer(server: ServerModel) {
        do {
            try dbConnection.transaction {
                try dbConnection.run(t_server.insert(or: .replace,
                                Expression("id") <- server.id,
                                Expression("ip") <- server.ip,
                                Expression("port") <- server.port,
                                Expression("token") <- server.token,
                                Expression("name") <- server.name,
                                Expression("isSelected") <- server.isSelected,
                                Expression("updateAt") <- Date()))
            }
        } catch {
            print("插入t_server失败:\(error)")
        }
    }
    
    //更新选中的
    func updateSelectedServer(server: ServerModel) {
        //1.先把所有的都isSelected = false
        //2.再把选中的isSelected = true
        //1.
        do {
            try dbConnection.run(t_server.update(Expression("isSelected") <- false))
        } catch {
            print("更新t_server失败:\(error)")
        }
        
        //2.
        do {
            let row = t_server.filter(Expression<String>("id") == server.id)
            try dbConnection.run(row.update(Expression("ip") <- server.ip,
                                            Expression("port") <- server.port,
                                            Expression("token") <- server.token,
                                            Expression("name") <- server.name,
                                            Expression("isSelected") <- true,
                                            Expression("updateAt") <- Date()))
        } catch {
            print("更新t_server失败:\(error)")
        }
    }
    
    
    // 查询登录的账号
    func queryServer() -> [ServerModel] {
        do {
            let result = try dbConnection.prepare(t_server.order(Expression<Date>("updateAt").desc))
            let rows = Array(result)
            return extractedServerFunc(rows)
        } catch {
            print("查询数据库错误:\(error)")
        }
        return []
    }
    
    func extractedServerFunc(_ rows: [Row]) -> [ServerModel] {
        var serversArr: [ServerModel] = []
        for row: SQLite.Row in rows {
            let server = ServerModel(ip: row[Expression<String>("ip")],
                                     port: row[Expression<String>("port")],
                                     name: row[Expression<String>("name")],
                                     token: row[Expression<String>("token")],
                                     id: row[Expression<String>("id")],
                                     updateAt:row[Expression<Date>("updateAt")],
                                     isSelected:row[Expression<Bool>("isSelected")])
            
            serversArr.append(server)
        }
        return serversArr
    }
    
    // 删除登录的账号
    func deleteServer(id: String) {
        do {
            let rows = t_server.filter(Expression<String>("id") == id)
            try dbConnection.run(rows.delete())
        }
        catch {
            print("删除失败:\(error)")
        }
    }
}
