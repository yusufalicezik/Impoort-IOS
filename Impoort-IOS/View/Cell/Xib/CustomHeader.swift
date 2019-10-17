//
//  CustomHeader.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 15.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class CustomHeader: UIView {

    @IBOutlet weak var headerTitleLabel: UILabel!
    var settingsAction:(()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(setttingsAction))
        self.headerTitleLabel.isUserInteractionEnabled = true
        self.headerTitleLabel.addGestureRecognizer(recognizer)
    }
    @objc func setttingsAction(){
        self.settingsAction()
    }

}
