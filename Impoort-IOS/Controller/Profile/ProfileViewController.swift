//
//  ProfileViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 9.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class ProfileViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var profileImageHeight:NSLayoutConstraint!
    @IBOutlet weak var profileImageWidth:NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var headerBarView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var barHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var barWidthConstraint: NSLayoutConstraint!
    
    let titles = ["Posts", "Watcher", "Watching"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //let frame = CGRect(x: 5, y:  200, width: view.frame.width - 10, height: 40)
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.segmentsBackgroundColor = #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
        segmentedControl.sliderBackgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        segmentedControl.defaultTextColor = #colorLiteral(red: 0.9725490196, green: 0.9450980392, blue: 0.9803921569, alpha: 0.9276808647)
        segmentedControl.highlightTextColor = #colorLiteral(red: 0.9725490196, green: 0.9450980392, blue: 0.9803921569, alpha: 0.9276808647)
        segmentedControl.isSliderShadowHidden = false
        segmentedControl.delegate = self
        segmentContainerView.addSubview(segmentedControl)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.topAnchor.constraint(equalTo: self.segmentContainerView.topAnchor, constant: 0.0).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.segmentContainerView.rightAnchor, constant: 0.0).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: self.segmentContainerView.leftAnchor, constant: 0.0).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: self.segmentContainerView.bottomAnchor, constant: 0.0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }

  
    @IBAction func messageButtonClicked(_ sender: Any) {
        self.goToMessagesGeneral()
    }
    @IBAction func settingsButtonClicked(_ sender: Any) {
        self.goToSettingsVC()
    }
    
}
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row % 3 == 0{
            cell = Bundle.main.loadNibNamed("PostCell", owner: self, options: nil)?.first as! PostCell
        }else{
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension ProfileViewController:TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        print("asd")
    }
}
//tableview ve scroll kısımları nib olarak farklı viewlarda olacak, post, takip, takipci
extension ProfileViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            self.profileImageHeight?.constant = 160.0
            self.profileImageWidth?.constant = 160.0
            self.barWidthConstraint?.constant = 0.0
            self.barHeightConstraint?.constant = 0.0
            addToTop()
        }else if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
           self.profileImageHeight?.constant = 0
           self.profileImageWidth?.constant = 0
           self.barWidthConstraint?.constant = 35.0
           self.barHeightConstraint?.constant = 35.0
           //self.barImageView.layer.masksToBounds = true
           self.barImageView.layer.cornerRadius = self.barImageView.frame.width / 2
//            self.profileImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
//            self.profileImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true

            
        }
        UIView.animate(withDuration: 0.5){
            //self.parentVC?.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    
    func addToTop(){
        
    }
}
