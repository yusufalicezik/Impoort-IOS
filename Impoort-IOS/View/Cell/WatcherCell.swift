//
//  WatcherCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 16.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class WatcherCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameSurnameTxtLabel: UILabel!
    @IBOutlet weak var sectorTxtLabel: UILabel!
    @IBOutlet weak var watchWatchingButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.watchWatchingButton.layer.cornerRadius = 11
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func watchWatchingButtonClicked(_ sender: Any) {
    }
    
}
