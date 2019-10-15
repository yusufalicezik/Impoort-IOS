//
//  ProfilePropertiesCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 15.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class ProfilePropertiesCell: UITableViewCell {

    @IBOutlet weak var propertyNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.propertyNameLabel.layer.cornerRadius = 5
        self.propertyNameLabel.layer.masksToBounds = true

        // Configure the view for the selected state
    }

}
