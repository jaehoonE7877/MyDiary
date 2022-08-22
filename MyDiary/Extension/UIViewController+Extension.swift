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
        
        
        switch transitionStyle {
        case .present:
            self.present(vc, animated: true)
        case .fullScreenPresent:
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        case .push:
            completionHandler(vc)
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
}

