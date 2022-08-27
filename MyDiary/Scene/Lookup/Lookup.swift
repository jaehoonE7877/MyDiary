//
//  Lookup.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/27.
//

import UIKit

import SnapKit
import Then
import RealmSwift

final class LookupViewController: BaseViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 100
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
    let repository = UserDiaryRepository()
    var diaryTitleList: [String]?
    var filteredList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //레포지토리에서 데이터 가져오기
        diaryTitleList = repository.fetch().map({ $0.diaryTitle })
        
    }
    
    override func configure() {
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Diary"
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Diary"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension LookupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryTitleList?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = filteredList?[indexPath.row]
        
        
        return cell
    }
    
}

extension LookupViewController: UISearchBarDelegate, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        self.filteredList = diaryTitleList?.filter{ $0.lowercased().contains(text) }
        dump(filteredList)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
