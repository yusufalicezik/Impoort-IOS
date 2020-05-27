//
//  PostDetailViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 21.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SDWebImage

class PostDetailViewController: BaseViewController {

    @IBOutlet weak var postProfileImg: UIImageView!
    @IBOutlet weak var postOwnerNameSurnameLabel: UILabel!
    @IBOutlet weak var postOwnerSectorLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    var post: PostResponseDTO?
    //var post = Post()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postProfileImg.layer.cornerRadius = self.postProfileImg.frame.width/2
        self.isHiddenImage()
    }
    func setup(){
        self.addSwipeDismiss(vc: self)
        if let mPost = self.post {
            if mPost.postType! == 1 { //with image post
                guard let url = URL(string: post?.mediaUrl ?? "") else { return }
                self.postImage.sd_setImage(with: url , completed: nil)
            } else {
                postImageHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.postImage.isHidden = true
            }
            
            if let profileUrl = URL(string: post?.user?.profileImgUrl ?? "") {
                postProfileImg.sd_setImage(with: profileUrl, completed: nil)
            }
            postOwnerSectorLabel.text = post?.user?.department ?? ""
            postOwnerNameSurnameLabel.text = (post?.user?.firstName ?? "") + (post?.user?.lastName ?? "")
            postDescriptionLabel.text = post?.postDescription ?? ""
        }
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    private func isHiddenImage(){
//        self.postImageHeightConstraint.constant = 0.0
//        self.view.layoutIfNeeded()
        //if post type == 1. hidden/constant = 0 postimg. vs.
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
    }
    @IBAction func commentButtonClicked(_ sender: Any) {
        guard let mPost = self.post else { return }
        self.goToCommentViewController(id: mPost)
    }
    @IBAction func watchButtonClicked(_ sender: Any) {
    }
}
