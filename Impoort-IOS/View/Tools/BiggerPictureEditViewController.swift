//
//  BiggerPictureEditViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 17.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import Zoomy
import Cloudinary
import Alamofire

class BiggerPictureEditViewController: BaseViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    var parentVC:NewProfileViewController?
    var profImage: UIImage?
    var loading = UIActivityIndicatorView()
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImg.translatesAutoresizingMaskIntoConstraints = false
        self.profileImg.heightAnchor.constraint(equalTo: self.view.widthAnchor, constant: -4).isActive = true
        self.view.isOpaque = false
        self.editButton.layer.cornerRadius = 8
        self.parentVC?.tabBarController?.delegate = self
        self.clearHeader()
        editButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        profileImg.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.centerXAnchor.constraint(equalTo: profileImg.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: profileImg.centerYAnchor).isActive = true

        loading.startAnimating()
        loading.isHidden = true
        loading.color = UIColor.red
        if let profImage = profImage {
            profileImg.image = profImage
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        recognizer.direction = .down
        self.view.addGestureRecognizer(recognizer)
        addZoombehavior(for: profileImg, settings: .instaZoomSettings)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func closeClicked(_ sender: Any) {
        self.dismissVC()
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
extension BiggerPictureEditViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if parentVC!.tabBarController!.selectedIndex != 4 {
            self.dismissVC()
        }
    }
}


extension BiggerPictureEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
     @objc func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("qwe")
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        loading.startAnimating()
        loading.isHidden = false
        
        
        
        let img = image
        let config = CLDConfiguration(cloudName: "divfjwrpa", apiKey: "2ljI1k92Jow0EulTwDSntlsPfH4")
        let cloudinary = CLDCloudinary(configuration: config)
        
        let data = img.jpeg(.lowest)
        let request = cloudinary.createUploader().upload(data: data!, uploadPreset: "ml_default")
        request.response { [weak self] (result, err) in
            if err == nil {
                if let url = result?.url {
                    
                    let params: Parameters = ["userId": CurrentUser.shared.userId ?? "",
                                              "url": url]
                
                    
                    let h: HTTPHeaders = ["Content-Type": "application/json",
                                          "Accept": "application/json", "Authorization": UserDefaults.standard.string(forKey: "AuthJWT")!]
                    print(CurrentUser.shared.userId ?? "")
                    Alamofire.request(URL(string: "http://ec2-18-156-84-119.eu-central-1.compute.amazonaws.com/api/v1/user/updateProfileImg")!, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: h ).responseJSON { (response) in
                        print(response)
                        self?.loading.isHidden = true
                        self?.profileImg.image = image
                        self?.parentVC?.profileImage.image = image
                        CurrentUser.shared.profileImgUrl = url
                    }
                }
                print("res: \(result?.url)")
            }
        }
    }
}
