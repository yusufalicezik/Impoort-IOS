//
//  TabBarViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 21.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }
    @objc func set(selectedIndex index : Int) {
        _ = self.tabBarController(self, shouldSelect: self.viewControllers![index])
    }
    
}
@objc extension TabBarViewController: UITabBarControllerDelegate  {
    @objc func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: { (true) in
                
            })
            
            self.selectedViewController = viewController
        }
        
        return true
    }
}
