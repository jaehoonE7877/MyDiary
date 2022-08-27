//
//  BackupViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/25.
//

import UIKit

import Zip

class BackupViewController: BaseViewController {
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 60
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(BackupTableViewCell.self, forCellReuseIdentifier: BackupTableViewCell.reuseIdentifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDocumentZipFile()
        
    }
    
    override func configure() {
        view.addSubview(tableView)
        
        
        
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonTapped))
        let restoreButton = UIBarButtonItem(title: "복구", style: .plain, target: self, action: #selector(restoreButtonTapped))
        
        navigationItem.rightBarButtonItems = [backupButton, restoreButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc
    func backupButtonTapped() {
        //백업할 파일들의 url 배열 생성
        var urlPaths = [URL]()
        
        //도큐먼트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        // 도큐먼트 안에 백업 파일
        let realmFile = path.appendingPathComponent("default.realm")
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다.")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        //백업 파일 압축: URL 배열
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "MyDiary")
            print("Archive Location: \(zipFilePath)")
            
            //ActivityViewController 띄우기
            showActivityViewController()
            
        } catch {
            showAlertMessage(title: "압축을 실패했습니다")
        }
        
        
        
    }
    
    @objc
    func restoreButtonTapped() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true)
    }
    
    func showActivityViewController() {
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("MyDiary.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupTableViewCell.reuseIdentifier, for: indexPath) as? BackupTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
    
}

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    // 압축파일을 풀어서 데이터를 가져오기
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        //FilePicker안에 선택된 파일의 주소 ~/FileApp/Folder/MyDiary.zip
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        // 도큐먼트 파일의 주소 ~/Documents
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        // ~Documents/MyDiary.zip + 이 주소의 파일이 있는지 없는지를 확인해주기
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("MyDiary.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료 됐습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
            
        } else {
            
            // 경로에 파일이 없는 상황 -> copy를 해줌
            do {
                // 파일 앱의 zip파일을 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("MyDiary.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료 됐습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        }
        
    }
    
}
