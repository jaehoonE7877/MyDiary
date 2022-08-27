//
//  WriteViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import RealmSwift
import Kingfisher

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

final class WriteViewController: BaseViewController {
    
    private let datePicker = UIDatePicker()
    
    let repository = UserDiaryRepository()
    
    var selectedDate: Date?
    var selectedImageURL: String?
    
    var mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
        NotificationCenter.default.addObserver(self, selector: #selector(saveImageNotificationObserver(notification:)), name: .selectedImage, object: nil)
    }
    
    override func configure() {
        self.navigationItem.title = "Diary 작성하기"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        mainView.searchImageButton.addTarget(self, action: #selector(searchImageButtonTapped), for: .touchUpInside)
        
        configureDatePicker()
    }
    
    @objc
    func cancelButtonTapped(){
        self.dismiss(animated: true)
    }
    
//    func saveImageToDocument(fileName: String, image: UIImage) {
//        //Document 경로를 알려줌
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        //Document 이후 세부 경로(이미지를 저장할 위치)
//        let fileURL = documentDirectory.appendingPathComponent(fileName)
//        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
//
//        do {
//            try data.write(to: fileURL)
//        } catch {
//            print("file save error", error)
//        }
//    }
    
    // Realm + 이미지 도큐먼트 저장
    @objc
    func saveButtonTapped(){
        
        guard let diaryTitle = mainView.titleTextField.text, diaryTitle.count > 0 else { showAlertMessage(title: "일기 제목을 입력해주세요", button: "확인"); return  }
        guard let selectedDate = selectedDate else { showAlertMessage(title: "날짜를 입력해주세요", button: "확인"); return  }
        
        let task = UserDiary(diaryTitle: diaryTitle, diaryContent: mainView.contentTextView.text, diaryDate: selectedDate, updatedDate: Date(), imageURL: selectedImageURL) // => Record 한 줄 생성
        
        repository.addItem(item: task)
        
        // Realm 저장 이후에 document 저장 => PK가 있어야 되기 때문에
        
        if let image = mainView.mainImageView.image {
            saveImageToDocument(fileName: "\(task.objectId)", image: image)
        }
        
        dismiss(animated: true)// dismiss 위치 => 조건에 따라서 성공시에만 dismiss되도록
    }
    
    
    @objc
    func searchImageButtonTapped(){
        
        //UImenu, UIAlert
        

        let vc = SearchViewController()
        vc.delegate = self
        transitionViewController(viewController: vc, transitionStyle: .presentNavigation)
    }
    //노티피케이션으로 데이터 전달
    @objc
    func saveImageNotificationObserver(notification: NSNotification) {

        if let image = notification.userInfo?["image"] as? String {
            self.selectedImageURL = image
            let url = URL(string: image)
            DispatchQueue.main.async {
                //self.mainView.mainImageView.kf.setImage(with: url)
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

extension WriteViewController: SelectImageDelegate {
    
    //
    func sendImageData(image: UIImage) {
        mainView.mainImageView.image = image
        print(#function)
    }
    
}


