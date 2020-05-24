//
//  SuggestedCollectionCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 22.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SDWebImage

class SuggestedCollectionCell: UICollectionViewCell {
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileSectorLabel: UILabel!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.width/2
        self.watchButton.layer.cornerRadius = 7
        self.containerView.layer.cornerRadius = 12
    }
    
    func configCell(imageUrl: String) {
        
    }
    
    @IBAction func watchButtonClicked(_ sender: Any) {
    }
}
