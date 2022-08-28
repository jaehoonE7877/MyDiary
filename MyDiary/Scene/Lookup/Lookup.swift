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
    
    let searchController = UISearchController(searchResultsController: nil)

    let repository = UserDiaryRepository()
    var diaryTitleList: [String]?
    var filteredList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //레포지토리에서 데이터 가져오기
        diaryTitleList = repository.fetch().map({ $0.diaryTitle })
    }
    
    override func configure() {
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Diary"
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.title = "Diary"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(searchController.view.safeAreaLayoutGuide)
        }
    }
    
}

extension LookupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = filteredList?[indexPath.row]
        repository.fetch().forEach {
            if $0.diaryTitle == filteredList?[indexPath.row]{
                cell.dateLabel.text = formatter.string(from: $0.diaryDate)
                cell.contentLabel.text = $0.diaryContent
                cell.diaryImageView.image = loadImageFromDocument(fileName: "\($0.objectId)")
            }
        }
        
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
