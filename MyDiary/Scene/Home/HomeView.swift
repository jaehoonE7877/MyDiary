//
//  HomeView.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/22.
//

import UIKit

class HomeView: BaseView {
    
    let homeTableView = UITableView().then {
        $0.backgroundColor = Constants.BaseColor.background
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func configureUI() {
        self.addSubview(homeTableView)
    }
    
    override func setConstraints() {
        print(#function)
        homeTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
