//
//  ExperiencesCollectionViewCell.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 22.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class ExperiencesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var departmentView: UIView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.experienceLabel.layer.cornerRadius = 9
        self.experienceLabel.layer.masksToBounds = true
        self.departmentLabel.layer.cornerRadius = 7
        self.departmentLabel.layer.masksToBounds = true

    }
}
