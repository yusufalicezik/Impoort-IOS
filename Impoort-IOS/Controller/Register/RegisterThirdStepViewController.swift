//
//  RegisterThirdStepViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 5.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import ViewAnimator
import Alamofire

class RegisterThirdStepViewController: BaseViewController {

    @IBOutlet weak var userTypeTableView: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var sectorTxtField: UITextField!
    var selectedProfileType:UserRequestDTO.UserType = .normalUser
    var fromAnimation : AnimationType?
    var sectorTypeStrings = ["INVESTOR", "DEVELOPER", "STARTUP", "JUST USER"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func setup(){
        self.userTypeTableView.delegate = self
        self.userTypeTableView.dataSource = self

        finishButton.layer.cornerRadius = 12
        sectorTxtField.layer.cornerRadius = 12
        self.userTypeTableView.isHidden = true
        self.sectorTxtField.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
            UIView.animate(withDuration: 0.8){
                self.userTypeTableView.isHidden = false
                self.sectorTxtField.isHidden = false
            }
            self.fromAnimation = AnimationType.from(direction: .left, offset: 90.0)
            UIView.animate(views: self.userTypeTableView.visibleCells,
                           animations: [self.fromAnimation!], delay: 0.55)
        })
        TxtFieldConfig.shared.givePadding(to: sectorTxtField)
    }
    
    @IBAction func finisButtonClicked(_ sender: Any) {
        //if everything is ok;
        if validate(){
            self.giveRegisteredUserInfo()
            
            guard let birhDate = RegisteredUser.shared.birthDate, let city = RegisteredUser.shared.city, let sector = RegisteredUser.shared.sector, let description = RegisteredUser.shared.description, let email = RegisteredUser.shared.email, let firstname = RegisteredUser.shared.firstName, let lastName = RegisteredUser.shared.lastName, let gender = RegisteredUser.shared.gender, let pass = RegisteredUser.shared.password, let phoneNumber = RegisteredUser.shared.phoneNumber else { return }
            
            let userReq = UserRequestDTO(birthDate: birhDate, city: city, department: sector, _description: description, email: email, employeeCount: nil, employees: nil, experiences: nil, firstName: firstname, gender: gender, lastName: lastName, links: nil, password: pass, phoneNumber: phoneNumber, userType: selectedProfileType)
            
            print(userReq)
            
            UserAuthControllerAPI.addNewUserUsingPOST(userRequestDTO: userReq) { (responseDto, error) in
                if error == nil {
                    AlertController.shared.showBasicAlert(viewCont: self, title: "Success", message: "Please verify your account with e mail that we sent", buttonTitle: "Ok") {
                            self.goToLogin()
                    }
                } else {
                    AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Error occured! Please check your information", buttonTitle: "Ok") {
                    }
                }
            }
        }
    }
    
    
    func validate()->Bool{
        var result = true
        if sectorTxtField.text!.isEmpty || sectorTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your sector, it can not be empty", buttonTitle: "Ok")
        }
        return result
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    func giveRegisteredUserInfo(){
        RegisteredUser.shared.sector = self.sectorTxtField.text
    }

}
extension RegisterThirdStepViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectorTypeStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userTypeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SectorCell else {return UITableViewCell()}
        cell.sectorNameTxtField.text = sectorTypeStrings[indexPath.row]
        cell.sectorNameTxtField.layer.masksToBounds = true
        cell.sectorNameTxtField.layer.cornerRadius = 12
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<self.sectorTypeStrings.count{
            let mIndexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: mIndexPath) as? SectorCell
            cell?.sectorNameTxtField.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
        }
        let cell = tableView.cellForRow(at: indexPath) as? SectorCell
        cell?.sectorNameTxtField.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        if indexPath.row == 3 {
            selectedProfileType = UserRequestDTO.UserType(rawValue: "NORMAL_USER")!
        }else {
            selectedProfileType = UserRequestDTO.UserType(rawValue: sectorTypeStrings[indexPath.row])!
        }
        //self.userTypeTableView.deselectRow(at: indexPath, animated: false)
    }
}
