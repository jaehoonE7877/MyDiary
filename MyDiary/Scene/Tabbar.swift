//
//  Tabbar.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/27.
//

import UIKit

final class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTab()
        
        if #available(iOS 13, *) {
            setupAppearance()
        } else {
            setupTabAppearence()
        }
    }
    
    
    private func configureTab(){
        
        let firstTabVC = HomeViewController()
        let firstTabbarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        firstTabVC.tabBarItem = firstTabbarItem
        let firstNav = UINavigationController(rootViewController: firstTabVC)
        // SearchBarVC만들어서 검색 화면 추가하기
        let secondTabVC = LookupViewController()
        let secondTabbarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        secondTabVC.tabBarItem = secondTabbarItem
        let secondNav = UINavigationController(rootViewController: secondTabVC)
        
        let thirdTabVC = BackupViewController()
        let thirdTabbarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        thirdTabVC.tabBarItem = thirdTabbarItem
        let thirdNav = UINavigationController(rootViewController: thirdTabVC)
        
        self.viewControllers = [firstNav, secondNav, thirdNav]
    }
    
    private func setupAppearance(){
        
        let appearence = UITabBarAppearance()
        //탭바의 배경색을 투명하게해서
        //appearance.configureWithOpaqueBackground()
        tabBar.tintColor = Constants.BaseColor.tabbar
        tabBar.backgroundColor = Constants.BaseColor.background
        tabBar.standardAppearance = appearence
        tabBar.scrollEdgeAppearance = appearence
    }
    
    private func setupTabAppearence(){
        tabBar.backgroundColor = Constants.BaseColor.background
        tabBar.tintColor = Constants.BaseColor.tabbar
    }
}

