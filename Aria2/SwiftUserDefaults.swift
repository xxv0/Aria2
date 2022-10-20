import Foundation
import SwiftyUserDefaults


// MARK: 定义UserDefaults的key
extension DefaultsKeys {
    //是否第一次登录
    var todayFirstLaunchAppKey: DefaultsKey<Bool> { .init("todayFirstLaunchAppKey", defaultValue: true) }
    //上次登录日期
    var lastLoginAppKey: DefaultsKey<String?> { .init("lastLoginAppKey") }
//    //本地存储的ServerModel列表
//    var serversKey: DefaultsKey<[ServerModel]> { .init("serversKey", defaultValue: []) }
    //选择的服务器
    var selectedServer: DefaultsKey<ServerModel> { .init("selectedServer", defaultValue: ServerModel()) }
    //token
    var tokenKey: DefaultsKey<String?> { .init("tokenKey") }

}

