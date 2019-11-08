//
//  HitsViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 8.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import collection_view_layouts
class HitsViewController: BaseViewController {

    @IBOutlet weak var searchTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup(){
        self.addSwipeDismiss(vc: self)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.searchTxtField.layer.cornerRadius = 15
        TxtFieldConfig.shared.addIconForSearch(to: self.searchTxtField, iconName: "search")
    }

}
