//
//  CommonStatusModel.swift
//  Aria2
//
//  Created by my on 2022/10/11.
//
//  下载，暂停等状态通用模型

import UIKit
import HandyJSON

enum DownloadStatus: String, HandyJSONEnum {
    case active = "active"
    case waiting = "waiting"
    case paused = "paused"
    case complete = "complete"
    case removed = "removed"
    case error = "error"
    case unknown = "unknown"
}

struct CommonStatusModel: HandyJSON {
    
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper.specify(property: &status) { (rawString) -> DownloadStatus in
//            
//            return rawString
//        }
//    }
    
    var gid: String!
    var status: DownloadStatus! = .unknown
    var totalLength: Int = 0//bytes
    var completedLength: Int = 0
    var uploadLength: Int = 0
    var downloadSpeed: Int = 0//bytes/secv
    var uploadSpeed: Int = 0//
    var seeder: Bool = true//true if the local endpoint is a seeder. Otherwise false. BitTorrent only.
    
    var errorCode: String!// only available for stopped/completed downloads.
    var errorMessage: String!
    var dir: String!
    var files: [FileModel] = []
    
    var bittorrent: BittorrentModel!
    
    struct FileModel: HandyJSON {
        var selected: String!
        var path: String!
        var length: String!
        var completedLength: String!
        var index: String!
        var uris: [UriModel] = []
        
        struct UriModel: HandyJSON {
            var uri: String!
            var status: DownloadStatus! = .unknown
        }
    }
    
    struct BittorrentModel: HandyJSON {
        var creationDate: Int!
        var info: BittorrentInfo!
         
        struct BittorrentInfo: HandyJSON {
            var name: String!
        }
    }
}
