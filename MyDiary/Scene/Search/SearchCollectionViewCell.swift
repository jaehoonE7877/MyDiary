//
//  SearchCollectionViewCell.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

class SearchCollectioinViewCell: BaseCollectionViewCell {
    
    let searchImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureCell() {
        self.addSubview(searchImageView)
    }
    
    override func setCellConstraints() {
        searchImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
}
