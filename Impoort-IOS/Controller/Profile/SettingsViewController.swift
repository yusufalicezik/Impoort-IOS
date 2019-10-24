//
//  SettingsViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 15.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    let profileProperties = ["Name" ,"Surname", "City", "Date of Birth/Established", "Gender", "Sector"]
    let accountProperties = ["E mail", "Password", "Phone Number","Profile Type", "Verify Account"]
    let infoProperties = ["Profile Description","Experiences & Projects","Links"]
    let supportProperties = ["About Us","Terms & Conditions", "Contact"]
    lazy var popupView:ProfileSettingsView = ProfileSettingsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.clearHeader()
    }
    func setup(){
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.width/2
        self.logOutButton.layer.cornerRadius = 11
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        self.addSwipeDismiss(vc:self)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    @IBAction func logOutButtonClicked(_ sender: Any) {
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func clearHeader(){
        UIView.animate(withDuration: 0.3){
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    

}
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return profileProperties.count
        }else if section == 1{
            return accountProperties.count
        }else if section == 2{
            return infoProperties.count
        }else{
            return supportProperties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProfilePropertiesCell else {return UITableViewCell()}
        if indexPath.section == 0{
            cell.propertyNameLabel.text = profileProperties[indexPath.row]
            cell.profileNameLabel.text = profileProperties[indexPath.row]
        }else if indexPath.section == 1{
            cell.propertyNameLabel.text = accountProperties[indexPath.row]
            cell.profileNameLabel.text = accountProperties[indexPath.row]
        }else if indexPath.section == 2{
            cell.propertyNameLabel.text = infoProperties[indexPath.row]
            cell.profileNameLabel.isHidden = true
        }else{
            cell.propertyNameLabel.text = supportProperties[indexPath.row]
            cell.profileNameLabel.text = supportProperties[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.popupView.removeFromSuperview()
        popupView = (Bundle.main.loadNibNamed("ProfileSettingsView", owner: self, options: nil)?.first as? ProfileSettingsView)!
        popupView.center = self.view.center
        TxtFieldConfig.shared.givePadding(to: (popupView.GeneralTxtField)!)
        popupView.configPopup(indexPath: indexPath)
        popupView.parentVC = self
//        if indexPath.section == 0{
//            if indexPath.row == 0{
//                popupView?.GeneralTxtField.placeholder = "Name Surname"
//            }
//        }
        popupView.layer.cornerRadius = 18
        self.view.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        popupView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        popupView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        popupView.heightAnchor.constraint(equalToConstant: self.view.frame.height/3).isActive = true
        popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        self.view.layoutIfNeeded()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("CustomHeader", owner: self, options: nil)?.first as? CustomHeader
        if section == 0{
            headerView?.headerTitleLabel.text = "Profile"
            headerView?.settingsAction = {
                self.goToSettingsDetailVC(title: "Profile", propertyList: self.profileProperties)
            }
        }else if section == 1{
            headerView?.headerTitleLabel.text = "Account"
            headerView?.settingsAction = {
                self.goToSettingsDetailVC(title: "Account", propertyList: self.accountProperties)
            }
        }else if section == 2{
            headerView?.headerTitleLabel.text = "Information"
            headerView?.settingsAction = {
                self.goToSettingsDetailVC(title: "Information", propertyList: self.infoProperties)
            }
        }else{
            headerView?.headerTitleLabel.text = "Support"
            headerView?.settingsAction = {
                self.goToSettingsDetailVC(title: "Support", propertyList: self.supportProperties)
            }
        }
        return headerView!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }
    
}
