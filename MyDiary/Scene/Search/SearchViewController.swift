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
    
    var delegate: SelectImageDelegate?
    var selectImage: UIImage?
    var selectIndexPath: IndexPath?
    
    
    var selectedImageURL: String?
    
    let hud = JGProgressHUD()
    
    var mainView = SearchView()
    
    var imageList: [String] = []
    var totalPage = 0
    var startPage = 1
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BaseColor.background
    }
    
    override func configure() {
        
        let select = navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonTapped))

        mainView.searchCollctionView.delegate = self
        mainView.searchCollctionView.dataSource = self
        mainView.searchCollctionView.register(SearchCollectioinViewCell.self, forCellWithReuseIdentifier: SearchCollectioinViewCell.reuseIdentifier)
        mainView.searchCollctionView.prefetchDataSource = self
        
        mainView.searchBar.delegate = self
    }
    
    @objc
    func cancelButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc
    func selectButtonTapped(){
        
//        guard let selectedImageURL = selectedImageURL else { return }
//
//        NotificationCenter.default.post(name: .selectedImage, object: nil, userInfo: ["image": selectedImageURL])
        //alert 대신 toast, 버튼을 .disable 한 상태로 만들기
        guard let selectImage = selectImage else { showAlertMessage(title: "사진을 선택해주세요", button: "확인"); return }

        
        delegate?.sendImageData(image: selectImage )
        dismiss(animated: true)
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
        
        cell.layer.borderWidth = selectIndexPath == indexPath ? 4 : 0
        cell.layer.borderColor = selectIndexPath == indexPath ? UIColor.tintColor.cgColor : nil
        
        let url = URL(string: imageList[indexPath.item])
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }
    
    // didselect 하면 데이터 notification
    // userinterectionEnabled && progress loading
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectioinViewCell else { return }
        
        selectImage = cell.searchImageView.image
        //selectedImageURL = imageList[indexPath.item]
        selectIndexPath = indexPath
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#function)
        selectIndexPath = nil
        selectImage = nil
        collectionView.reloadData()
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
