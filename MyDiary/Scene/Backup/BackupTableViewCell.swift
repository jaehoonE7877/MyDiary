//
//  BackupTableViewCell.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/25.
//

import UIKit

class BackupTableViewCell: BaseTableViewCell {
    
    //cell 안에는 label 정도 들어가는 듯
    let contentLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .boldSystemFont(ofSize: 13)
        $0.backgroundColor = Constants.BaseColor.background
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureCell() {
        contentView.addSubview(contentLabel)
    }
    
    override func setCellConstraints() {
        contentLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
}
