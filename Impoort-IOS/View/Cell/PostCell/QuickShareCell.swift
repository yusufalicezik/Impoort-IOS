//
//  QuickShareCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 18.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class QuickShareCell: UITableViewCell {

    @IBOutlet weak var asd: UIView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.asd.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
