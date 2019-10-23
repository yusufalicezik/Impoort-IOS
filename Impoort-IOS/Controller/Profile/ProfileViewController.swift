//
//  ProfileViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 9.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//
import UIKit
import TwicketSegmentedControl
import SwiftyShadow
import SDWebImage
class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var headerBarView: UIView!
    @IBOutlet weak var barHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var barWidthConstraint: NSLayoutConstraint!
    
    let titles = ["Posts", "Watcher", "Watching"]
    lazy var postsView:PostsView = PostsView()
    lazy var profileBiggestView:ProfileBiggest = ProfileBiggest()
    var isDarkHeader = false
    var isChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        self.barImageView.layer.cornerRadius = self.barImageView.frame.width / 2
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.segmentsBackgroundColor = #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
        segmentedControl.sliderBackgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
        segmentedControl.defaultTextColor = #colorLiteral(red: 0.9725490196, green: 0.9450980392, blue: 0.9803921569, alpha: 0.9276808647)
        segmentedControl.highlightTextColor = #colorLiteral(red: 0.9725490196, green: 0.9450980392, blue: 0.9803921569, alpha: 0.9276808647)
        segmentedControl.isSliderShadowHidden = false
        segmentedControl.delegate = self
        segmentContainerView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.topAnchor.constraint(equalTo: self.segmentContainerView.topAnchor, constant: 0.0).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.segmentContainerView.rightAnchor, constant: 0.0).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: self.segmentContainerView.leftAnchor, constant: 0.0).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: self.segmentContainerView.bottomAnchor, constant: 0.0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        loadPostsView(senderType: .posts)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            if isDarkHeader{
                return .lightContent
            }else{
                return .default
            }
    }
    override func viewWillDisappear(_ animated: Bool) {
            clearHeader()
            isChanged = true
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
        clearHeader()
    }
    
    @IBAction func messageButtonClicked(_ sender: Any) {
        self.goToMessagesGeneral()
    }

    
    func loadPostsView(senderType:SenderProfileTyle){
        self.postsView.removeFromSuperview()
        self.postsView = (Bundle.main.loadNibNamed("PostsView", owner: self, options: nil)?.first as? PostsView)!
        postsView.parentVC = self
        self.postsView.senderProfileType = senderType
        self.postsView.load()
    }
    func loadWatcherView(senderType:SenderProfileTyle){
            if let _ = self.postsView.superview {
            self.postsView.removeFromSuperview()
            self.postsView.senderProfileType = senderType
            self.postsView.load()
        }
    }
    @objc func swipeLeft(){
        print("swipped")
    }
    @objc func openProfilePictureBig(){
        
        let bgVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "BiggerPictureEditVC") as? BiggerPictureEditViewController
        bgVC?.modalPresentationStyle = .overCurrentContext
        self.present(bgVC!, animated: true, completion: nil)
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.3){
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.isDarkHeader = false
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.goToBack()
    }
    
    func clearHeader(){
        UIView.animate(withDuration: 0.3){
            self.isDarkHeader = false
            self.headerBarView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
}
extension ProfileViewController:TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        clearHeader()
        switch segmentIndex {
        case 0:
            loadPostsView(senderType: .posts)
        case 1:
            loadPostsView(senderType: .watcher)
        default:
            loadPostsView(senderType: .watching)
        }
    }
}

extension ProfileViewController : UIScrollViewDelegate{

    
}
