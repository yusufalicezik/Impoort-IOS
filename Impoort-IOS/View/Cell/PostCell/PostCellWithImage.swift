//
//  PostCellWithImage.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class PostCellWithImage: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var postContainerView: UIView!
    @IBOutlet weak var sectorTxtField: UILabel!
    @IBOutlet weak var nameSurnameTxtFied: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postContainerView.layer.cornerRadius = 10
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.postImage.layer.cornerRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
