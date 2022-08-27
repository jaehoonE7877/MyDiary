//
//  HomeViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/22.
//

import UIKit

import RealmSwift
import Kingfisher
import FSCalendar

class HomeViewController: BaseViewController {
    
    let repository = UserDiaryRepository()
    
    lazy var calendar = FSCalendar().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
    }
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 100
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    // 화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요! (fullscreen은 viewwillapear 호출되지만, present,overcurrentcontext,overfullscreen은 viewwillappear가 호출되지 않는다!)
    //1. 스와이프한 셀 하나만 ReloadRows 코드를 구현 => 상대적 효율성
    //2. 데이터가 변경됬으니 다시 realm에서 데이터를 가져오기 => didSet 일관적 형태로 갱신
    //self.tableView.reloadRows(at: [indexPath] , with: .none)
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
        
        // Realm 3. Realm 데이터를 정렬해 tasks에 담기
        fetchRealm()
        calendar.reloadData()
    }
    
    override func configure() {
        view.addSubview(tableView)
        view.addSubview(calendar)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
//        let settingButton = UIBarButtonItem(title: "설정", style: .plain, target: self , action: #selector(settingButtonTapped))
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonTapped))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.leftBarButtonItems = [sortButton, filterButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.topMargin.equalTo(300)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    func fetchRealm(){
        tasks = repository.fetch()
    }
    
    //actionSheet으로 정렬 -> completionhandler
    @objc
    func sortButtonTapped() {
        tasks = repository.fetchSort("updatedDate")
    }
    
    //realm에서 필터를 할 수 있는 query, NSPredicate(apple이 가지고있는 필터기능)
    @objc
    func filterButtonTapped() {
        tasks = repository.fetchFilter()
            
    }
    
    @objc
    func plusButtonTapped() {
        let vc = WriteViewController()
        transitionViewController(viewController: vc, transitionStyle: .presentFullNavigation)
    }
    // tabBar로 넘길 수 있게 만들어보기
    @objc
    func settingButtonTapped(){
        let vc = BackupViewController()
        transitionViewController(viewController: vc, transitionStyle: .push)
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
        
//        if let imageUrl = tasks[indexPath.row].imageURL {
//            cell.diaryImageView.kf.setImage(with: URL(string: imageUrl))
//        } else {
//            cell.diaryImageView.image = UIImage(systemName: "xmark")
//        }
        
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
                        
            self.repository.deleteColumn(item: tasks[indexPath.row])
            //⭐️ 확인해보기
            //tableView.beginUpdates()
            //tableView.endUpdates()
           
        }
    }
    
    //참고. TableView Editing Mode
    
    //테이블 뷰 셀 높이가 작을 경우, 이미지가 없을 때, 시스템 이미지가 아닌 경우
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            self.repository.updateFavorite(item: self.tasks[indexPath.row])
            
        }
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    // 달력 한칸한칸에 들어가는 점 개수(Event의 개수)
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetchDate(date: date).count
    }
    // 달력 한칸한칸에 들어가는 내용
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "My Diary"
//    }
    // 달력 밑에 들어가는 서브내용
    // dateFormatter 사용해서 format 정해줘야 함
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return formatter.string(from: date) == "20220907" ? "오프라인 모임" : nil
    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }
    
    //realm에 작성한 글이 3개이면 3개만 보여주도록
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
    }
}
