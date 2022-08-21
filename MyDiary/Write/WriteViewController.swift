//
//  WriteViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import Kingfisher

class WriteViewController: BaseViewController {

    var mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveImageNotificationObserver(notification:)), name: .selectedImage, object: nil)
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
    
    @objc
    func saveImageNotificationObserver(notification: NSNotification) {
        
        if let image = notification.userInfo?["image"] as? String {
            let url = URL(string: image)
            DispatchQueue.main.async {
                self.mainView.mainImageView.kf.setImage(with: url)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("image"), object: nil)
    }

}
