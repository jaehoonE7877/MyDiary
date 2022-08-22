//
//  SearchViewController.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import JGProgressHUD
import Kingfisher



class SearchViewController: BaseViewController {
    
    let hud = JGProgressHUD()
    
    var mainView = SearchView()
    
    var imageList: [String] = []
    var totalPage = 0
    var startPage = 1
    
    var selectedImageURL: String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(selectButtonTapped))
        
        mainView.searchCollctionView.delegate = self
        mainView.searchCollctionView.dataSource = self
        mainView.searchCollctionView.register(SearchCollectioinViewCell.self, forCellWithReuseIdentifier: SearchCollectioinViewCell.reuseIdentifier)
        mainView.searchCollctionView.prefetchDataSource = self
        
        mainView.searchBar.delegate = self
    }
    
    @objc
    func selectButtonTapped(){
        guard let selectedImageURL = selectedImageURL else { return }

        NotificationCenter.default.post(name: .selectedImage, object: nil, userInfo: ["image": selectedImageURL])
        
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    
    
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageURL = imageList[indexPath.item]
        selectAlertMessage(title: "이 사진을 선택하시겠습니까?", button: "웅!!")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
                
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item && imageList.count < totalPage {
                hud.show(in: mainView)

                startPage += 1
                guard let text = mainView.searchBar.text else { return }
                UnsplashAPIManager.shared.request(page: startPage, query: text) { list, totalPage in
                    self.imageList.append(contentsOf: list)
                    self.totalPage = totalPage
                    
                    DispatchQueue.main.async {
                        self.mainView.searchCollctionView.reloadData()
                        self.hud.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        hud.show(in: mainView)
        
        imageList.removeAll()
        
        UnsplashAPIManager.shared.request(page: 1, query: text) { list, totalPage in
            self.imageList.append(contentsOf: list)
            self.totalPage = totalPage
            
            
            DispatchQueue.main.async {
                self.mainView.searchCollctionView.reloadData()
                self.hud.dismiss(animated: true)
            }
        }
        mainView.endEditing(true)
    }
    
}

extension SearchViewController {
    
    func selectAlertMessage(title: String, button: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        let cancel = UIAlertAction(title: "아니!", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
