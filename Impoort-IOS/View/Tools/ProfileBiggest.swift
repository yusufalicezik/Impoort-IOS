//
//  ProfileBiggest.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 17.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class ProfileBiggest: UIView {

    @IBOutlet weak var profileImg:UIImageView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(closePage))
        self.addGestureRecognizer(recognizer)
    }
//    func configView(_ parentVC:ProfileViewController, _ addedView:ProfileBiggest){
//            parentVC.view.addSubview(addedView)
//            addedView.translatesAutoresizingMaskIntoConstraints = false
//            addedView.profileImg.translatesAutoresizingMaskIntoConstraints = false
//            addedView.leftAnchor.constraint(equalTo: parentVC.view.leftAnchor, constant: 0.0).isActive = true
//            addedView.rightAnchor.constraint(equalTo: parentVC.view.rightAnchor, constant: 0.0).isActive = true
//            addedView.profileImg.heightAnchor.constraint(equalToConstant: parentVC.view.frame.width).isActive = true
//            addedView.centerYAnchor.constraint(equalTo: parentVC.view.centerYAnchor, constant: 0.0).isActive = true
//            addedView.topAnchor.constraint(equalTo: parentVC.view.topAnchor, constant: 0.0).isActive = true
//            addedView.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor, constant: 0.0).isActive = true
//     
//        
//    }


    @objc func closePage(){
        self.removeFromSuperview()
    }
}
