//
//  HomeViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/22.
//

import UIKit

import RealmSwift
import Kingfisher

class HomeViewController: BaseViewController {
    
    // data 가져오기 Realm 2.
    let localRealm = try! Realm()
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 100
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
    // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요! (fullscreen은 viewwillapear 호출되지만, present,overcurrentcontext,overfullscreen은 viewwillappear가 호출되지 않는다!)
    var tasks: Results<UserDiary>! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
       
        // Realm 3. Realm 데이터를 정렬해 tasks에 담기
        fetchRealm()
    }
    
    override func configure() {
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonTapped))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.leftBarButtonItems = [sortButton, filterButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func fetchRealm(){
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    //actionSheet으로 정렬 -> completionhandler
    @objc
    func sortButtonTapped() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    //realm에서 필터를 할 수 있는 query, NSPredicate(apple이 가지고있는 필터기능)
    @objc
    func filterButtonTapped() {
        tasks = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '6'")
            //.filter("diaryTitle = '가오늘의 일기316'")
    }
    
    @objc
    func plusButtonTapped() {
        let vc = WriteViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as? HomeTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .darkGray
        
        cell.titleLabel.text = tasks[indexPath.row].diaryTitle
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy 년 MM 월 dd 일"
        formatter.locale = Locale(identifier: "ko-KR")
        cell.dateLabel.text = formatter.string(from: tasks[indexPath.row].diaryDate)
        cell.contentLabel.text = tasks[indexPath.row].diaryContent
        
        if let imageUrl = tasks[indexPath.row].imageURL {
            cell.diaryImageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            cell.diaryImageView.image = UIImage(systemName: "xmark")
        }
        
        return cell
    }
    
    //참고. TableView Editing Mode
    
    //테이블 뷰 셀 높이가 작을 경우, 이미지가 없을 때, 시스템 이미지가 아닌 경우
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            //realm data update -> 한가지 값만 업데이트
            try! self.localRealm.write{
                
                //하나의 record에서 특정 컬럼 하나만 변경
                self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite
                print("Realm Update Succeed, reloadRows필요")
                
                //하나의 테이블에 특정 컬럼 전체 값을 변경
                //self.tasks.setValue(true, forKey: "favorite")
                
                //하나의 레코드에서 여러 컬럼들이 변경
                //self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
            }
            //1. 스와이프한 셀 하나만 ReloadRows 코드를 구현 => 상대적 효율성
            //2. 데이터가 변경됬으니 다시 realm에서 데이터를 가져오기 => didSet 일관적 형태로 갱신
            //self.tableView.reloadRows(at: [indexPath] , with: .none)
            self.fetchRealm()
            
        }
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
}

