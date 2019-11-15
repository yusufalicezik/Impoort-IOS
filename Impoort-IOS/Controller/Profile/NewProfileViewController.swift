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
   

    @IBOutlet weak var headerProfileImage: UIImageView!
    @IBOutlet weak var headerProfileImageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var headerProfileImageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topLeftIcon: UIButton!
    var pastelView : PastelView?
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutStackView: UIStackView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var experiencesStackView: UIStackView!
    @IBOutlet weak var linksStackView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var currentExperienceViews = [ExperienceView]()
    var currentLinkViews = [LinksView]()

    
    var profileTopLeftAction:(()->())!
    var profileID = 0
    var isClosed = false
    var firstLoadAppear = false
    //bu ikisi tek sınıf olacak.
    let experiences = ["Nuevo Softwarehouse", "Özgür Yazılım AŞ", "BTPro Yazılım Çözümleri", "Microsoft", "Apple", "Oracle"]
    let experiencesDepartment = ["IOS Developer", "Java Developer", "Middle IOS Developer", ".Net Developer", "Senior IOS Developer", "Software Developer"]
    
    //bu ikisi tek sınıf olacak
    let linkNames = ["Github", "Facebook", "Linkedin"]
    let linkAdresses = ["/yusufalicezik", "/yusufali.cezik", "/yusuf-ali.cezik"]
    var isDarkHeader = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstLoadAppear = true
        setup()
    }

    
    func setup(){
        if self.profileID == 0{ // me
            self.topLeftIcon.setImage(UIImage(named: "settingsicon"), for: .normal)
            self.profileTopLeftAction = {
                self.goToSettingsVC()
            }
        }else{
            self.topLeftIcon.setImage(UIImage(named: "close"), for: .normal)
            self.profileTopLeftAction = {
                self.goToBack()
            }
        }
        self.headerProfileImage.layer.cornerRadius = self.headerProfileImage.frame.width / 2
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        pastelView = PastelView(frame: CGRect(x: 0, y: 0, width: topContainerView.frame.width+50, height: topContainerView.frame.height))
        pastelView!.startPastelPoint = .bottomLeft
        pastelView!.endPastelPoint = .topRight
        pastelView!.animationDuration = 1.4
        pastelView!.setColors([#colorLiteral(red: 0.2392156863, green: 0.3098039216, blue: 0.4588235294, alpha: 1),
                               #colorLiteral(red: 0.4117647059, green: 0.5333333333, blue: 0.7921568627, alpha: 1),
                               #colorLiteral(red: 0.1254901961, green: 0.4235294118, blue: 0.2980392157, alpha: 0.8982234589),
                               #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)])
        topContainerView.insertSubview(pastelView!, at: 0)
        self.profileImage.layer.shadowRadius = 20
        self.profileImage.layer.shadowOpacity = 0.54
        self.profileImage.layer.shadowColor = UIColor.black.cgColor
        self.profileImage.layer.shadowOffset = CGSize.zero
        self.profileImage.generateOuterShadow()
        let biggerImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(openBiggerProfileImage))
        self.profileImage.isUserInteractionEnabled = true
        self.profileImage.addGestureRecognizer(biggerImageRecognizer)
        scrollView.delaysContentTouches = false
        scrollView.delegate = self
  }
    
    func getAbout(){
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        label.text = "asdasdasdasdasdasd"
//        self.aboutStackView.addArrangedSubview(label)
        self.aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        self.aboutLabel.heightAnchor.constraint(equalToConstant: CGFloat(self.aboutLabel.calculateMaxLines()*18)).isActive = true
      
    }
    @objc func openBiggerProfileImage(){
        let bgVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "BiggerPictureEditVC") as? BiggerPictureEditViewController
        bgVC?.parentVC = self
        bgVC?.modalPresentationStyle = .overCurrentContext
        self.present(bgVC!, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        clearHeader()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        clearExperiencesAndLinksView()
        DispatchQueue.main.async{
            self.getAbout()
        }
        DispatchQueue.main.async {
            self.getExperiences()
        }
        DispatchQueue.main.async {
            self.getLinks()
        }
        isDarkHeader = false
        setNeedsStatusBarAppearanceUpdate()
        isClosed = false
        clearHeader()
        pastelView?.startAnimation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        isClosed = true
        self.clearHeader()
    }
    func clearExperiencesAndLinksView(){
        currentExperienceViews.forEach {
            $0.removeFromSuperview()
        }
        currentLinkViews.forEach {
            $0.removeFromSuperview()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.clearHeader()
    }
    
    @IBAction func didMoreClicked(_ sender: Any) {
        self.goToProfileDetails()
    }
    @IBAction func settingsClicked(_ sender: Any) {
        self.profileTopLeftAction()
    }
    @IBAction func messagesClicked(_ sender: Any) {
        self.goToMessagesGeneral()
    }
    
    func getExperiences(){
        self.currentExperienceViews.removeAll()
            for i in 0..<self.experiences.count{
                let mView = Bundle.main.loadNibNamed("ExperienceView", owner: self, options: nil)?.first as? ExperienceView
                mView?.companyNameLabel.text = self.experiences[i]
                mView?.departmentLabel.text = self.experiencesDepartment[i]
                self.experiencesStackView.addArrangedSubview(mView!)
                mView?.translatesAutoresizingMaskIntoConstraints = false
                mView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
                mView?.centerXAnchor.constraint(equalTo: self.experiencesStackView.centerXAnchor, constant: 0.0).isActive = true
                if i == 0{
                    mView?.icon.image = UIImage(named:"bigEx")
                    mView?.widthConst.constant = 22
                    mView?.leadingConst.constant = (mView?.leadingConst.constant)! - 3.5
                    mView?.topStackConst.constant = 0
                    mView?.layoutIfNeeded()
                }
                if i == self.experiences.count-1{
                    mView?.icon.image = UIImage(named:"normalExp")
                    mView?.layoutIfNeeded()
                }
                self.currentExperienceViews.append(mView!)
            }
    }
    func getLinks(){
        self.currentLinkViews.removeAll()
            for i in 0..<self.linkAdresses.count{
            let mView = Bundle.main.loadNibNamed("LinksView", owner: self, options: nil)?.first as? LinksView
                mView?.linkLabel.text = self.linkAdresses[i]
                switch self.linkNames[i].lowercased(){
            case "github":
                mView?.linkImageView.image = UIImage(named: "github")
            case "linkedin":
                mView?.linkImageView.image = UIImage(named: "linkedin35")
            case "facebook":
                mView?.linkImageView.image = UIImage(named: "facebook35")
            default:
                mView?.linkImageView.image = UIImage(named: "github")
            }
            mView?.linkImageView.contentMode = .scaleAspectFit
            self.linksStackView.addArrangedSubview(mView!)
            mView?.translatesAutoresizingMaskIntoConstraints = false
            mView?.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
            mView?.centerXAnchor.constraint(equalTo: self.linksStackView.centerXAnchor, constant: 0.0).isActive = true
                self.currentLinkViews.append(mView!)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkHeader{
            return .lightContent
        }else{
            return .default
        }
    }

    override func clearHeader(){
        UIView.animate(withDuration: 0.3){
            self.headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
extension NewProfileViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isClosed {
            if self.scrollView.contentOffset.y >= 375{
                self.headerProfileImageHeightConst.constant = 35.0
                self.headerProfileImageWidthConst.constant = 35.0
                UIView.animate(withDuration: 0.3){
                    self.headerView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                    UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                    self.isDarkHeader = true
                    self.headerView.layoutIfNeeded()
                    self.headerProfileImage.layer.cornerRadius = self.headerProfileImage.frame.width / 2
                }
            }else{
                UIView.animate(withDuration: 0.3){
                    self.headerProfileImageHeightConst.constant = 0.0
                    self.headerProfileImageWidthConst.constant = 0.0
                    self.headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.isDarkHeader = false
                    self.headerView.layoutIfNeeded()
                    self.headerProfileImage.layer.cornerRadius = self.headerProfileImage.frame.width / 2
                }
            }
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
