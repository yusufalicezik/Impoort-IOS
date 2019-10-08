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
        passwordTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordAgainTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        for i in uiViews {
            i.layer.cornerRadius = 12
            if let txt = i as? UITextField{
                TxtFieldConfig.shared.givePadding(to: txt)
            }
        }        
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        if validate(){
            giveRegisteredUserInfo()
            self.goToRegisterSecondStep()
        }else{
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your information", buttonTitle: "Ok")
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
       self.goToBack()
    }
    
    
    func validate()->Bool{
        var result = true
        if nameTxtField.text!.isEmpty || nameTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your name, it can not be empty", buttonTitle: "Ok")
        }else if surnameTxtField.text!.isEmpty || surnameTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your surname, it can not be empty", buttonTitle: "Ok")
        }else if eMailTxtField.text!.isEmpty || eMailTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your e mail, it can not be empty", buttonTitle: "Ok")
        }else if !isValidEmail(enteredEmail: eMailTxtField.text!){
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your e mail, it must be e mail format", buttonTitle: "Ok")
        }else if passwordTxtField.text!.isEmpty || passwordAgainTxtField.text!.isEmpty{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your password, it can not be empty", buttonTitle: "Ok")
        }else if passwordTxtField.text != passwordAgainTxtField.text{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Password and Password again not equals", buttonTitle: "Ok")
        }else if passwordTxtField.text!.count < 6 || passwordAgainTxtField.text!.count < 6 {
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Your password must be at least 6 character", buttonTitle: "Ok")
        }
        return result
    }
    
    func isValidEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.passwordTxtField{
            if textField.text?.count == 0 {
                TxtFieldConfig.shared.giveEmptyToRight(to: textField)
            }else if (textField.text!.count > 0 && textField.text!.count < 6 ){
                TxtFieldConfig.shared.giveErrorToRight(to: textField)
            }else{
                TxtFieldConfig.shared.giveTickToRight(to: textField)
            }
        }else if textField == self.passwordAgainTxtField{
            if textField.text?.count == 0 {
                TxtFieldConfig.shared.giveEmptyToRight(to: textField)
            }else if (textField.text!.count > 0 && textField.text!.count < 6 ){
                TxtFieldConfig.shared.giveErrorToRight(to: textField)
            }else if textField.text != self.passwordTxtField.text{
                TxtFieldConfig.shared.giveErrorToRight(to: textField)
            }
            else{
                TxtFieldConfig.shared.giveTickToRight(to: textField)
            }
        }
    }
    
    func giveRegisteredUserInfo(){
        RegisteredUser.shared.user.firstName = self.nameTxtField.text!
        RegisteredUser.shared.user.lastName = self.surnameTxtField.text!
        RegisteredUser.shared.user.email = self.eMailTxtField.text!
        RegisteredUser.shared.user.password = self.passwordTxtField.text!
    }
    

}

