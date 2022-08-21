//
//  UIViewController+Extension.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

enum TransitionStyle {
    case present
    case fullScreenPresent
    case push
}

extension UIViewController {
    
    func transitionViewController<T: UIViewController>(storyboard: String, viewController vc: T, transitionStyle: TransitionStyle, completionHandler: (T) -> ()) {
        
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        switch transitionStyle {
        case .present:
            guard let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
            self.present(vc, animated: true)
        case .fullScreenPresent:
            guard let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .push:
            guard let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
            completionHandler(vc)
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
}

