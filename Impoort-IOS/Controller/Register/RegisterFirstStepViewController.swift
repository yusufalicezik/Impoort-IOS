//
//  RegisterFirstStepViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 5.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class RegisterFirstStepViewController: BaseViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var eMailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordAgainTxtField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        let uiViews:[UIView] = [nameTxtField, surnameTxtField, eMailTxtField, passwordTxtField, passwordAgainTxtField, nextButton]
        for i in uiViews {
            i.layer.cornerRadius = 12
            if let txt = i as? UITextField{
                TxtFieldConfig.shared.givePadding(to: txt)
            }
        }        
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        self.goToRegisterSecondStep()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
       self.goToBack()
    }
    

}
