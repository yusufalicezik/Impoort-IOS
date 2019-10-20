//
//  BiggerPictureEditViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 17.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class BiggerPictureEditViewController: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImg.translatesAutoresizingMaskIntoConstraints = false
        self.profileImg.heightAnchor.constraint(equalTo: self.view.widthAnchor, constant: -4).isActive = true
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profileImg.layer.cornerRadius = self.view.frame.width/2
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        recognizer.direction = .down
        self.view.addGestureRecognizer(recognizer)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closeClicked(_ sender: Any) {
        self.dismissVC()
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
}
