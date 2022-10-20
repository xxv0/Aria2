//
//  APIMethod.swift
//  Aria2
//
//  Created by my on 2022/10/9.
//

import Foundation

enum APIMethod: String {
    case getGlobalStat = "aria2.getGlobalStat"
    case multicall = "system.multicall"//多个请求任务，一次完成
    case tellActive = "aria2.tellActive"
    case tellWaiting = "aria2.tellWaiting"
    case tellStopped = "aria2.tellStopped"
    
    case pause = "aria2.pause"
    case remove = "aria2.remove"
    case unpause = "aria2.unpause"
    
    case removeDownloadResult = "aria2.removeDownloadResult"
    
    case addUri = "aria2.addUri"
    
    case getGlobalOption = "aria2.getGlobalOption"
    case changeGlobalOption = "aria2.changeGlobalOption"
}
