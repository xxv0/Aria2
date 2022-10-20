//
//  SettingTableViewCell.swift
//  Aria2
//
//  Created by my on 2022/10/13.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    var titleLbl: UILabel!
    var descLbl: UILabel!
    var contentLbl: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        titleLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: TitleColor, fontSize: 17)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left).offset(15)
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.height.equalTo(20)
        }
        
        descLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: GrayTextColor, fontSize: 12)
        descLbl.numberOfLines = 0
        descLbl.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left).offset(15)
            make.top.equalTo(titleLbl.snp.bottom).offset(5)
            make.right.equalTo(self.contentView.snp.right).offset(-80)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        
        contentLbl = UISetupView.setupLabel(superView: self.contentView, text: "", textColor: ContentColor, fontSize: 16)
        contentLbl.textAlignment = .right
        contentLbl.snp.makeConstraints { make in
            make.right.equalTo(self.contentView.snp.right).offset(0)
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
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
