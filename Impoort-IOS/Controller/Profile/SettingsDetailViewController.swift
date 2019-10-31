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
        setup()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbuttonCicked(_ sender: Any) {
        self.goToBack()
    }
    
    func setup(){
        
        propertyList.forEach {
            if $0.contains("Name"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Name"
            }else if $0.contains("Surname"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Surname"
            }else if $0.contains("City"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "City"
            }else if $0.contains("Date of Birth/Established"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Date of Birth/Established"
            }else if $0.contains("Gender"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Gender"
            }else if $0.contains("Sector"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Sector"
            }else if $0.contains("E mail"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "E mail"
            }else if $0.contains("Password"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Password"
            }else if $0.contains("Phone Number"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Phone Number"
            }else if $0.contains("Profile Type"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Profile Type"
            }else if $0.contains("Verify Account"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Verify Account"
            }else if $0.contains("Profile Description"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Profile Description"
            }else if $0.contains("Experiences & Projects"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Experiences & Projects"
            }else if $0.contains("Links"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Links"
            }else if $0.contains("Contact"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Contact"
            }
        }
    }
    

}
