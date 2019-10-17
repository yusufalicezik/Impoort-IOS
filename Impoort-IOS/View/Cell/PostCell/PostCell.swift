//
//  PostCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 6.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyShadow

class PostCell: UITableViewCell {

    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var sectorTxtLabel: UILabel!
    @IBOutlet weak var nameSurnameTxtField: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileImgage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postContainerView.layer.cornerRadius = 10
        self.postContainerView.layer.shadowRadius = 10
        self.postContainerView.layer.shadowOpacity = 0.11
        self.postContainerView.layer.shadowColor = UIColor.black.cgColor
        self.postContainerView.layer.shadowOffset = CGSize.zero
        self.postContainerView.generateOuterShadow()
        self.profileImgage.layer.cornerRadius = self.profileImgage.frame.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        self.likeButton.setImage(UIImage(named: "iconlikeyes"), for: .normal)
    }
    
}
extension UIView {
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
