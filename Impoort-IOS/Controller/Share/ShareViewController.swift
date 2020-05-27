//
//  ShareViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 14.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Cloudinary


enum PostType : Int{
    case normalPost = 0, withPhotoPost
}

class ShareViewController: BaseViewController,UITextViewDelegate{

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addImgButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imgViewParent: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescriptionTxtView: UITextView!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var postTitleTxtField: UITextField!
    @IBOutlet weak var postTxtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgParentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgParentCloseButtonHEightConst: NSLayoutConstraint!
    var postType:PostType = .normalPost //post modeline postTyle.rawValue gönderilecek. 0 sa normal post, 1 ise fotoğraflı post.
    var openedFromTab = true
    var topRightButtonAction:(()->Void)!
    var imagePicker = UIImagePickerController()
    var isTag = false
    var isTagFirstTime = false
    var currentTag = ""
    var textColorBlue:UIColor?
    var tagList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()
    }
    
    func setup(){
        if self.openedFromTab{
            let topRightIcon = UIImage(named: "messageicon")
            topRightButton.setImage(topRightIcon, for: .normal)
            topRightButtonAction = {
                self.goToMessagesGeneral()
            }
        }else{
            let topRightIcon = UIImage(named: "close")
            topRightButton.setImage(topRightIcon, for: .normal)
            topRightButtonAction = {
                self.goToBack()
            }
        }
        self.textColorBlue = self.postDescriptionTxtView.textColor
        self.postTitleTxtField.layer.cornerRadius = 12
        self.postDescriptionTxtView.delegate = self
        self.postDescriptionTxtView.layer.cornerRadius = 12
        self.shareButton.layer.cornerRadius = 11
        self.addImgButton.layer.cornerRadius = 11
        self.postImageView.layer.cornerRadius = 12
        self.postImageView.clipsToBounds = true
        self.closeButton.layer.cornerRadius = 12
        self.closeButton.clipsToBounds = true
        self.imgViewParent.backgroundColor = .clear
        postDescriptionTxtView.text = "What is the description of your topic?"
        postDescriptionTxtView.textColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func clearHeader(){
        UIView.animate(withDuration: 0.2){
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.postDescClicked()
        if postDescriptionTxtView.textColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
            postDescriptionTxtView.text = ""
            postDescriptionTxtView.textColor = #colorLiteral(red: 0.07843137255, green: 0.2509803922, blue: 0.3882352941, alpha: 0.5303135702)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postDescriptionTxtView.text == "" {
            postDescriptionTxtView.text = "What is the description of your topic?"
            postDescriptionTxtView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        if postDescriptionTxtView.text.count < 80{
            decreasePostViewHeight()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text!.count == 0{
            isTag = false
        }
        if textView == self.postDescriptionTxtView{
            if textView.text!.last == "#"{
                isTag = true
            }else if textView.text!.last == " "{
                isTag = false
            }
        }
        if isTag{
            self.postDescriptionTxtView.typingAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), NSAttributedString.Key.font:UIFont(name: "Avenir-Medium", size: 15)!]

        }else{
            self.postDescriptionTxtView.typingAttributes = [NSAttributedString.Key.foregroundColor:textColorBlue!, NSAttributedString.Key.font:self.postDescriptionTxtView.font!]
        }
        return true
    }
    func decreasePostViewHeight(){
        self.postTxtHeightConstraint.constant = 70
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    

    @IBAction func shareButtonClicked(_ sender: Any) {
        print(postType)
        
        guard !postDescriptionTxtView.text.isEmpty else { return }
        
        var wordsOfDesc = postDescriptionTxtView.text.split(separator: "#")
        if wordsOfDesc.count > 0 && self.postDescriptionTxtView.text.first != "#"{
            wordsOfDesc.removeFirst()
        }
        for word in wordsOfDesc{
            let wordOfSpace = String(word).split(separator: " ")
            if wordOfSpace.count > 0{
                self.tagList.append(String(wordOfSpace[0]))
                print(String(wordOfSpace[0]))
            }
        }
        
        
        if postType == .withPhotoPost {
            let img = postImageView.image
            let config = CLDConfiguration(cloudName: "divfjwrpa", apiKey: "2ljI1k92Jow0EulTwDSntlsPfH4")
            let cloudinary = CLDCloudinary(configuration: config)
            
            let data = img!.jpeg(.lowest)
            let request = cloudinary.createUploader().upload(data: data!, uploadPreset: "ml_default")
            request.response { [weak self] (result, err) in
                guard let self = self else { return }
                if err == nil {
                    if let url = result?.url {
                        PostControllerAPI.addNewPostUsingPOST(postRequestDTO: PostRequestDTO(createdDateTime: nil , department: CurrentUser.shared.sector ?? "" , mediaUrl: url, postDescription: self.postDescriptionTxtView.text, postType: self.postType.rawValue, tags: self.tagList, userId: CurrentUser.shared.userId ?? "")) { (response, error) in
                            if error == nil {
                                AlertController.shared.showBasicAlert(viewCont: self, title: "Success", message: "New post shared!", buttonTitle: "Ok")
                                self.postType = .normalPost
                                self.closeButton.isHidden = true
                                self.imgParentViewHeightConstraint.constant = 0.0
                                self.tagList.removeAll()
                                UIView.animate(withDuration: 0.3){
                                    self.view.layoutIfNeeded()
                                }
                                self.postDescriptionTxtView.text = ""
                                
                            } else {
                                
                                AlertController.shared.showBasicAlert(viewCont: self, title: "Error \(error)", message: "Check your connection!", buttonTitle: "Ok")
                            }
                        }
                    }
                }
            }
        } else {
            PostControllerAPI.addNewPostUsingPOST(postRequestDTO: PostRequestDTO(createdDateTime: nil , department: CurrentUser.shared.sector ?? "" , mediaUrl: nil, postDescription: self.postDescriptionTxtView.text, postType: self.postType.rawValue, tags: self.tagList, userId: CurrentUser.shared.userId ?? "")) { (response, error) in
                if error == nil {
                    AlertController.shared.showBasicAlert(viewCont: self, title: "Success", message: "New post shared!", buttonTitle: "Ok")
                    self.postType = .normalPost
                    self.closeButton.isHidden = true
                    self.imgParentViewHeightConstraint.constant = 0.0
                    UIView.animate(withDuration: 0.3){
                        self.view.layoutIfNeeded()
                    }
                    self.postDescriptionTxtView.text = ""
                } else {
                    
                    AlertController.shared.showBasicAlert(viewCont: self, title: "Error \(error)", message: "Check your connection!", buttonTitle: "Ok")
                }
            }
        }
    }
    
    @objc func postDescClicked(){
        self.postTxtHeightConstraint.constant = 260
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addImageButtonClicked(_ sender: Any) {
        self.openGallery()
    }

    @IBAction func messagesButtonClicked(){
        self.topRightButtonAction()
    }
    @IBAction func deleteImageButtonClicked(_ sender: Any) {
        self.postType = .normalPost
        self.closeButton.isHidden = true
        imgParentViewHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    
}
extension ShareViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
     func openGallery(){
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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.postImageView.image = image
            self.postType = .withPhotoPost
            self.closeButton.isHidden = false
            self.imgParentViewHeightConstraint.constant = 260.0
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        })
    }
}
