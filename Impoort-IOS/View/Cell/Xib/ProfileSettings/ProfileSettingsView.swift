//
//  ProfileSettingsView.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 15.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyPickerPopover
enum EditingPopUpType{
    case dateOfBirth, Gender, ProfileType
}
class ProfileSettingsView: UIView {

    @IBOutlet weak var GeneralTxtField: UITextField!
    var parentVC:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.GeneralTxtField.layer.cornerRadius = 13
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
            self.removeFromSuperview()
            self.layoutIfNeeded()
    }
    @IBAction func okButtonClicked(_ sender: Any) {
    }
    
    func configPopup(indexPath:IndexPath){
        if indexPath.section == 0{
        switch indexPath.row {
        case 0:
              self.GeneralTxtField.placeholder = "Name"
        case 1:
            self.GeneralTxtField.placeholder = "Surname"
        case 2:
            self.GeneralTxtField.placeholder = "City"
        case 3:
            self.GeneralTxtField.placeholder = "Date Of Birth/Estalished"
            self.closeTxtFieldEditing()
            self.createRecognizer(popupType: .dateOfBirth)
        case 4:
            self.GeneralTxtField.placeholder = "Gender"
            self.closeTxtFieldEditing()
            self.createRecognizer(popupType: .Gender)
        default:
            self.GeneralTxtField.placeholder = "Sector"
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                self.GeneralTxtField.placeholder = "E mail"
            case 1:
                self.GeneralTxtField.placeholder = "Password"
                self.GeneralTxtField.isSecureTextEntry = true
            case 2:
                self.GeneralTxtField.placeholder = "Phone Number"
            case 3:
                self.GeneralTxtField.placeholder = "Profile Type"
                self.closeTxtFieldEditing()
                self.createRecognizer(popupType: .ProfileType)
            default:
                self.GeneralTxtField.placeholder = "Verify Account"
            }
        }else{
            switch indexPath.row {
            case 0:
                self.GeneralTxtField.placeholder = "About us"
            case 1:
                self.GeneralTxtField.placeholder = "Terms.."
            default:
                self.GeneralTxtField.placeholder = "Contact"
            }
        }
    }
    
    private func closeTxtFieldEditing(){
        //self.GeneralTxtField.isEnabled = false
        self.GeneralTxtField.isUserInteractionEnabled = true
    }
    private func createRecognizer(popupType:EditingPopUpType){
        var recognizer:UITapGestureRecognizer?
        switch popupType{
        case .dateOfBirth:
            recognizer = UITapGestureRecognizer(target: self, action: #selector(openDatePopup))
            self.GeneralTxtField.addGestureRecognizer(recognizer!)
        case .Gender:
            recognizer = UITapGestureRecognizer(target: self, action: #selector(openGenderPopup))
            self.GeneralTxtField.addGestureRecognizer(recognizer!)
        default:
            recognizer = UITapGestureRecognizer(target: self, action: #selector(openProfileTypePopup))
            self.GeneralTxtField.addGestureRecognizer(recognizer!)
        }
    }
    
    @objc private func openDatePopup(){
        let datePicker = DatePickerPopover(title: "Select Date")
        .setDoneButton(color: #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)) { popover, selectedDate in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: selectedDate)
            self.GeneralTxtField.text = dateString
        }
        .setCancelButton(color: #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)) { (_, _) in
        }
        //let loc = Locale.init(identifier: "tur")
        //datePicker.setLocale(loc)
        datePicker.appear(originView: self.GeneralTxtField, baseViewController: parentVC!)
    }
    @objc private func openGenderPopup(){
        StringPickerPopover(title: "Gender", choices: ["Female","Male"])
            .setSelectedRow(0)
            .setDoneButton(action: { (popover, selectedRow, selectedString) in
                print("done row \(selectedRow) \(selectedString)")
                self.GeneralTxtField.text = selectedString
            })
            .setCancelButton(action: { (_, _, _) in print("cancel")}
            )
            .appear(originView: self.GeneralTxtField, baseViewController: parentVC!)
    }
    @objc private func openProfileTypePopup(){
        StringPickerPopover(title: "Profile Type", choices: ["Investor","Developer", "Startup", "Just a user"])
            .setSelectedRow(0)
            .setDoneButton(action: { (popover, selectedRow, selectedString) in
                print("done row \(selectedRow) \(selectedString)")
                self.GeneralTxtField.text = selectedString
            })
            .setCancelButton(action: { (_, _, _) in print("cancel")}
            )
            .appear(originView: self.GeneralTxtField, baseViewController: parentVC!)
    }
    
}
