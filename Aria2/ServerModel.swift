//
//  SeverModel.swift
//  Aria2
//
//  Created by my on 2022/10/9.
//

import UIKit

struct ServerModel: HandyJSON, Codable, DefaultsSerializable {
    var ip: String!
    var port: String!
    var name: String!
    var token: String!
    
    //主键，用于编辑的时候查找
    var id: String!//Date().timeIntervalSince1970
    var updateAt: Date!
    
    var isSelected: Bool!
    
//    static var _defaults: DefaultsCodableBridge<ServerModel>
//        { return DefaultsCodableBridge<ServerModel>() }
//        
//    static var _defaultsArray: DefaultsCodableBridge<[ServerModel]>
//        { return  DefaultsCodableBridge<[ServerModel]>()}
}
