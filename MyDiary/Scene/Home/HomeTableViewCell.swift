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
        $0.layer.borderColor = Constants.BaseColor.border
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .boldSystemFont(ofSize: 13)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .systemFont(ofSize: 13)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, contentLabel]).then {
        $0.axis = .vertical
        $0.alignment = .top
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureCell() {
        
        [diaryImageView, stackView].forEach { contentView.addSubview($0) }
    }
    
    override func setCellConstraints() {
        
        diaryImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(16)
            make.height.equalTo(contentView).multipliedBy(0.8)
            make.width.equalTo(diaryImageView.snp.height).multipliedBy(1.2)
        }
        
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.leading.equalTo(diaryImageView.snp.trailing).offset(16)
            make.height.equalTo(diaryImageView.snp.height)
            make.top.equalTo(diaryImageView.snp.top)
        }
        
        
    }
    
}
