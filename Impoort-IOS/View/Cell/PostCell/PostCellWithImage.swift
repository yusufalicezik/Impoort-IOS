//
//  PostCellWithImage.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyShadow
import SDWebImage

protocol PostCellDelegate{
    func didSelectPost(_ id:Int)
    func didSelectReadMore(_ id:Int)
    func didClickedProfilePic() //id gönderilecek
}

class PostCellWithImage: UITableViewCell {

    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var bottomLineViewCostraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var sectorTxtField: UILabel!
    @IBOutlet weak var nameSurnameTxtFied: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    var post: PostResponseDTO? {
        didSet {
            if PostType(rawValue: post?.postType ?? 0) == PostType.withPhotoPost {
                postImage.sd_setImage(with: URL(string: (post?.mediaUrl!)!), completed: nil)
            }
            profileImage.sd_setImage(with: URL(string: (post?.user?.profileImgUrl!)!)!, completed: nil)
            sectorTxtField.text = post?.user?.department!
            dateLabel.text = post?.createdDateTime!
            
            tagsLabel.isHidden = true
            if let tags = post?.tags {
                if tags.count != 0 {
                    tagsLabel.isHidden = false
                    tagsLabel.text = ""
                    post?.tags?.forEach {
                        tagsLabel.text! += "#\($0)"
                    }
                }
            }
            
            likeButton.setTitle("\(post?.likeCount! ?? 0) likes", for: .normal)
        }
    }
    var parentVC:UIViewController?
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    var  perDelegate:PostCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configCell(){
        self.postContainerView.layer.cornerRadius = 6
//        self.postContainerView.layer.shadowRadius = 6
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
//        self.postContainerView.layer.shadowOpacity = 0.10
//        self.postContainerView.layer.shadowColor = UIColor.black.cgColor
//        self.postContainerView.layer.shadowOffset = CGSize.zero
//        self.postContainerView.generateOuterShadow()
        self.postImage.layer.cornerRadius = 4
        
        self.lineViewHeightConst.constant = 1.5
        self.bottomLineViewCostraint.constant = 1.5
        self.postContainerView.layer.borderWidth = 0.3
        self.postContainerView.layer.borderColor = #colorLiteral(red: 0.8486782908, green: 0.8487772346, blue: 0.8486338258, alpha: 1)
        
        self.likeButton.layer.borderWidth = 0.5
        self.likeButton.layer.cornerRadius = 6
        self.likeButton.layer.borderColor = #colorLiteral(red: 0.8486782908, green: 0.8487772346, blue: 0.8486338258, alpha: 1)
        self.replyButton.layer.borderWidth = 0.5
        self.replyButton.layer.cornerRadius = 6
        self.replyButton.layer.borderColor = #colorLiteral(red: 0.8486782908, green: 0.8487772346, blue: 0.8486338258, alpha: 1)
        
        let postClickRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedPost))
        self.addGestureRecognizer(postClickRecognizer)
        let readMoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedReadMore))
        self.postDescription.addGestureRecognizer(readMoreRecognizer)
        
        let postProfileImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileClicked))
        self.profileImage.isUserInteractionEnabled = true
        self.profileImage.addGestureRecognizer(postProfileImageRecognizer)
    }
    @objc func clickedPost(){
        //perDelegate?.didSelectPost(self.postID!) //postun kendisi gönderilecek.
    }
    @IBAction func readMoreClicked(_ sender: Any) {
        perDelegate?.didSelectPost((self.post?.postId!)!)
    }
    @objc func clickedReadMore(){
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @objc func profileClicked(){
        perDelegate?.didClickedProfilePic()
    }

    func hiddenReadMore(){
        
    }
    
}
