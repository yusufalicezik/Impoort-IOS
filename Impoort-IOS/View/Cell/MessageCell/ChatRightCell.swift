//
//  ChatRightCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class ChatRightCell: UITableViewCell {
@IBOutlet weak var messageContentView: UIView!
     @IBOutlet weak var messageTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageContentView.layer.cornerRadius = 17
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
