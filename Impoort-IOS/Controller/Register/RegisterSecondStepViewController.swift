//
//  RegisterSecondStepViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 5.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyPickerPopover
import PhoneNumberKit

class RegisterSecondStepViewController: BaseViewController {
    
    @IBOutlet weak var phoneNumberTxtField: PhoneNumberTextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var dateOfBirthOrEstablishedTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    let phoneNumberKit = PhoneNumberKit()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        //Radius and padding
        let uiViews:[UIView] = [phoneNumberTxtField, cityTxtField, dateOfBirthOrEstablishedTxtField, genderTxtField, nextButton]
        for i in uiViews {
            i.layer.cornerRadius = 12
            if let txt = i as? UITextField{
                TxtFieldConfig.shared.givePadding(to: txt)
            }
        }
        
        //PopupMenu
        let noEditableTxtViews = [dateOfBirthOrEstablishedTxtField, genderTxtField]
        for i in noEditableTxtViews{
            i?.isUserInteractionEnabled = true
            i?.delegate = self
        }
        
        let genderRecognizer = UITapGestureRecognizer(target: self, action: #selector(openGenderPopup))
        genderTxtField.addGestureRecognizer(genderRecognizer)
        let dateOfBirthRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDatePopup))
        dateOfBirthOrEstablishedTxtField.addGestureRecognizer(dateOfBirthRecognizer)
        
        phoneNumberTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if validate(){
            giveRegisteredUserInfo()
            self.goToRegisterThirdStep()
        }else{
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your information", buttonTitle: "Ok")
        }
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    @objc func openGenderPopup(){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Gender", message: "Optional", preferredStyle: .actionSheet)
        let actionMan = UIAlertAction(title: "Man", style: .default) { (action) in
            self.genderTxtField.text = "Man"
        }
        let actionWoman = UIAlertAction(title: "Woman", style: .default) { (action) in
            self.genderTxtField.text = "Woman"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(actionMan)
        alert.addAction(actionWoman)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openDatePopup(){
        self.view.endEditing(true)
        let datePicker = DatePickerPopover(title: "Select Date")
        datePicker.setDoneButton(color: #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)) { popover, selectedDate in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: selectedDate)
            self.dateOfBirthOrEstablishedTxtField.text = dateString
        }
        datePicker.setCancelButton(color: #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)) { (_, _) in
        }
        //let loc = Locale.init(identifier: "tur")
        //datePicker.setLocale(loc)
        datePicker.appear(originView: self.dateOfBirthOrEstablishedTxtField, baseViewController: self)
    }
    func validate()->Bool{
        var result = true
        if phoneNumberTxtField.text!.isEmpty || phoneNumberTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your phone, it can not be empty", buttonTitle: "Ok")
        }else if cityTxtField.text!.isEmpty || cityTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your city, it can not be empty", buttonTitle: "Ok")
        }else if dateOfBirthOrEstablishedTxtField.text!.isEmpty || dateOfBirthOrEstablishedTxtField.text == ""{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your Birth/Established date, it can not be empty", buttonTitle: "Ok")
        }else if !phoneNumberTxtField.text!.isValidPhone(){
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your phone, it must be phone format", buttonTitle: "Ok")
        }else if genderTxtField.text!.isEmpty || genderTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your gender, it can not be empty", buttonTitle: "Ok")
        }
        return result
    }
    func giveRegisteredUserInfo(){
        RegisteredUser.shared.phoneNumber = self.phoneNumberTxtField.text!
        RegisteredUser.shared.gender = self.genderTxtField.text!
        RegisteredUser.shared.city = self.cityTxtField.text!
        RegisteredUser.shared.birthDate = self.dateOfBirthOrEstablishedTxtField.text!
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }
}

extension RegisterSecondStepViewController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
}
extension String {
    func isValidPhone() -> Bool {
        if self.count > 11{
            return true
        }else{
            return false
        }
    }
}
