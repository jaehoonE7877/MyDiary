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

    private let datePicker = UIDatePicker()
    
    var selectedDate: Date?
    var selectedImageURL: String?
    
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
        self.navigationItem.title = "Diary 작성하기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonTapped), for: .touchUpInside)
        
        configureDatePicker()
    }
   
    @objc
    func saveButtonTapped(){
        
        guard let diaryTitle = mainView.titleTextField.text, diaryTitle.count > 0 else { return showAlertMessage(title: "일기 제목을 입력해주세요", button: "확인") }
        guard let selectedDate = selectedDate else { return showAlertMessage(title: "날짜를 입력해주세요", button: "확인") }
        
        let task = UserDiary(diaryTitle: diaryTitle, diaryContent: mainView.contentTextView.text, diaryDate: selectedDate, updatedDate: Date(), imageURL: selectedImageURL) // => Record 한 줄 생성
        
        try! localRealm.write {
            localRealm.add(task)    // Create(실제로 추가되는 것)
            print("Realm Succeed")
            
            dismiss(animated: true)// dismiss 위치 => 조건에 따라서 성공시에만 dismiss되도록
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
            self.selectedImageURL = image
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

extension WriteViewController {
    
    func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        self.datePicker.locale = Locale(identifier: "ko-KR")
        
        self.mainView.dateTextField.inputView = self.datePicker
    }
    
    @objc
    func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일"
        formatter.locale = Locale(identifier: "ko-KR")
        self.selectedDate = datePicker.date
        self.mainView.dateTextField.text = formatter.string(from: datePicker.date)
        
    }
    
    
}
