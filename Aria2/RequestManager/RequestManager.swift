//
//  RequestManager.swift
//  Aria2
//
//  Created by my on 2022/10/9.
//

import UIKit
import Alamofire

//通用返回block
typealias RequsetSuccessBlock = (_ response: Any) -> ()
typealias RequsetFailBlock = (_ error: String) -> ()

class RequestManager: NSObject {
    static let manager = RequestManager()
    
    let reachabilityManager = NetworkReachabilityManager()
    
    var headers: HTTPHeaders = ["":""]
    
    override init() {
        print("RequestManager init")
    }
    
    class func isConnectedToInternet() ->Bool {
        return manager.reachabilityManager!.isReachable
    }
    
    func randomString(length: Int = 48) -> String {
            let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomCharacters = (0..<length).map { _ in base.randomElement()!}
            return String(randomCharacters)
    }
    
    /// 生成请求url
    /// - Parameter url: url
    private func makeRequestUrl(_ url: String) -> String {
        let server = Defaults[\.selectedServer]
        if server.ip != nil && server.ip.count > 0 {
            if server.ip.last == "/" {
                return "\(server.ip!):\(server.port!)jsonrpc"
            } else {
                return "\(server.ip!):\(server.port!)/jsonrpc"
            }
        }
        
        return ""
    }
    
    /// POST请求
    /// - Parameters:
    ///   - url: url
    ///   - parameters: 参数
    ///   - success: 成功
    ///   - fail: 失败
    public func postWith(_ url: String, parameters: [String: Any], success: @escaping RequsetSuccessBlock, fail: @escaping RequsetFailBlock) {
        
        postWith(url, parameters: parameters, showHud: true, success: success, fail: fail)
    }
    
    //是否需要hud
    public func postWith(_ url: String, parameters: [String: Any], showHud: Bool = true, success: @escaping RequsetSuccessBlock, fail: @escaping RequsetFailBlock) {
        
        if showHud {
            HUDTool.showHudIndeterminate()
        }
        let completeUrl = makeRequestUrl(url)
        if completeUrl == "" {
            return
        }
        
        var params = ["jsonrpc":"2.0",
                      "method": url,
                      "id":randomString()] as [String : Any]
        for (key, value) in parameters {
            params[key] = value
        }
        print("post请求接口:\(completeUrl)")
        print("post请求参数:\(JSON(params))")
        
        var  jsonData = NSData()
        do {
             jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        // 构建URL
        let url:URL = URL(string: completeUrl)!
        // session
        let session = URLSession.shared
        // request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // 设置Content-Length，非必须
        request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
        // 设置 Content-Type 为 json 类型
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // POST    请求将 数据 放置到 请求体中
        request.httpBody = jsonData as Data
        // 发送请求
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in
            if showHud {
                HUDTool.hideHud()
            }
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                DispatchQueue.main.async(execute: {
                    fail((error?.localizedDescription)!)
                })
                return
            }
            // 返回值 utf8 转码
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            // 将 jsonString 转成字典
            let jsonData = JSON(parseJSON: dataString!)
//            let dict = MyTool.getDictionaryFromJSONString(jsonString: dataString!)
            print("接口成功返回：\(completeUrl)\n\(JSON(jsonData))")
            let model = BaseResponseModel.deserialize(from: jsonData.dictionaryObject)
            if model?.error == nil {
                DispatchQueue.main.async(execute: {
                    success(model?.result)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    fail((model?.error.message)!)
                })
            }
        }
        task.resume()
        
        
/*
        var request = URLRequest(url: URL(string: completeUrl)!)
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        request.headers = headers

        AF.request(request)
            .responseJSON { response in
                if showHud {
                    HUDTool.hideHud()
                }
                switch response.result {
                case .success(let data):
                    print("接口成功返回：\(completeUrl)\n\(JSON(data))")
                    let model = BaseResponseModel.deserialize(from: data as? NSDictionary)
                    if model?.error == nil {
                        success(model?.result)
                    } else {
                        fail((model?.error.message)!)
                    }
                    
                    break
                case .failure(let error):
                    fail(error.localizedDescription)
                    print("接口失败返回：\(completeUrl)\n\(error)")
                    break
                }
            }
 */
    }
    
    //暂停
    func pauseDownload(gid: String, success: @escaping RequsetSuccessBlock, fail: @escaping RequsetFailBlock) {
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)", gid]]
        } else {
            params = ["params": [gid]]
        }
        postWith(APIMethod.pause.rawValue, parameters: params) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    //移除
    func removeDownload(gid: String, success: @escaping RequsetSuccessBlock, fail: @escaping RequsetFailBlock) {
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)", gid]]
        } else {
            params = ["params": [gid]]
        }
        postWith(APIMethod.remove.rawValue, parameters: params) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    //从completed/error/removed中
    func removeDownloadResultDownload(gid: String, success: @escaping RequsetSuccessBlock, fail: @escaping RequsetFailBlock) {
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)", gid]]
        } else {
            params = ["params": [gid]]
        }
        postWith(APIMethod.removeDownloadResult.rawValue, parameters: params) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    //unpause继续下载
    func unpauseDownload(gid: String, success: @escaping RequsetSuccessBlock, fail: @escaping RequsetFailBlock) {
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)", gid]]
        } else {
            params = ["params": [gid]]
        }
        postWith(APIMethod.unpause.rawValue, parameters: params) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
}
