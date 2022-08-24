//
//  BackupViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/25.
//

import UIKit

class BackupViewController: BaseViewController {
    
    let diaryImage = UIImageView().then {
        $0.backgroundColor = Constants.BaseColor.background
    }
    
    let exampleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 44
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(BackupTableViewCell.self, forCellReuseIdentifier: BackupTableViewCell.reuseIdentifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonTapped))
        let restoreButton = UIBarButtonItem(title: "복구", style: .plain, target: self, action: #selector(restoreButtonTapped))
        
        navigationItem.leftBarButtonItems = [backupButton, restoreButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    func backupButtonTapped() {
        
    }
    
    @objc
    func restoreButtonTapped() {
        
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
