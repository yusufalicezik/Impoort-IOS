//
//  CommentPostOwnerCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 21.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class CommentPostOwnerCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePostDescription: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var bottomLineHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImg.layer.cornerRadius = self.profileImg.frame.width/2
        self.bottomLineHeightConstraint.constant = 0.5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
