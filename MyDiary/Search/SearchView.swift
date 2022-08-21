//
//  SearchView.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import SnapKit
import Then

class SearchView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.backgroundColor = .lightGray
    }
    
    let searchCollctionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (spacing * 4)) / 3
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width , height: width * 1.1 )
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func configureUI() {
        [searchBar, searchCollctionView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        searchCollctionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
