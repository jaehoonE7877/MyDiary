//
//  UIViewController+Extension.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

enum TransitionStyle {
    case present
    case presentNavigation
    case presentFullNavigation
    case push
}

extension UIViewController {
    
    func transitionViewController<T: UIViewController>(viewController vc: T, transitionStyle: TransitionStyle) {
        
        let nav = UINavigationController(rootViewController: vc)
        
        switch transitionStyle {
        case .present:
            self.present(vc, animated: true)
        case .presentNavigation:
            self.present(nav, animated: true)
        case .presentFullNavigation:
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
}

