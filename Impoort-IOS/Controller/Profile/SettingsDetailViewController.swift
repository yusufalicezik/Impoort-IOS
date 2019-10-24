//
//  SettingsDetailViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 24.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class SettingsDetailViewController: BaseViewController {

    @IBOutlet weak var titleSetting: UILabel!
    var titleString = "Settings" //default
    var propertyList:[String] = []
    @IBOutlet weak var containerStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleSetting.text = titleString

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbuttonCicked(_ sender: Any) {
        self.goToBack()
    }
    

}
