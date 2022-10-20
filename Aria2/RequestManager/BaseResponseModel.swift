//
//  BaseResponseModel.swift
//  Aria2
//
//  Created by my on 2022/10/9.
//

import UIKit
import HandyJSON

struct BaseResponseModel: HandyJSON {
    
    var id: String!
    var jsonrpc: String!
    var result: Any!
    
    var error: ErrorModel!
    
    struct ErrorModel: HandyJSON {
        var code: Int!
        var message: String!
    }
    
}
