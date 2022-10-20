//
//  AddDownloadViewController.swift
//  Aria2
//
//  Created by my on 2022/10/12.
//

import UIKit

class AddDownloadViewController: BaseViewController {

    var textView: PlaceHolderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "添加链接"
        
        textView = PlaceHolderTextView()
        textView.font = .systemFont(ofSize: 16)
        textView.goodCornerRadius(radius: 5)
        textView.placeholder = "请添加链接"
        textView.maxHeight = 200
        textView.minHeight = 200
        textView.textColor = ContentColor
//        textView.delegate = self
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.top.equalTo(self.view.snp.top).offset(20)
            make.height.equalTo(200)
        }
        
        let confirmBtn = UISetupView.setupTitleButton(superView: self.view, title: "确定", titleColor: .white, titleFontSize: 16)
//        confirmBtn.layer.borderColor = DefaultColor.cgColor
//        confirmBtn.layer.borderWidth = 1
        confirmBtn.backgroundColor = DefaultColor
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.layer.masksToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(30)
            make.left.right.equalTo(textView)
            make.height.equalTo(50)
        }
    }
    
    
    @objc func confirmBtnAction() {
        let str = textView.text ?? ""
        if str.count > 0 {
            var params: [String: Any]!
            if Defaults[\.selectedServer].token != nil && Defaults[\.selectedServer].token != "" {
                params = ["params": ["token:\(Defaults[\.selectedServer].token!)",[str]]]
            } else {
                params = ["params": [[str]]]
            }
            
            RequestManager.manager.postWith(APIMethod.addUri.rawValue, parameters: params) { response in
                HUDTool.showHudText(text: "添加成功！") {
                    self.navigationController?.popViewController(animated: true)
                }
            } fail: { error in
                HUDTool.showHudText(text: error)
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
