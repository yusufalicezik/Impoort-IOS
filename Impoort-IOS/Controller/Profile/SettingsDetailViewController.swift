//
//  SettingsDetailViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 24.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

protocol ExperienceViewProtocol:class {
    func didUpdatedExperiences(expList: [Experience])
}

protocol LinksViewProtocol:class {
    func didUpdatedLinks(linkList: [String:String])
}

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
    
    let nameTxt = CustomTextField()
    let surnameTxt = CustomTextField()
    let descTxt = CustomTextField()
    
    var experienceList: [Experience] = []
    var linkList: [String:String] = [:]

    
    func setup(){
        
        propertyList.forEach {
            if $0.contains("Name"){
                nameTxt.parentVC = self
                self.containerStackView.addArrangedSubview(nameTxt)
                nameTxt.setup()
                nameTxt.placeholder = "Name"
            }else if $0.contains("Surname"){
                surnameTxt.parentVC = self
                self.containerStackView.addArrangedSubview(surnameTxt)
                surnameTxt.setup()
                surnameTxt.placeholder = "Surname"
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
                descTxt.parentVC = self
                self.containerStackView.addArrangedSubview(descTxt)
                descTxt.setup()
                descTxt.placeholder = "Profile Description"
            }else if $0.contains("Experiences & Projects"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Edit Experiences & Projects"
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(goToExperiences))
                txt.addGestureRecognizer(recognizer)
            }else if $0.contains("Links"){
                let txt = CustomTextField()
                txt.parentVC = self
                self.containerStackView.addArrangedSubview(txt)
                txt.setup()
                txt.placeholder = "Edit Links"
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(goToLinks))
                txt.addGestureRecognizer(recognizer)
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
        button.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
    }
    
    @objc private func goToExperiences(){
        self.view.endEditing(true)
        let vc = UIStoryboard(name: "External", bundle: nil).instantiateViewController(withIdentifier: "ExpAndLinksEditVC") as? ExperiencesAndLinksEditViewController
        vc?.pageType = .experiences
        vc?.expDelegate = self
        vc?.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc private func goToLinks(){
        self.view.endEditing(true)
        let vc = UIStoryboard(name: "External", bundle: nil).instantiateViewController(withIdentifier: "ExpAndLinksEditVC") as? ExperiencesAndLinksEditViewController
        vc?.pageType = .links
        vc?.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true, completion: nil)
    }
    
    deinit{
        print("settings detail de init")
    }
    
    @objc func saveClicked() {
        
        var type: UserUpdateDto.UserType!
        
        switch CurrentUser.shared.userType {
        case 0:
            type = .developer
        case 1:
            type = .startup
        case 2:
            type = .investor
        default:
            type = .developer
        }
        
        
        if titleString == "Information" {
            
            var exps = CurrentUser.shared.experiences ?? nil
            if self.experienceList.count != 0 {
                exps = self.experienceList
                CompanyAndExperienceControllerAPI.newExperiencesUsingPOST(experiences: self.experienceList) { (respo, err) in
                    if err == nil {
                        print("success")
                    }
                }
            } 
            
            UserControllerAPI.updateUserUsingPOST(user: UserUpdateDto(
                birthDate: CurrentUser.shared.birthDate ?? "",
                city: CurrentUser.shared.city ?? "",
                department: CurrentUser.shared.sector ?? "",
                _description: descTxt.text ?? (CurrentUser.shared.description ?? ""),
                email: CurrentUser.shared.email ?? "",
                employeeCount: 0,
                employees: nil,
                experiences: exps,
                firstName: CurrentUser.shared.firstName ?? "",
                gender: CurrentUser.shared.gender ?? "",
                lastName: CurrentUser.shared.lastName ?? "",
                links: CurrentUser.shared.links ?? nil,
                password: CurrentUser.shared.password ?? "",
                phoneNumber: CurrentUser.shared.phoneNumber ?? "",
                profileImgUrl: CurrentUser.shared.profileImgUrl ?? "",
                userId: CurrentUser.shared.userId ?? "",
                userType: type)) { (resp, err) in
                if err == nil {
                    print("success: profile\(resp)")
                }
            }
        }
    }

}


/*
 UserControllerAPI.updateUserUsingPOST(user: UserUpdateDto(
     birthDate: CurrentUser.shared.birthDate ?? "",
     city: CurrentUser.shared.city ?? "",
     department: CurrentUser.shared.sector ?? "",
     _description: CurrentUser.shared.description ?? "",
     email: CurrentUser.shared.email ?? "",
     employeeCount: 0,
     employees: nil,
     experiences: CurrentUser.shared.experiences ?? nil,
     firstName: CurrentUser.shared.firstName ?? "",
     gender: CurrentUser.shared.gender ?? "",
     lastName: CurrentUser.shared.lastName ?? "",
     links: CurrentUser.shared.links ?? nil,
     password: CurrentUser.shared.password ?? "",
     phoneNumber: CurrentUser.shared.phoneNumber ?? "",
     profileImgUrl: url,
     userId: CurrentUser.shared.userId ?? "",
     userType: type)) { (resp, err) in
     if err == nil {
         print("success: profile")
     }
 }
 */
extension SettingsDetailViewController: ExperienceViewProtocol {
    func didUpdatedExperiences(expList: [Experience]) {
        self.experienceList = expList
    }
}
