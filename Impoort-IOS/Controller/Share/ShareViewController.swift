//
//  ShareViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 14.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ShareViewController: UIViewController,UITextViewDelegate{

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addImgButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imgViewParent: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescriptionTxtView: UITextView!
    @IBOutlet weak var postTxtHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgParentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgParentCloseButtonHEightConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        
    }
    func setup(){
        self.postDescriptionTxtView.delegate = self
        self.postDescriptionTxtView.layer.cornerRadius = 12
        self.shareButton.layer.cornerRadius = 11
        self.addImgButton.layer.cornerRadius = 11
        self.postImageView.layer.cornerRadius = 12
        self.postImageView.clipsToBounds = true
        self.closeButton.layer.cornerRadius = 12
        self.closeButton.clipsToBounds = true
        //self.postDescriptionTxtView.layer.borderWidth = 0.5
        //self.postDescriptionTxtView.layer.borderColor = #colorLiteral(red: 0.07843137255, green: 0.2509803922, blue: 0.3882352941, alpha: 0.5303135702)
        
        self.imgViewParent.backgroundColor = .clear
        
        postDescriptionTxtView.text = "What do you want to share about?"
        postDescriptionTxtView.textColor = UIColor.lightGray
        IQKeyboardManager.shared.enable = true

        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.postDescClicked()
        if postDescriptionTxtView.textColor == UIColor.lightGray {
            postDescriptionTxtView.text = ""
            postDescriptionTxtView.textColor = UIColor.black
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
    }
    
    @objc func postDescClicked(){
        self.postTxtHeightConstraint.constant = 260
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addImageButtonClicked(_ sender: Any) {
        self.postImageView.image = UIImage(named: "img")
        self.closeButton.isHidden = false
        imgParentViewHeightConstraint.constant = 260.0
        UIView.animate(withDuration: 0.3){
            
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func deleteImageButtonClicked(_ sender: Any) {
        self.closeButton.isHidden = true
        imgParentViewHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    
}
