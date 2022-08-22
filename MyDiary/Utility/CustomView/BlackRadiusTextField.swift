//
//  BlackRadiusTextField.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

class BlackRadiusTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = Constants.BaseColor.background
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderWidth = Constants.Design.borderWidth
        layer.borderColor = Constants.BaseColor.border
        font = .boldSystemFont(ofSize: 15)
    }
    
    
    
}
