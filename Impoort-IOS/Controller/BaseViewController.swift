//
//  BaseViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 5.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func goToRegisterFirstStep(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterFirstVC") as? RegisterFirstStepViewController
        if let navBar = self.navigationController{
            navBar.pushViewController(vc!, animated: true)
        }else{
            self.present(vc!, animated: true, completion: nil)
        }
    }
    func goToRegisterSecondStep(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterSecondVC") as? RegisterSecondStepViewController
        if let navBar = self.navigationController{
            navBar.pushViewController(vc!, animated: true)
        }else{
            self.present(vc!, animated: true, completion: nil)
        }
    }
    func goToRegisterThirdStep(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterThirdVC") as? RegisterThirdStepViewController
        if let navBar = self.navigationController{
            navBar.pushViewController(vc!, animated: true)
        }else{
            self.present(vc!, animated: true, completion: nil)
        }
    }

    func goToBack(){
        if let navBar = self.navigationController{
            navBar.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func goToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        if let navBar = self.navigationController{
            navBar.pushViewController(vc!, animated: true)
        }else{
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func goToHome(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? UITabBarController
        vc?.selectedIndex = 0
        if let navBar = self.navigationController{
            navBar.pushViewController(vc!, animated: true)
        }else{
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    func goToMessagesGeneral(){
        let storyboard = UIStoryboard(name: "External", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessagesGeneralVC") as? MessagesGeneralViewController
            self.present(vc!, animated: true, completion: nil)
    }
    
    func goToChatVC(){ //id de gönderilecek. mesajlasılan kisinin.
        let storyboard = UIStoryboard(name: "External", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatViewController
        self.present(vc!, animated: true, completion: nil)
        
    }
    func goToSettingsVC(){  //id gönderilebilir. me or other
        let storyboard = UIStoryboard(name: "External", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsViewController
        self.present(vc!, animated: true, completion: nil)
        
    }
    func addSwipeDismiss(vc:UIViewController){
        let swipeGesture = UISwipeGestureRecognizer(target: vc, action: #selector(dismissView))
        vc.view.isUserInteractionEnabled = true
        swipeGesture.direction = .right
        vc.view.addGestureRecognizer(swipeGesture)
    }
    @objc private func dismissView(){
        self.goToBack()
    }

}

class RegisteredUser{
    static let shared = RegisteredUser()
    var user = User()
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
