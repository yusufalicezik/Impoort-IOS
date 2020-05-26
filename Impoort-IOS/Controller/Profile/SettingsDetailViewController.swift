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
    let cityText = CustomTextField()
    let birthtTxt = CustomTextField()
    let genderTxt = CustomTextField()
    let sectorTxt = CustomTextField()
    let emailTxt = CustomTextField()
    let passtxt = CustomTextField()
    let phoneTxt = CustomTextField()

    var experienceList: [Experience] = CurrentUser.shared.experiences ?? []
    var linkList: [String:String] = CurrentUser.shared.links ?? [:]
    
    
    func setup(){
        
        propertyList.forEach {
            if $0.contains("Name"){
                nameTxt.parentVC = self
                self.containerStackView.addArrangedSubview(nameTxt)
                nameTxt.setup()
                nameTxt.placeholder = "Name"
                nameTxt.text = CurrentUser.shared.firstName ?? ""
            }else if $0.contains("Surname"){
                surnameTxt.parentVC = self
                self.containerStackView.addArrangedSubview(surnameTxt)
                surnameTxt.setup()
                surnameTxt.placeholder = "Surname"
                surnameTxt.text = CurrentUser.shared.lastName ?? ""
            }else if $0.contains("City"){
                cityText.parentVC = self
                self.containerStackView.addArrangedSubview(cityText)
                cityText.setup()
                cityText.placeholder = "City"
                cityText.text = CurrentUser.shared.city ?? ""
            }else if $0.contains("Date of Birth/Established"){
                birthtTxt.parentVC = self
                self.containerStackView.addArrangedSubview(birthtTxt)
                birthtTxt.setup()
                birthtTxt.placeholder = "Date of Birth/Established"
                birthtTxt.text = CurrentUser.shared.birthDate ?? ""
            }else if $0.contains("Gender"){
               genderTxt.parentVC = self
                self.containerStackView.addArrangedSubview(genderTxt)
                genderTxt.setup()
                genderTxt.placeholder = "Gender"
                genderTxt.text = CurrentUser.shared.gender ?? ""
            }else if $0.contains("Sector"){
               sectorTxt.parentVC = self
                self.containerStackView.addArrangedSubview(sectorTxt)
                sectorTxt.setup()
                sectorTxt.placeholder = "Sector"
                sectorTxt.text = CurrentUser.shared.sector ?? ""
            }else if $0.contains("E mail"){
                emailTxt.parentVC = self
                self.containerStackView.addArrangedSubview(emailTxt)
                emailTxt.setup()
                emailTxt.placeholder = "E mail"
                emailTxt.text = CurrentUser.shared.email ?? ""
            }else if $0.contains("Password"){
                passtxt.parentVC = self
                self.containerStackView.addArrangedSubview(passtxt)
                passtxt.setup()
                passtxt.placeholder = "Password"
                passtxt.text = CurrentUser.shared.password ?? ""
            }else if $0.contains("Phone Number"){
                phoneTxt.parentVC = self
                self.containerStackView.addArrangedSubview(phoneTxt)
                phoneTxt.setup()
                phoneTxt.placeholder = "Phone Number"
                phoneTxt.text = CurrentUser.shared.phoneNumber ?? ""
            }else if $0.contains("Profile Description"){
                descTxt.parentVC = self
                self.containerStackView.addArrangedSubview(descTxt)
                descTxt.setup()
                descTxt.placeholder = "Profile Description"
                descTxt.text = CurrentUser.shared.description ?? ""
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
                txt.isEnabled = false
                txt.text = "Contact us! support@impoort.com"
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
        vc?.linkDelegate = self
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
            
//            var exps = CurrentUser.shared.experiences ?? nil
//            var links = CurrentUser.shared.links ?? nil
//            //if self.experienceList.count != 0 {
//                if exps != nil && exps!.count > 0 {
//                    exps?.append(contentsOf: experienceList)
//                } else {
//                    exps = self.experienceList
//                }
//           // }
//
//
//            //if self.linkList.count != 0 {
//                if links != nil && links!.count > 0 {
//                    links = linkList.merging(links!, uniquingKeysWith: { (_, last) -> String in
//                        last
//                    })
//                } else {
//                    links = self.linkList
//                }
//           // }
        
            CompanyAndExperienceControllerAPI.newExperiencesUsingPOST(experiences: self.experienceList) { [weak self] (respo, err) in
                print("errorr \(err?.localizedDescription)")
                guard let self = self else {return}
                UserControllerAPI.updateUserUsingPOST(user: UserUpdateDto(
                    birthDate: CurrentUser.shared.birthDate ?? "",
                    city: CurrentUser.shared.city ?? "",
                    department: CurrentUser.shared.sector ?? "",
                    _description: self.descTxt.text ?? (CurrentUser.shared.description ?? ""),
                    email: CurrentUser.shared.email ?? "",
                    employeeCount: 0,
                    employees: nil,
                    experiences: self.experienceList,
                    firstName: CurrentUser.shared.firstName ?? "",
                    gender: CurrentUser.shared.gender ?? "",
                    lastName: CurrentUser.shared.lastName ?? "",
                    links: self.linkList,
                    password: CurrentUser.shared.password ?? "",
                    phoneNumber: CurrentUser.shared.phoneNumber ?? "",
                    profileImgUrl: CurrentUser.shared.profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png",
                    userId: CurrentUser.shared.userId ?? "",
                    userType: type)) { (resp, err) in
                        if err == nil {
                            
                            print("success: profile\(resp)")
                            self.navigationController?.popViewController(animated: true)
                        }
                }
            }
        } else if titleString == "Profile" {
            UserControllerAPI.updateUserUsingPOST(user: UserUpdateDto(
                birthDate: birthtTxt.text ?? "",
                city: cityText.text ?? "",
                department: sectorTxt.text ?? "",
                _description: CurrentUser.shared.description ?? "",
                email: CurrentUser.shared.email ?? "",
                employeeCount: 0,
                employees: nil,
                experiences: CurrentUser.shared.experiences ?? nil,
                firstName: CurrentUser.shared.firstName ?? "",
                gender: genderTxt.text ?? "",
                lastName: surnameTxt.text ?? "",
                links: CurrentUser.shared.links ?? nil,
                password: CurrentUser.shared.password ?? "",
                phoneNumber: CurrentUser.shared.phoneNumber ?? "",
                profileImgUrl: CurrentUser.shared.profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png",
                userId: CurrentUser.shared.userId ?? "",
                userType: type)) { (resp, err) in
                    if err == nil {
                        print("success: profile\(resp)")
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        } else if titleString == "Account" {
            guard let email = emailTxt.text, let ps = passtxt.text, let phone = phoneTxt.text else { return }
            UserControllerAPI.updateUserUsingPOST(user: UserUpdateDto(
                birthDate: CurrentUser.shared.birthDate ?? "",
                city: CurrentUser.shared.city ?? "",
                department: CurrentUser.shared.sector ?? "",
                _description: CurrentUser.shared.description ?? "",
                email: email,
                employeeCount: 0,
                employees: nil,
                experiences: CurrentUser.shared.experiences ?? nil,
                firstName: CurrentUser.shared.firstName ?? "",
                gender: CurrentUser.shared.gender ?? "",
                lastName: CurrentUser.shared.lastName ?? "",
                links: CurrentUser.shared.links ?? nil,
                password: ps,
                phoneNumber: phone,
                profileImgUrl: CurrentUser.shared.profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png",
                userId: CurrentUser.shared.userId ?? "",
                userType: type)) { (resp, err) in
                    if err == nil {
                        print("success: profile\(resp)")
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    
}

extension SettingsDetailViewController: ExperienceViewProtocol, LinksViewProtocol {
    func didUpdatedLinks(linkList: [String : String]) {
        self.linkList = linkList
    }
    
    func didUpdatedExperiences(expList: [Experience]) {
        self.experienceList = expList
    }
}
