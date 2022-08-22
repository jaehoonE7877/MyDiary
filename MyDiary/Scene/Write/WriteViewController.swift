//
//  WriteViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import RealmSwift
import Kingfisher

class WriteViewController: BaseViewController {

    var mainView = WriteView()
    
    // 2.realm table에 내용을 CRUD할 때, Realm 테이블 경로에 접근
    let localRealm = try! Realm()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        NotificationCenter.default.addObserver(self, selector: #selector(saveImageNotificationObserver(notification:)), name: .selectedImage, object: nil)
    }
    
    override func configure() {
        self.navigationItem.title = "My Diary"
        
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonTapped), for: .touchUpInside)
        mainView.sampleButton.addTarget(self, action: #selector(sampleButtonTapped), for: .touchUpInside)
    }
   
    @objc
    func sampleButtonTapped(){
        // (realm에)저장하는 버튼
        let task = UserDiary(diaryTitle: "가오늘의 일기\(Int.random(in: 1...1000))", diaryContent: "일기 테스트 내용", diaryDate: Date(), updatedDate: Date(), imageURL: nil) // => Record 한 줄 생성
        
        try! localRealm.write {
            localRealm.add(task)    // Create(실제로 추가되는 것)
            print("Realm Succeed")
            
            dismiss(animated: true)     // dismiss 위치 => 조건에 따라서 성공시에만 dismiss되도록
        }
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
