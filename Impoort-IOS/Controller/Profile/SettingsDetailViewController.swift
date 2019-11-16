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
        self.containerStackView.subviews.forEach {$0.removeFromSuperview()}
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
                weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "Surname"
            }else if $0.contains("City"){
                weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "City"
            }else if $0.contains("Date of Birth/Established"){
                 weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "Date of Birth/Established"
            }else if $0.contains("Gender"){
                 weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "Gender"
            }else if $0.contains("Sector"){
                 weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "Sector"
            }else if $0.contains("E mail"){
                 weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "E mail"
            }else if $0.contains("Password"){
                 weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "Password"
            }else if $0.contains("Phone Number"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Phone Number"
            }else if $0.contains("Profile Type"){
                weak var txt = CustomTextField()
                txt?.parentVC = self
                self.containerStackView.addArrangedSubview(txt!)
                txt?.setup()
                txt?.placeholder = "Profile Type"
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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        button.setTitle("Save", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
        button.layer.cornerRadius = 10
        self.containerStackView.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.containerStackView.centerXAnchor, constant: 0.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 47).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    deinit{
        print("settings detail de init")
    }

}
