//
//  WatcherCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 16.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyShadow

class WatcherCell: UITableViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNAmeSurnameLabel: UILabel!
    @IBOutlet weak var profileSectorLabel: UILabel!
    @IBOutlet weak var watchingWatcherButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        watchingWatcherButton.layer.cornerRadius = 8
        self.profileImg.layer.cornerRadius = self.profileImg.frame.width/2
        self.cellContainerView.layer.cornerRadius = 13
//        self.cellContainerView.layer.shadowRadius = 5
//        self.cellContainerView.layer.shadowOpacity = 0.04
//        self.cellContainerView.layer.shadowColor = UIColor.black.cgColor
//        self.cellContainerView.layer.shadowOffset = CGSize.zero
        //self.cellContainerView.generateOuterShadow()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func watchingWatcherButtonClicked(_ sender: Any) {
    }
    
}
