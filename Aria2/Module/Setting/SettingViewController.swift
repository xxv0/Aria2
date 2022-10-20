//
//  SettingViewController.swift
//  Aria2
//
//  Created by my on 2022/10/13.
//

import UIKit
import PKHUD

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let options = ["服务器", "设置"]
    let settings = ["max-concurrent-downloads", "max-overall-download-limit", "max-overall-upload-limit", /*"continue",*/ "dir"]
    
    var tableView: UITableView!
    
    var globalOption: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置"
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        getGlobalOption()
    }
    
    func getGlobalOption() {
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)"]]
        } else {
            params = ["": ""]
        }
        RequestManager.manager.postWith(APIMethod.getGlobalOption.rawValue, parameters: params, showHud: false) { response in
            let jsonData = JSON(response)
            print(jsonData)
            self.globalOption = (response as! [String : String])
            self.tableView.reloadData()
        } fail: { error in
                
        }
    }
    
    func changeGlobalOption(_ option: String, value: String) {
        let options = [option: value]
        var params: [String: Any]!
        if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
            params = ["params": ["token:\(Defaults[\.selectedServer].token!)", options]]
        } else {
            params = ["params": [options]]
        }
        RequestManager.manager.postWith(APIMethod.changeGlobalOption.rawValue, parameters: params, showHud: false) { response in
            let jsonData = JSON(response)
            print(jsonData)
            self.getGlobalOption()
        } fail: { error in
            HUDTool.showHudText(text: error)
        }
    }

    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return settings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        if indexPath.section == 0 {
            cell.titleLbl.text = "服务器名称"
            cell.descLbl.text = "默认服务器地址"
            
            let server = Defaults[\.selectedServer]
            cell.contentLbl.text = server.name
            
        } else {
            cell.titleLbl.text = NSLocalizedString(String(format: "%@.name", settings[indexPath.row]), comment: "")
            cell.descLbl.text = NSLocalizedString(String(format: "%@.description", settings[indexPath.row]), comment: "")
            if globalOption != nil {
                cell.contentLbl.text = globalOption[settings[indexPath.row]]
            } else {
                cell.contentLbl.text = ""
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            let vc = AddServerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            changeOption(settings[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return options[section]
    }
    
    // MARK: - change
    func changeOption(_ option: String) {
        let titleStr = "修改" + NSLocalizedString(String(format: "%@.name", option), comment: "")
        var textStr = ""
        if globalOption != nil {
            textStr = globalOption[option]!
        }
        UIAlertController.showTextFieldAlert(title: titleStr, textFieldText: textStr, keyboardType: .numberPad, in: self, in: self.view) { str in
            if str.count > 0 {
                self.changeGlobalOption(option, value: str)
            } else {
                HUDTool.showHudText(text: "请输入")
            }
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
