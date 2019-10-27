//
//  BiggerPictureEditViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 17.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import Zoomy

class BiggerPictureEditViewController: BaseViewController {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    var parentVC:NewProfileViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImg.translatesAutoresizingMaskIntoConstraints = false
        self.profileImg.heightAnchor.constraint(equalTo: self.view.widthAnchor, constant: -4).isActive = true
        self.view.isOpaque = false
        self.editButton.layer.cornerRadius = 8
        self.parentVC?.tabBarController?.delegate = self
        self.clearHeader()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       // self.profileImg.layer.cornerRadius = self.view.frame.width/2
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        recognizer.direction = .down
        self.view.addGestureRecognizer(recognizer)
        addZoombehavior(for: profileImg, settings: .instaZoomSettings)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
extension BiggerPictureEditViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if parentVC!.tabBarController!.selectedIndex != 4 {
            self.dismissVC()
        }
    }
}
