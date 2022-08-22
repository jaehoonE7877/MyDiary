//
//  HomeViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/22.
//

import UIKit

import SnapKit
import RealmSwift
import Kingfisher

class HomeViewController: BaseViewController {
    
    // data 가져오기 Realm 2.
    let localRealm = try! Realm()
    
    var tasks: Results<UserDiary>!
    
    var mainView = HomeView()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        
        mainView.homeTableView.delegate = self
        mainView.homeTableView.dataSource = self
        mainView.homeTableView.register(UITableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        // Realm 3. Realm 데이터를 정렬해 tasks에 담기
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요! (fullscreen은 viewwillapear 호출되지만, present,overcurrentcontext,overfullscreen은 viewwillappear가 호출되지 않는다!)
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        
        DispatchQueue.main.async {
            self.mainView.homeTableView.reloadData()
        }
        
    }
    
    @objc
    func plusButtonTapped() {
        let vc = WriteViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        
        //여기가 호출이 안됨
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as? HomeTableViewCell else { return UITableViewCell() }
        
        print("1111111111")
        cell.backgroundColor = .lightGray
        
        cell.titleLabel.text = tasks[indexPath.row].diaryTitle
        cell.dateLabel.text = String(describing: tasks[indexPath.row].diaryDate)
        if let imageUrl = tasks[indexPath.row].imageURL {
            cell.diaryImageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            cell.diaryImageView.image = UIImage(systemName: "xmark")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

