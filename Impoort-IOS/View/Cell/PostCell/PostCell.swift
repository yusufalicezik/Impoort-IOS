//
//  PostCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 6.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var sectorTxtLabel: UILabel!
    @IBOutlet weak var nameSurnameTxtField: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileImgage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postContainerView.layer.cornerRadius = 10

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
