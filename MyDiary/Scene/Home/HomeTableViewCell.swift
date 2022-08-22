//
//  HomeTableViewCell.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/22.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {
    
    let diaryImageView = UIImageView().then {
        $0.backgroundColor = Constants.BaseColor.background
        $0.layer.borderWidth = Constants.Design.borderWidth
        $0.layer.cornerRadius = Constants.Design.cornerRadius
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .systemFont(ofSize: 13)
        $0.textAlignment = .center
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: HomeTableViewCell.reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureCell() {
       
        [diaryImageView, titleLabel, dateLabel].forEach { self.contentView.addSubview($0) }
    }
    
    override func setCellConstraints() {
        diaryImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(self.contentView).multipliedBy(0.8)
            make.width.equalTo(diaryImageView.snp.height).multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView).offset(-16)
            make.top.equalTo(diaryImageView.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(diaryImageView.snp.bottom)
        }
        
        
    }
    
}
