//
//  ViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 30.09.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var eMailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerTxtButton: UILabel!
    @IBOutlet weak var passwordResetTxtButton: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    
    func setup(){
        let uiViews:[UIView] = [loginButton, eMailTxtField, passwordTxtField]
        for i in uiViews {
            i.layer.cornerRadius = 12
        }
        TxtFieldConfig.shared.addIcon(to: eMailTxtField, iconName: "mailps")
        TxtFieldConfig.shared.addIcon(to: passwordTxtField, iconName: "iconps")
        
        let toRegisterRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToRegisterFirstVC))
        self.registerTxtButton.isUserInteractionEnabled = true
        self.registerTxtButton.addGestureRecognizer(toRegisterRecognizer)
        
    }
    @objc func goToRegisterFirstVC(){
        self.goToRegisterFirstStep()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
    }
    
}


