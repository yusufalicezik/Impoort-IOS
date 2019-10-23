//
//  NewProfileViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 22.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import Pastel
import SwiftyShadow

class NewProfileViewController: BaseViewController {
   

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContainerView: UIView!
    var pastelView : PastelView?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var experiencesStackView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    let experiences = ["Nuevo Softwarehouse", "Özgür Yazılım AŞ", "BTPro Yazılım Çözümleri", "Microsoft", "Apple", "Oracle"]
    let experiencesDepartment = ["IOS Developer", "Java Developer", "Middle IOS Developer", ".Net Developer", "Senior IOS Developer", "Software Developer"]
    var isDarkHeader = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        pastelView = PastelView(frame: topContainerView.bounds)
        pastelView!.startPastelPoint = .bottomLeft
        pastelView!.endPastelPoint = .topRight
        pastelView!.animationDuration = 2.0
        pastelView!.setColors([#colorLiteral(red: 0.2392156863, green: 0.3098039216, blue: 0.4588235294, alpha: 1),
                               #colorLiteral(red: 0.412048799, green: 0.5332120053, blue: 0.7917790292, alpha: 1),
                               #colorLiteral(red: 0.1269120915, green: 0.4231440355, blue: 0.2988528522, alpha: 0.8982234589)])
        topContainerView.insertSubview(pastelView!, at: 0)
        self.profileImage.layer.shadowRadius = 20
        self.profileImage.layer.shadowOpacity = 0.54
        self.profileImage.layer.shadowColor = UIColor.black.cgColor
        self.profileImage.layer.shadowOffset = CGSize.zero
        self.profileImage.generateOuterShadow()
        // Do any additional setup after loading the view.
        scrollView.delaysContentTouches = false
        scrollView.delegate = self
        getExperiences()
    }
    override func viewWillAppear(_ animated: Bool) {
            clearHeader()
        pastelView?.startAnimation()
    }
    
    @IBAction func didMoreClicked(_ sender: Any) {
        self.goToProfileDetails()
    }
    
    
    func getExperiences(){
        for i in 0..<experiences.count{
            let mView = Bundle.main.loadNibNamed("ExperienceView", owner: self, options: nil)?.first as? ExperienceView
            mView?.companyNameLabel.text = experiences[i]
            mView?.departmentLabel.text = experiencesDepartment[i]
            self.experiencesStackView.addArrangedSubview(mView!)
            mView?.translatesAutoresizingMaskIntoConstraints = false
            mView?.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
            mView?.centerXAnchor.constraint(equalTo: self.experiencesStackView.centerXAnchor, constant: 0.0).isActive = true
//            mView?.leftAnchor.constraint(equalTo: self.experiencesStackView.leftAnchor, constant: 10).isActive = true
//            mView?.rightAnchor.constraint(equalTo: self.experiencesStackView.rightAnchor, constant: -10).isActive = true

            
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkHeader{
            return .lightContent
        }else{
            return .default
        }

    }

    func clearHeader(){
        UIView.animate(withDuration: 0.3){
            self.headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

}
extension NewProfileViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView.contentOffset.y >= 160{
            UIView.animate(withDuration: 0.3){
                self.headerView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                self.isDarkHeader = true
            }
        }else{
            UIView.animate(withDuration: 0.3){
                self.headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.isDarkHeader = false
            }
        }
        setNeedsStatusBarAppearanceUpdate()
    }
}
