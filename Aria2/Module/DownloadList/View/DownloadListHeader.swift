//
//  DownloadListHeader.swift
//  Aria2
//
//  Created by my on 2022/10/11.
//

import UIKit

class DownloadListHeader: UITableViewHeaderFooterView {
    var statusLbl: UILabel!//
    var uploadIcon: UIImageView!
    var downloadIcon: UIImageView!
    var uploadSpeedLbl: UILabel!
    var downloadSpeedLbl: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 14.0, *) {
            var bgConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
            bgConfig.backgroundColor = UIColor(hex: "#eeeeee")
            self.backgroundConfiguration = bgConfig
//            UITableViewHeaderFooterView.appearance().backgroundConfiguration = bgConfig
        } else {
            self.backgroundColor = .white
            self.contentView.backgroundColor = UIColor(hex: "#eeeeee")
        }

        
        statusLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: TitleColor, fontSize: 16)
        statusLbl.font = .boldSystemFont(ofSize: 16)
        statusLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView.snp.left).offset(20)
            make.height.equalTo(20)
        }
        
        downloadSpeedLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: ContentColor, fontSize: 16)
        downloadSpeedLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        downloadIcon = UISetupView.setupImageView(superView: self.contentView, imageName: "download")
        downloadIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(downloadSpeedLbl.snp.left).offset(-3)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        uploadSpeedLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: ContentColor, fontSize: 16)
        uploadSpeedLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(downloadIcon.snp.left).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        uploadIcon = UISetupView.setupImageView(superView: self.contentView, imageName: "upload")
        uploadIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(uploadSpeedLbl.snp.left).offset(-3)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
