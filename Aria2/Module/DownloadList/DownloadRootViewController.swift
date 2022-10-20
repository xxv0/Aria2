//
//  DownloadRootViewController.swift
//  Aria2
//
//  Created by my on 2022/10/12.
//

import UIKit
import SGPagingView

class DownloadRootViewController: BaseViewController, SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    
    var serverNameLbl: UILabel!
    
    var pagingTitleView: SGPagingTitleView!
    var pagingContentView: SGPagingContentScrollView!
    
    var vcs: [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "任务管理"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDownload))
        self.navigationItem.rightBarButtonItem = addItem
        
        serverNameLbl = UISetupView.setupLabel(superView: self.view, text: "添加服务器", textColor: TitleColor, fontSize: 16)
        serverNameLbl.isUserInteractionEnabled = true
        serverNameLbl.textAlignment = .right
        serverNameLbl.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.top.equalTo(self.view.snp.top)
            make.width.lessThanOrEqualTo(ScreenWidth-220)
            make.height.equalTo(40)
        }
        
        serverNameLbl.text = Defaults[\.selectedServer].name
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        serverNameLbl.addGestureRecognizer(tapGesture)
        
        // 配置类
        let configure = SGPagingTitleViewConfigure()
        configure.color = UIColor(hex: "#040404")
        configure.selectedColor = DefaultColor
        configure.font = .systemFont(ofSize: 16)
        configure.equivalence = true
        configure.indicatorType = .Default
        configure.indicatorColor = DefaultColor
        configure.indicatorHeight = 2
        configure.bottomSeparatorColor = .clear

        // 标题视图
        pagingTitleView = SGPagingTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 40), titles: ["下载中", "已完成"], configure: configure)
        pagingTitleView.delegate = self
        view.addSubview(pagingTitleView)
        pagingTitleView.snp.makeConstraints { make in
            make.left.top.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        vcs = [DownloadListViewController(), DownloadCompleteViewController()]
        
        // 内容视图
        pagingContentView = SGPagingContentScrollView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), parentVC: self, childVCs: vcs)
        pagingContentView.delegate = self
        pagingContentView.isScrollEnabled = false
        view.addSubview(pagingContentView)
        pagingContentView.snp.makeConstraints { make in
            make.top.equalTo(pagingTitleView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        serverNameLbl.text = Defaults[\.selectedServer].name
    }
    
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }

    // MARK: - addDownload
    @objc func addDownload() {
        let server = Defaults[\.selectedServer]
        if server.ip != nil && server.ip.count > 0 {
            let vc = AddDownloadViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "提示", message: "请先添加服务器", preferredStyle: .alert)
            let addAction = UIAlertAction(title: "添加", style: .default) { action in
                let vc = AddServerViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
                
            }
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true) {
                
            }
        }
    }
    
    @objc func tapGestureAction() {
        let vc = AddServerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
