//
//  ShareViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 14.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

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
    @IBOutlet weak var postTxtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgParentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgParentCloseButtonHEightConst: NSLayoutConstraint!
    var postType:PostType = .normalPost //post modeline postTyle.rawValue gönderilecek. 0 sa normal post, 1 ise fotoğraflı post.
    var openedFromTab = true
    var topRightButtonAction:(()->Void)!
    var imagePicker = UIImagePickerController()
    
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
        self.postDescriptionTxtView.delegate = self
        self.postDescriptionTxtView.layer.cornerRadius = 12
        self.shareButton.layer.cornerRadius = 11
        self.addImgButton.layer.cornerRadius = 11
        self.postImageView.layer.cornerRadius = 12
        self.postImageView.clipsToBounds = true
        self.closeButton.layer.cornerRadius = 12
        self.closeButton.clipsToBounds = true
        self.imgViewParent.backgroundColor = .clear
        postDescriptionTxtView.text = "What do you want to share about?"
        postDescriptionTxtView.textColor = UIColor.lightGray
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
        if postDescriptionTxtView.textColor == UIColor.lightGray {
            postDescriptionTxtView.text = ""
            postDescriptionTxtView.textColor = #colorLiteral(red: 0.07843137255, green: 0.2509803922, blue: 0.3882352941, alpha: 0.5303135702)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postDescriptionTxtView.text == "" {
            postDescriptionTxtView.text = "What do you want to share about?"
            postDescriptionTxtView.textColor = UIColor.lightGray
        }
        if postDescriptionTxtView.text.count < 80{
            decreasePostViewHeight()
        }
    }

    func decreasePostViewHeight(){
        self.postTxtHeightConstraint.constant = 70
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    

    @IBAction func shareButtonClicked(_ sender: Any) {
        print(postType)
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
