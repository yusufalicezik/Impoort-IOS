//
//  AddImageToTextFields.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 5.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import UIKit

class TxtFieldConfig{
    static let shared = TxtFieldConfig()
    var dismissAction:(()->())?
    
    func addIcon(to textfield:UITextField, iconName imageName:String){
        let image = UIImage(named: imageName)
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.leftView = iconContainerView
        textfield.rightView = UIView(frame:
            CGRect(x: -20, y: 0, width: 30, height: 30))
    }
    func addIconForSearch(to textfield:UITextField, iconName imageName:String){
        let image = UIImage(named: imageName)
        let iconView = UIImageView(frame:
            CGRect(x: 7.5, y: 5, width: 17, height: 17))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 25, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.leftView = iconContainerView
        textfield.rightView = UIView(frame:
            CGRect(x: -10, y: 0, width: 30, height: 30))
    }
    
    func givePadding(to textfield:UITextField){
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 10, y: 0, width: 15, height: 30))
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.leftView = iconContainerView
        textfield.rightView = UIView(frame:
            CGRect(x: -10, y: 0, width: 30, height: 30))
    }
    
    func giveTickToRight(to textField:UITextField){
        let image = UIImage(named: "icontick")
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = iconContainerView
    }
    
    func giveErrorToRight(to textField:UITextField){
        let image = UIImage(named: "iconclose")
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = iconContainerView
    }
    func giveCloseToRight(to textField:UITextField, parentVC:UIViewController,action:@escaping (()->())){
        self.dismissAction = action
        let imgRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.dismissSearchBar))
        let image = UIImage(named: "cancelicon")
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        iconContainerView.addGestureRecognizer(imgRecognizer)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = iconContainerView
    }
    func giveEmptyToRight(to textField:UITextField){
        textField.rightView = nil
    }
    @objc func dismissSearchBar(){
        if let action = self.dismissAction{
            action()
        }
    }
    
}
