//
//  WriteViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

class WriteViewController: BaseViewController {

    var mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configure() {
        self.navigationItem.title = "My Diary"
        
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonTapped), for: .touchUpInside)
    }
   
    @objc
    func searchImageButtonTapped(){
        
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
