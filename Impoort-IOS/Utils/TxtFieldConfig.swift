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
    
    func givePadding(to textfield:UITextField){
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 10, y: 0, width: 15, height: 30))
        textfield.leftViewMode = UITextField.ViewMode.always
        textfield.rightViewMode = UITextField.ViewMode.always
        textfield.leftView = iconContainerView
        textfield.rightView = UIView(frame:
            CGRect(x: -10, y: 0, width: 30, height: 30))
    }
}
