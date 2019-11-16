//
//  CustomTextField.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 31.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField:UITextField{
    var parentVC:UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    public func setup(){
        TxtFieldConfig.shared.givePadding(to: self)
        self.layer.cornerRadius = 10
        self.textColor = #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 0.8534086045)
        self.font = UIFont(name: "Avenir", size: 13.0)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.leftAnchor.constraint(equalTo: self.parentVC!.view.leftAnchor, constant: 20).isActive = true
        self.rightAnchor.constraint(equalTo: self.parentVC!.view.rightAnchor, constant: -20).isActive = true
    }
}
