//
//  AddServerViewController.swift
//  Aria2
//
//  Created by my on 2022/10/13.
//

import UIKit
import PKHUD

class AddServerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource   {
    
    var serverNameTextField: UITextField!
    var serverHostTextField: UITextField!
    var serverPortTextField: UITextField!
    var serverTokenTextField: UITextField!

    var tableView: UITableView!
    
    var dataArray: [ServerModel] = []
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "添加/选择服务器"
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItemAction))
        self.navigationItem.rightBarButtonItem = saveItem
        
        setupSubviews()
    }
    
    func setupSubviews() {
        let addView = UIView()
        self.view.addSubview(addView)
        addView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
//            make.height.equalTo(220)
            make.height.equalTo(180)
        }
        
        let fwqmc = UISetupView.setupLabel(superView: addView, text: "服务器名称", textColor: TitleColor, fontSize: 16)
        fwqmc.snp.makeConstraints { make in
            make.left.equalTo(addView.snp.left).offset(15)
            make.top.equalTo(addView.snp.top).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        serverNameTextField = createTextField()
        serverNameTextField.placeholder = "Aria2的服务器"
        addView.addSubview(serverNameTextField)
        serverNameTextField.snp.makeConstraints { make in
            make.left.equalTo(addView.snp.left).offset(120)
            make.centerY.equalTo(fwqmc.snp.centerY)
            make.right.equalTo(addView.snp.right).offset(-100)
            make.height.equalTo(25)
        }
        
        let fwqdz = UISetupView.setupLabel(superView: addView, text: "服务器地址", textColor: TitleColor, fontSize: 16)
        fwqdz.snp.makeConstraints { make in
            make.left.equalTo(fwqmc.snp.left)
            make.top.equalTo(fwqmc.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        serverHostTextField = createTextField()
        serverHostTextField.placeholder = "http(s)://"
        serverHostTextField.keyboardType = .URL
        addView.addSubview(serverHostTextField)
        serverHostTextField.snp.makeConstraints { make in
            make.left.equalTo(addView.snp.left).offset(120)
            make.centerY.equalTo(fwqdz.snp.centerY)
            make.right.equalTo(addView.snp.right).offset(-100)
            make.height.equalTo(25)
        }
        
        let fwqdk = UISetupView.setupLabel(superView: addView, text: "服务器端口", textColor: TitleColor, fontSize: 16)
        fwqdk.snp.makeConstraints { make in
            make.left.equalTo(fwqmc.snp.left)
            make.top.equalTo(fwqdz.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        serverPortTextField = createTextField()
        serverPortTextField.placeholder = "8888"
        addView.addSubview(serverPortTextField)
        serverPortTextField.keyboardType = .numberPad
        serverPortTextField.snp.makeConstraints { make in
            make.left.equalTo(addView.snp.left).offset(120)
            make.centerY.equalTo(fwqdk.snp.centerY)
            make.right.equalTo(addView.snp.right).offset(-100)
            make.height.equalTo(25)
        }
        
        let token = UISetupView.setupLabel(superView: addView, text: "密码令牌", textColor: TitleColor, fontSize: 16)
        token.snp.makeConstraints { make in
            make.left.equalTo(fwqmc.snp.left)
            make.top.equalTo(fwqdk.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        serverTokenTextField = createTextField()
        serverTokenTextField.placeholder = "RPC密码令牌"
        addView.addSubview(serverTokenTextField)
        serverTokenTextField.snp.makeConstraints { make in
            make.left.equalTo(addView.snp.left).offset(120)
            make.centerY.equalTo(token.snp.centerY)
            make.right.equalTo(addView.snp.right).offset(-100)
            make.height.equalTo(25)
        }
        
        let addBtn = UISetupView.setupTitleButton(superView: addView, title: "添加", titleColor: .white, titleFontSize: 20)
        addBtn.backgroundColor = DefaultColor
        addBtn.goodCornerRadius(radius: 10)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        addBtn.snp.makeConstraints { make in
            make.right.equalTo(addView.snp.right).offset(-10)
            make.top.equalTo(addView.snp.top).offset(10)
            make.bottom.equalTo(addView.snp.bottom).offset(-10)
            make.width.equalTo(80)
        }
        
//        let advanceBtn = UISetupView.setupTitleButton(superView: addView, title: "进阶添加", titleColor: .white, titleFontSize: 18)
//        advanceBtn.backgroundColor = DefaultColor
//        advanceBtn.goodCornerRadius(radius: 10)
//        advanceBtn.addTarget(self, action: #selector(advanceBtnAction), for: .touchUpInside)
//        advanceBtn.snp.makeConstraints { make in
//            make.left.equalTo(fwqmc.snp.left)
//            make.bottom.equalTo(addView.snp.bottom).offset(-5)
//            make.width.equalTo(150)
//            make.height.equalTo(30)
//        }
        
        //-------------
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(ServerTableViewCell.self, forCellReuseIdentifier: "ServerTableViewCell")
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
            make.top.equalTo(addView.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    func createTextField() -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        
        return tf
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData() {
        dataArray = DBManager.manager.queryServer()
        for i in 0..<dataArray.count {
            if dataArray[i].isSelected {
                selectedIndex = i
                break
            }
        }
        self.tableView.reloadData()
    }
    
    // 保存选中的服务器
    @objc func saveItemAction() {
        if dataArray.count > 0 && selectedIndex >= 0 {
            var server = dataArray[selectedIndex]
            server.isSelected = true
            DBManager.manager.updateSelectedServer(server: server)
            
//            Defaults selectedServer
            Defaults[\.selectedServer] = server
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 添加服务器到列表，并且默认不选中
    @objc func addBtnAction() {
        let name = serverNameTextField.text ?? ""
        let ip = serverHostTextField.text ?? ""
        let port = serverPortTextField.text ?? ""
        let token = serverTokenTextField.text ?? ""
        
        if name.count == 0 {
            HUDTool.showHudText(text: "请填写服务器名称")
            return
        }
        
        if ip.count == 0 {
            HUDTool.showHudText(text: "请填写服务器地址")
            return
        }
        
        if port.count == 0 {
            HUDTool.showHudText(text: "请填写服务器端口")
            return
        }
        
        let id = String(Date().timeIntervalSince1970)
        let server = ServerModel(ip: ip, port: port, name: name, token: token, id: id, updateAt: Date(), isSelected: false)
        DBManager.manager.insertServer(server: server)
        
        refreshData()
        self.view.endEditing(true)
    }
    
    @objc func advanceBtnAction() {
        
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerTableViewCell", for: indexPath) as! ServerTableViewCell
        
        let server = dataArray[indexPath.row]
        
        cell.titleLbl.text = server.name
        cell.addressLbl.text = "\(server.ip!):\(server.port!)"
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectedIndex = indexPath.row
        
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") {
            (action, view, completionHandler) in
            
            self.alertRemove(server: self.dataArray[indexPath.row])
            completionHandler(false)
        }
//        deleteAction.backgroundColor = UIColor(hex: "#7AD191")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    //
    func alertRemove(server: ServerModel) {
        let alert = UIAlertController(title: "提示", message: "是否删除服务器：\(server.name!)？", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "删除", style: .destructive) { action in
            DBManager.manager.deleteServer(id: server.id)
            self.refreshData()
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


class ServerTableViewCell: UITableViewCell {
    
    var titleLbl: UILabel!
    var addressLbl: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.tintColor = DefaultColor
        
        titleLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: TitleColor, fontSize: 17)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left).offset(15)
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.height.equalTo(20)
        }
        
        addressLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: ContentColor, fontSize: 15)
        addressLbl.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left).offset(15)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
