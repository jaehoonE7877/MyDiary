//
//  SearchViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import Kingfisher

class SearchViewController: BaseViewController {
    
    var mainView = SearchView()
    
    var imageList: [String] = []
    var pageNum: Int?
    var startPage = 1
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        print(#function)
        mainView.searchCollctionView.delegate = self
        mainView.searchCollctionView.dataSource = self
        mainView.searchCollctionView.register(SearchCollectioinViewCell.self, forCellWithReuseIdentifier: SearchCollectioinViewCell.reuseIdentifier)
        
        mainView.searchBar.delegate = self
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    //image 가져와서 cell에 띄워주기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectioinViewCell.reuseIdentifier, for: indexPath) as? SearchCollectioinViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .lightGray
        let url = URL(string: imageList[indexPath.item])
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }
    
    // didselect 하면 데이터 notification
    
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        imageList.removeAll()
        
        UnsplashAPIManager.shared.request(page: 1, query: text) { list, totalPage in
            self.imageList.append(contentsOf: list)
            self.pageNum = totalPage
            
            
            DispatchQueue.main.async {
                self.mainView.searchCollctionView.reloadData()
            }
        }
        mainView.endEditing(true)
    }
    
}
