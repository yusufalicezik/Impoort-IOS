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
    var selectedProfileType:Int = -1
    var fromAnimation : AnimationType?
    var sectorTypeStrings = ["Investor", "Developer", "Startup", "Just User"]
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
            //post atılacak
//             let parameters = [
//                    "firstName": RegisteredUser.shared.user.firstName!,
//                    "lastName": RegisteredUser.shared.user.lastName!,
//                    "birthDate":RegisteredUser.shared.user.birthDate!,
//                    "city":RegisteredUser.shared.user.city!,
//                    "email":RegisteredUser.shared.user.email!,
//                    "gender":RegisteredUser.shared.user.gender!,
//                    "phoneNumber":RegisteredUser.shared.user.phoneNumber!,
//                    "password":RegisteredUser.shared.user.password!,
//                    "sector":RegisteredUser.shared.user.sector!,
//                    "userType":RegisteredUser.shared.user.userType!
//                ] as [String : Any]
//
//            Alamofire.request("http://192.168.43.156:8080/auth/signUp", method:.post,
//                    parameters:parameters,  encoding: JSONEncoding.default).responseJSON { response in
//                    switch response.result {
//                    case .success:
//                        print(response)
//                    case .failure(let error):
//                        print(error)
//                    default :
//                        print("default")
//                    }
//
//                }

            AlertController.shared.showBasicAlert(viewCont: self, title: "Success", message: "Please verify your account with e mail that we sent", buttonTitle: "Ok") {
                self.goToLogin()
            }
        }

    }
    
    
    func validate()->Bool{
        var result = true
        if sectorTxtField.text!.isEmpty || sectorTxtField.text == " "{
            result = false
            AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please check your sector, it can not be empty", buttonTitle: "Ok")
        }
        if self.selectedProfileType == -1{
            result = false
             AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "Please select a profile type, it can not be empty", buttonTitle: "Ok")
        }
        return result
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    func giveRegisteredUserInfo(){
        RegisteredUser.shared.user.userType = self.selectedProfileType
        RegisteredUser.shared.user.sector = self.sectorTxtField.text
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
            cell?.sectorNameTxtField.backgroundColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        }
        let cell = tableView.cellForRow(at: indexPath) as? SectorCell
        cell?.sectorNameTxtField.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        selectedProfileType = indexPath.row
        //self.userTypeTableView.deselectRow(at: indexPath, animated: false)

    }
    
}
