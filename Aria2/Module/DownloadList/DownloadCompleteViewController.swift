//
//  DownloadCompleteViewController.swift
//  Aria2
//
//  Created by my on 2022/10/12.
//

import UIKit
import PKHUD

class DownloadCompleteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var timer: Timer!
    
    //var globalStatusModel = GlobalStatusModel(numActive: 0, numStoppedTotal: 0, uploadSpeed: 0, numWaiting: 0, downloadSpeed: 0, numStopped: 0)
    var dataArray: [CommonStatusModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if timer != nil {
            timer.fireDate = Date.distantPast
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil {
            timer.fireDate = Date.distantFuture
        }
    }
    
    @objc func timerAction() {
        getListData()
    }
    
    //获取下载中，暂停，完成的数据
    func getListData() {
        let commonKeys = ["gid", "totalLength", "completedLength", "downloadSpeed", "uploadSpeed", "files", "status", "bittorrent"]
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)", -1, 1000, commonKeys]]
        } else {
            params = ["params": [-1, 1000, commonKeys]]
        }
        RequestManager.manager.postWith(APIMethod.tellStopped.rawValue, parameters: params, showHud: false) { response in
            let jsonData = JSON(response)
            let resultArr = jsonData.arrayObject

            self.dataArray = [CommonStatusModel].deserialize(from: resultArr) as? [CommonStatusModel] ?? []

            self.tableView.reloadData()
        } fail: { error in

        }
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadListTableViewCell", for: indexPath) as! DownloadListTableViewCell
        
        let model = dataArray[indexPath.row]
        cell.model = model
        cell.operationBlock = { myModel in
            self.operationAction(model: myModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }

    // MARK: - action
    func operationAction(model: CommonStatusModel) {
        //已完成里只有删除
        RequestManager.manager.removeDownloadResultDownload(gid: model.gid) { response in
            self.getListData()
        } fail: { error in
            HUDTool.showHudText(text: error)
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
