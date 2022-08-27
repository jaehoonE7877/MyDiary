//
//  WirteView.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import SnapKit
import Then

final class WriteView: BaseView {
    
    let mainImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
    }
    
    let searchImageButton = UIButton().then {
        let size = UIImage.SymbolConfiguration(pointSize: 40)
        let searchImage = UIImage(systemName: "plus.magnifyingglass", withConfiguration: size)
        $0.setImage(searchImage, for: .normal)
        $0.tintColor = .white
    }
    
    let titleTextField = BlackRadiusTextField().then {
        $0.placeholder = "제목을 입력해주세요"
        $0.backgroundColor = .lightGray
    }
    
    let dateTextField = BlackRadiusTextField().then {
        $0.placeholder = "날짜를 입력해주세요"
        $0.backgroundColor = .lightGray
    }
    
    let contentTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func configureUI() {
        [mainImageView, titleTextField, dateTextField, contentTextView, searchImageButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(self).multipliedBy(0.3)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo(44)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(mainImageView.snp.width)
            make.height.equalTo(mainImageView.snp.height).multipliedBy(1.2)
        }
        
        searchImageButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(mainImageView).offset(-8)
        }
    }
    
    
}
