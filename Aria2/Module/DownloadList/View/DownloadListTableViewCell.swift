//
//  DownloadListTableViewCell.swift
//  Aria2
//
//  Created by my on 2022/10/11.
//

import UIKit

class DownloadListTableViewCell: BaseTableViewCell {
    
    var fileNameLbl: UILabel!//
    var progressLengthLbl: UILabel!//下载大小进度
    var progressPercentLbl: UILabel!//下载百分比
    var progressView: UIProgressView!
    var downloadSpeedLbl: UILabel!
    var operationBtn: UIButton!//开始，暂停
    
    typealias OperationBlock = (CommonStatusModel) -> ()
    var operationBlock: OperationBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .none
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        fileNameLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: TitleColor, fontSize: 16)
        fileNameLbl.lineBreakMode = .byCharWrapping
        fileNameLbl.numberOfLines = 2
        fileNameLbl.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.right.equalTo(self.contentView.snp.right).offset(-70)
            make.height.equalTo(40)
        }
        
        progressLengthLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: GrayTextColor, fontSize: 13)
        progressLengthLbl.snp.makeConstraints { make in
            make.left.equalTo(fileNameLbl.snp.left)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            make.height.equalTo(15)
        }
        
        progressPercentLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: GrayTextColor, fontSize: 13)
        progressPercentLbl.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.centerY.equalTo(progressLengthLbl.snp.centerY)
            make.height.equalTo(15)
        }
        
        downloadSpeedLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: GrayTextColor, fontSize: 13)
        downloadSpeedLbl.snp.makeConstraints { make in
            make.right.equalTo(self.contentView.snp.right).offset(-70)
            make.centerY.equalTo(progressLengthLbl.snp.centerY)
            make.height.equalTo(15)
        }
        
        progressView = UIProgressView()
        progressView.tintColor = DefaultColor
        self.contentView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalTo(fileNameLbl.snp.left)
            make.right.equalTo(fileNameLbl.snp.right)
            make.top.equalTo(fileNameLbl.snp.bottom).offset(5)
            make.height.equalTo(3)
        }
        
        operationBtn = UISetupView.setupImageButton(superView: self.contentView, image: nil)
        operationBtn.addTarget(self, action: #selector(operationBtnAction), for: .touchUpInside)
        operationBtn.snp.makeConstraints { make in
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    @objc func operationBtnAction() {
        if operationBlock != nil {
            operationBlock!(model)
        }
    }
    
    var model: CommonStatusModel! {
        didSet {
            if model.bittorrent != nil && model.bittorrent.info != nil {
                fileNameLbl.text = model.bittorrent.info.name
            } else {
                let path = model.files[0].path
                let fileName: Substring = path!.split(separator: "/").last ?? ""
                if fileName != "" {
                    fileNameLbl.text = String(fileName)
                } else {
                    let uri = model.files[0].uris[0].uri
                    let uriName: Substring = uri!.split(separator: "/").last ?? ""
                    fileNameLbl.text = String(uriName)
                }
            }
            
            let totalLength = model.totalLength
            let completedLength = model.completedLength
            
            let totalLengthFloat: Float = Float(model.totalLength)
            let completedLengthFloat: Float = Float(model.completedLength)

            progressLengthLbl.text = MyTool.fileLengthUnitToShow(completedLength) + "/" + MyTool.fileLengthUnitToShow(totalLength)
            var percent: Float  = 0.0
            if totalLengthFloat != 0.0 {
                percent = completedLengthFloat/totalLengthFloat
            }
            progressPercentLbl.text = String(format: "%.2f%%", percent*100)
            progressView.progress = percent
            downloadSpeedLbl.text = MyTool.speedStr(model.downloadSpeed)
            
            operationBtn.isHidden = true
            progressView.isHidden = true
            progressPercentLbl.isHidden = false
            switch model.status {
                case .active:
                    progressView.isHidden = false
                    operationBtn.isHidden = false
                    operationBtn.setImage(UIImage(named: "pauseAction"), for: .normal)
                    break
                case .waiting:
                    progressView.isHidden = false
                    downloadSpeedLbl.text = "等待中"
                    operationBtn.isHidden = false
                    operationBtn.setImage(UIImage(named: "waitingIcon"), for: .normal)
                    break
                case .paused:
                    progressView.isHidden = false
                    operationBtn.isHidden = false
                    operationBtn.setImage(UIImage(named: "downloadAction"), for: .normal)
                    downloadSpeedLbl.text = "已暂停"
                    break
                case .complete:
                    progressPercentLbl.isHidden = true
                    operationBtn.isHidden = false
                    operationBtn.setImage(UIImage(named: "deleteAction"), for: .normal)
                    downloadSpeedLbl.text = "已完成"
                    break
                case .removed:
                    downloadSpeedLbl.text = "已删除"
                    break
                case .error:
                    progressPercentLbl.isHidden = true
                    operationBtn.isHidden = false
                    operationBtn.setImage(UIImage(named: "deleteAction"), for: .normal)
                    downloadSpeedLbl.text = "出错"
                    break
                case .unknown:
                    downloadSpeedLbl.text = "未知"
                    break
                case .none:
                    break
            }
        }
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
