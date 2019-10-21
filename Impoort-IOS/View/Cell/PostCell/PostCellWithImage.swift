//
//  PostCellWithImage.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyShadow


protocol PostCellDelegate{
    func didSelectPost()
}

class PostCellWithImage: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var sectorTxtField: UILabel!
    @IBOutlet weak var nameSurnameTxtFied: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    var postID:Int? //burası modeller eklendikten sonra post olacak her şeyine erişebilmek için
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postContainerView.layer.cornerRadius = 10
        self.postContainerView.layer.shadowRadius = 10
        self.postContainerView.layer.shadowOpacity = 0.11
        self.postContainerView.layer.shadowColor = UIColor.black.cgColor
        self.postContainerView.layer.shadowOffset = CGSize.zero
        self.postContainerView.generateOuterShadow()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.postImage.layer.cornerRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
