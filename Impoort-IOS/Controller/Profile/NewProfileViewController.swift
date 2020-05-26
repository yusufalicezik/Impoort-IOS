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
import SDWebImage

class NewProfileViewController: BaseViewController {
    
    
    @IBOutlet weak var headerProfileImage: UIImageView!
    @IBOutlet weak var headerProfileImageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var headerProfileImageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topLeftIcon: UIButton!
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutStackView: UIStackView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var experiencesStackView: UIStackView!
    @IBOutlet weak var linksStackView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var contactMailLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    var currentExperienceViews = [ExperienceView]()
    var currentLinkViews = [LinksView]()
    var pastelView : PastelView?
    
    
    var profileTopLeftAction:(()->())!
    var profileID: String = ""
    var isClosed = false
    var firstLoadAppear = false
    
    var experiences: [String] = []
    var experiencesDepartment: [String] = []
    
    var linkNames: [String] = []
    var linkAdresses: [String] = []
    var isDarkHeader = false
    
    private var profileDetails: UserResponseDTO? = UserResponseDTO(active: true, activeGuide: "asd", birthDate: "123123", city: "İstanbul", confirmed: true, department: "iOS Geliştirici", _description: "iOS Developer at Appcent", email: "yusuf.cezik@appcent.mobi", employeeCount: 2, employees: nil, experiences:[
        
        Experience(companyId: "asd", companyName: "Appcent", department: "iOS Developer", experienceId: 2, stillWork: true, workerId: "dd"),
         Experience(companyId: "ased", companyName: "Nuevo Softwarehouse", department: "iOS Intern", experienceId: 2, stillWork: false, workerId: "dd"),
         Experience(companyId: "adsd", companyName: "Mercedes-Benz", department: "IT Intern", experienceId: 2, stillWork: false, workerId: "dd")
    
    
    ], firstName: "Yusuf Ali", fullName: "Yusuf Ali Cezik", gender: "Erkek", lastName: "Cezik", links: ["github": "/yusufalicezik", "facebook": "/yusufalicezik", "linkedin": "/klecon"], phoneNumber: "123123", profileImgUrl: "https://www.klasiksanatlar.com/img/sayfalar/b/1_1534620012_Ekran-Resmi-2018-08-18-22.25.18.png", userId: "23", userType: .developer, watcherCount: 123, watchingCount: 22, watchingPostCount: 2)
    private var userId: String = CurrentUser.shared.userId ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstLoadAppear = true
        setup()
    }
    
    
    func setup(){
        //self.profileID == userId
        if true {  // me
            self.topLeftIcon.setImage(UIImage(named: "settingsicon"), for: .normal)
            self.profileTopLeftAction = {[weak self] in
                self?.goToSettingsVC()
            }
        }else{
            self.topLeftIcon.setImage(UIImage(named: "close"), for: .normal)
            self.profileTopLeftAction = {[weak self] in
                self?.goToBack()
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
    
    private func fetchProfileDetails() {
                
        UserControllerAPI.getUserUsingGET(myId: userId, userId: userId) { [weak self] userResponse, error in
            if error == nil {
                self?.profileDetails = userResponse
                self?.updateUI()
            } else {
                print("Fetch profile error: \(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    private func updateUI() {
        guard let profileDetails = self.profileDetails else { return }
        
        if let exps = profileDetails.experiences?.map({ $0.companyName ?? "" }), let expsDepartment = profileDetails.experiences?.map({ $0.department ?? "" }) {
            if exps.count != expsDepartment.count { return }
            self.experiences = exps
            self.experiencesDepartment = expsDepartment
        }

        
        if let links = profileDetails.links {
            self.linkNames.removeAll()
            self.linkAdresses.removeAll()
            for (key, value) in links {
                self.linkNames.append(key)
                self.linkAdresses.append(value)
            }
        }
        
        if let expsDepartment = profileDetails.experiences?.map({ $0.department ?? "" }) {
            self.experiencesDepartment = expsDepartment
        }
        
        
        if let url = URL(string: profileDetails.profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png") {
            headerProfileImage.sd_setImage(with: url, completed: nil)
            profileImage.sd_setImage(with: url, completed: nil)
        }
        
        nameSurnameLabel.text = profileDetails.fullName ?? ""
        departmentLabel.text = profileDetails.department ?? ""
        locationLabel.text = profileDetails.city ?? ""
        aboutLabel.text = profileDetails._description ?? ""
        contactMailLabel.text = profileDetails.email ?? ""
        contactPhoneLabel.text = profileDetails.phoneNumber ?? ""
        
        DispatchQueue.main.async{
            self.getAbout()
        }
        DispatchQueue.main.async {
            self.getExperiences()
        }
        DispatchQueue.main.async {
            self.getLinks()
        }
        
    }
    
    
    func getAbout(){
        self.aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        self.aboutLabel.heightAnchor.constraint(equalToConstant: CGFloat(self.aboutLabel.calculateMaxLines()*18)).isActive = true
        
    }
    
    @objc func openBiggerProfileImage(){
        let bgVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "BiggerPictureEditVC") as? BiggerPictureEditViewController
        bgVC?.parentVC = self
        bgVC?.profImage = profileImage.image
        bgVC?.modalPresentationStyle = .overCurrentContext
        self.present(bgVC!, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clearHeader()
        fetchProfileDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        clearExperiencesAndLinksView()
        
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
    
    deinit{
        print("new de init")
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
    
    @IBAction func workersButtonClicked(_ sender: Any) {
        let workersVC = UIStoryboard(name: "External", bundle: nil).instantiateViewController(withIdentifier: "WorkersVC") as? WorkersViewController
        workersVC?.modalPresentationStyle = .overCurrentContext
        self.present(workersVC!, animated: true, completion: nil)
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
