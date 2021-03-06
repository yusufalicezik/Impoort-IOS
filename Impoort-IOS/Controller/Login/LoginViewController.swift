//
//  ViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 30.09.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import Cloudinary
import Alamofire
import SwiftyJSON

class LoginViewController: BaseViewController {

    @IBOutlet weak var eMailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerTxtButton: UILabel!
    @IBOutlet weak var passwordResetTxtButton: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.clearHeader()
        
//        UserAuthControllerAPI.addNewUserUsingPOST(userRequestDTO: UserRequestDTO(birthDate: "1233123123", city: "İstanbul", department: "CdddddE", _description: "a4ssadasdd", email: "yusufal@hotmail.com", employeeCount: 2, employees: [], experiences: [], firstName: "yusufal2i", gender: "erkek", lastName: "cezik", links: ["asd":"asd"], password: "asdasd123asd", phoneNumber: "5310853020", userType: .investor)) { (res, err) in
//            print(res)
//            print(err)
//        }
                
//        let configuration = URLSessionConfiguration.default
//        var nHeaders = configuration.httpAdditionalHeaders
//        nHeaders!["Authorization"] = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1OTMyNDA1MjgsImVtYWlsIjoiYXNzc0Bhc2Rhc3NkLmNvbSJ9.mjwIvJ3CjW9Ma4qEVrzwex9vM1z9FOL1d95eIpxD8SCMbWNtqfzC3JOZSnlNJQlCayKDeLDFnW4Onx35HZkOXg"
//        configuration.httpAdditionalHeaders = nHeaders!
        
//        PostControllerAPI.addNewPostUsingPOST(postRequestDTO: PostRequestDTO(createdDateTime: nil, department: "asd", mediaUrl: "asd", postDescription: "ddd", postType: 2, tags: [], userId: "2c918082721e0bbb01721e0bff630000")) { (res, err) in
//            print(res)
//            print(err)
//        }
//        
        
        
//        let img = UIImage(named: "2f0")
//        let config = CLDConfiguration(cloudName: "divfjwrpa", apiKey: "2ljI1k92Jow0EulTwDSntlsPfH4")
//        let cloudinary = CLDCloudinary(configuration: config)
//
//        let data = img?.jpeg(.lowest)
//        let request = cloudinary.createUploader().upload(data: data!, uploadPreset: "ml_default")

       
    }

    
    func setup(){
        let uiViews:[UIView] = [loginButton, eMailTxtField, passwordTxtField]
        for i in uiViews {
            i.layer.cornerRadius = 13
        }
        TxtFieldConfig.shared.addIcon(to: eMailTxtField, iconName: "mailps")
        TxtFieldConfig.shared.addIcon(to: passwordTxtField, iconName: "iconps")
        
        let toRegisterRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToRegisterFirstVC))
        self.registerTxtButton.isUserInteractionEnabled = true
        self.registerTxtButton.addGestureRecognizer(toRegisterRecognizer)
        
    }
    @objc func goToRegisterFirstVC(){
        self.goToRegisterFirstStep()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        if !eMailTxtField.text!.isEmpty && !passwordTxtField.text!.isEmpty {
            UserAuthControllerAPI.loginUserSelf(mail: eMailTxtField.text!, password: passwordTxtField.text!) { (data) in
                print(data)
                let m = JSON(data.result.value!)
                if m["statusCodeValue"].intValue == 401 || m["statusCodeValue"].intValue == 500 || m["status"].intValue == 500 {
                    AlertController.shared.showBasicAlert(viewCont: self, title: "Error", message: "E mail or password wrong. Please check your information", buttonTitle: "Ok")
                } else {
                    UserDefaults.standard.set(true, forKey: "userLoggedIn")
                    let token: String = m["token"].stringValue
                    UserDefaults.standard.set(token, forKey: "AuthJWT")
                    self.setCurrentUserInfo(json: m)
                    print(m["token"])
                    self.goToHome()
                }
            }
        }
    }
    
    private func setCurrentUserInfo(json: JSON ) {
        CurrentUser.shared.birthDate = json["user"]["birthDate"].stringValue
        CurrentUser.shared.city = json["user"]["city"].stringValue
        CurrentUser.shared.description = json["user"]["description"].stringValue
        CurrentUser.shared.email = json["user"]["email"].stringValue
        CurrentUser.shared.employeeCount = json["user"]["employeeCount"].intValue
       // CurrentUser.shared.experiences = json["experiences"].array
        CurrentUser.shared.firstName = json["user"]["firstName"].stringValue
        CurrentUser.shared.gender = json["user"]["gender"].stringValue
        CurrentUser.shared.lastName = json["user"]["lastName"].stringValue
        //CurrentUser.shared.links = json["email"].stringValue
        CurrentUser.shared.password = passwordTxtField.text!
        CurrentUser.shared.phoneNumber = json["user"]["phoneNumber"].stringValue
        CurrentUser.shared.sector = json["user"]["department"].stringValue
        CurrentUser.shared.userId = json["user"]["userId"].stringValue
        CurrentUser.shared.profileImgUrl = json["user"]["profileImgUrl"].stringValue
        CurrentUser.shared.userType = json["user"]["userType"].intValue
    }
    
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
