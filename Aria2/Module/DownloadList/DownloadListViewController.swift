//
//  DownloadListViewController.swift
//  Aria2
//
//  Created by my on 2022/10/9.
//

import UIKit
import RxSwift
import Alamofire

class DownloadListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var globalStatusTimer: Timer!
    
    var globalStatusModel = GlobalStatusModel(numActive: 0, numStoppedTotal: 0, uploadSpeed: 0, numWaiting: 0, downloadSpeed: 0, numStopped: 0)
    var dataArray: [[CommonStatusModel]] = [[], []]//下载中，暂停中
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "下载"
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.register(DownloadListTableViewCell.self, forCellReuseIdentifier: "DownloadListTableViewCell")
        tableView.register(DownloadListHeader.self, forHeaderFooterViewReuseIdentifier: "DownloadListHeader")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        globalStatusTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(globalStatusTimerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(globalStatusTimer, forMode: .common)
        
//        getGlobalStat()
//        getListData()
        makeUpdateCountSheet()
    }
    func makeUpdateCountSheet() {
            // 这里直接使用 jsonString 转成字典，然后转成 Data，将 流 放到 request的 httpBody中， 模拟发送一个http请求
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)"]]
        } else {
            params = ["": ""]
        }
        var parameters = ["jsonrpc":"2.0",
                      "method": "aria2.getGlobalStat",
                      "id":"ijdensfijeni"] as [String : Any]
        for (key, value) in params {
            parameters[key] = value
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if globalStatusTimer != nil {
            globalStatusTimer.fireDate = Date.distantPast
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if globalStatusTimer != nil {
            globalStatusTimer.fireDate = Date.distantFuture
        }
    }
    
    @objc func globalStatusTimerAction() {
        getGlobalStat()
    }
    
    
    // MARK: - request
    //获取各种状态数量，上传下载总速度
    func getGlobalStat() {
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)"]]
        } else {
            params = ["": ""]
        }
        RequestManager.manager.postWith(APIMethod.getGlobalStat.rawValue, parameters: params, showHud: false) { response in
            let jsonData = JSON(response)
            self.globalStatusModel = GlobalStatusModel.deserialize(from: jsonData.dictionaryObject)!
//            if self.globalStatusModel.numActive > 0 || self.globalStatusModel.numWaiting > 0 {
//                self.getListData()
//            }
            self.getListData()
            self.tableView.reloadData()
        } fail: { error in
                
        }
    }

    //获取下载中，暂停，完成的数据
    func getListData() {
        let commonKeys = ["gid", "totalLength", "completedLength", "downloadSpeed", "uploadSpeed", "files", "status", "bittorrent"]
        
        var activeParams: [String: Any]!
        var waitingParams: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            activeParams = ["methodName":APIMethod.tellActive.rawValue,
                     "params": ["token:\(Defaults[\.selectedServer].token!)",commonKeys]] as [String : Any]
            waitingParams = ["methodName":APIMethod.tellWaiting.rawValue,
                             "params": ["token:\(Defaults[\.selectedServer].token!)", -1, 1000, commonKeys]] as [String : Any]
        } else {
            activeParams = ["methodName":APIMethod.tellActive.rawValue,
                                "params": [commonKeys]] as [String : Any]
            waitingParams = ["methodName":APIMethod.tellWaiting.rawValue,
                             "params": [-1, 1000, commonKeys]] as [String : Any]
        }

        let params = ["params": [[activeParams, waitingParams]]]
        
        RequestManager.manager.postWith(APIMethod.multicall.rawValue, parameters: params, showHud: false) { response in
            let jsonData = JSON(response)
            let resultArr = jsonData.arrayObject
            let activeArr: [Any] = resultArr![0] as! [Any]
            let waitingArr: [Any] = resultArr![1] as! [Any]
//            let stoppedArr: [Any] = resultArr![2] as! [Any]
            
            let activeArr0: [Any] = activeArr[0] as! [Any]
            let waitingArr0: [Any] = waitingArr[0] as! [Any]
//            let stoppedArr0: [Any] = stoppedArr[0] as! [Any]
            
            let activeModelArr = [CommonStatusModel].deserialize(from: activeArr0) as? [CommonStatusModel] ?? []
            let waitingModelArr = [CommonStatusModel].deserialize(from: waitingArr0)! as? [CommonStatusModel] ?? []
//            let stoppedModelArr = [CommonStatusModel].deserialize(from: stoppedArr0)! as? [CommonStatusModel] ?? []
            self.dataArray = [activeModelArr, waitingModelArr]
            self.tableView.reloadData()
        } fail: { error in

        }
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadListTableViewCell", for: indexPath) as! DownloadListTableViewCell
        
        let model = dataArray[indexPath.section][indexPath.row]
        cell.model = model
        cell.operationBlock = { myModel in
            self.operationAction(model: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DownloadListHeader") as! DownloadListHeader
        
        header.downloadIcon.isHidden = true
        header.uploadIcon.isHidden = true
        header.uploadSpeedLbl.isHidden = true
        header.downloadSpeedLbl.isHidden = true
        if section == 0 {
            header.statusLbl.text = "下载中" + "(\(globalStatusModel.numActive))"
            header.downloadIcon.isHidden = false
            header.uploadIcon.isHidden = false
            header.uploadSpeedLbl.isHidden = false
            header.downloadSpeedLbl.isHidden = false
            header.uploadSpeedLbl.text = MyTool.speedStr(globalStatusModel.uploadSpeed)
            header.downloadSpeedLbl.text = MyTool.speedStr(globalStatusModel.downloadSpeed)
        } else if section == 1 {
            header.statusLbl.text = "暂停中" + "(\(globalStatusModel.numWaiting))"
        } else if section == 2 {
            header.statusLbl.text = "已完成" + "(\(globalStatusModel.numStopped))"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if globalStatusTimer != nil {
            globalStatusTimer.fireDate = Date.distantFuture
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if globalStatusTimer != nil {
            globalStatusTimer.fireDate = Date.distantPast
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") {
            (action, view, completionHandler) in
            
            let model = self.dataArray[indexPath.section][indexPath.row]
            self.removeDownload(gid: model.gid)
            completionHandler(false)
        }
//        deleteAction.backgroundColor = UIColor(hex: "#7AD191")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // MARK: - action
    func operationAction(model: CommonStatusModel) {
        if model.status == .active {
            RequestManager.manager.pauseDownload(gid: model.gid) { response in
                self.getGlobalStat()
            } fail: { error in
                HUDTool.showHudText(text: error)
            }
        } else if model.status == .paused {
            RequestManager.manager.unpauseDownload(gid: model.gid) { response in
                self.getGlobalStat()
            } fail: { error in
                HUDTool.showHudText(text: error)
            }
        } else if model.status == .waiting {
            RequestManager.manager.pauseDownload(gid: model.gid) { response in
                self.getGlobalStat()
            } fail: { error in
                HUDTool.showHudText(text: error)
            }
        }
    }
    
    func removeDownload(gid: String) {
        let alert = UIAlertController(title: "提示", message: "是否删除任务？", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "删除", style: .destructive) { action in
            RequestManager.manager.removeDownload(gid: gid) { response in
                self.getGlobalStat()
            } fail: { error in
                HUDTool.showHudText(text: error)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true) {
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
