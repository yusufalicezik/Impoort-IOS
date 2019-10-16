//
//  HomeViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 6.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyShadow
import ListPlaceholder

class HomeViewController: BaseViewController {

    @IBOutlet weak var quickShareViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var quickShareView: UIView!
    @IBOutlet weak var quickShareGreenView: UIView!
    @IBOutlet weak var quickShareLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topRightButton:UIButton!
    var prevOffset:CGFloat = 0.0
    let refreshControl = UIRefreshControl()
    var isScrollingTopEnable = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        isScrollingTopEnable = true
        super.viewWillAppear(animated)
        self.tableView.showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.tableView.hideLoader()
        }
    }
    func setup(){
        self.tabBarController!.tabBar.layer.borderWidth = 0.25
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController!.tabBar.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.refreshControl.tintColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        let shareRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToShareQuickly))
        self.quickShareView.isUserInteractionEnabled = true
        self.quickShareView.addGestureRecognizer(shareRecognizer)
        
        self.quickShareGreenView.layer.cornerRadius = 10
        self.quickShareGreenView.layer.shadowRadius = 10
        self.quickShareGreenView.layer.shadowOpacity = 0.14
        self.quickShareGreenView.layer.shadowColor = UIColor.black.cgColor
        self.quickShareGreenView.layer.shadowOffset = CGSize.zero
        self.quickShareGreenView.generateOuterShadow()
        
        self.tabBarController?.delegate = self

        
    }
    @objc func refreshWeatherData(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now()+4){
            self.refreshControl.endRefreshing()
        }
    }

    @IBAction func messagesButtonClicked(_ sender: Any) {
        self.goToMessagesGeneral()
    }
    
    @objc func goToShareQuickly(){
        let shareVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ShareVC") as? ShareViewController
        shareVc?.openedFromTab = false
        self.present(shareVc!, animated: true, completion: nil)
    }
    
}
extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
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
extension HomeViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
            let offsetY = scrollView.contentOffset.y
            if offsetY < 0 {
                scrollView.contentOffset.y = CGFloat(0.0)
                UIView.animate(withDuration: 0.2){
                    //self.view.layoutIfNeeded()
                }
            }
            else if offsetY > prevOffset && offsetY > 0.0{
                self.quickShareViewHeightConstraint.constant = 0.0
                quickShareLabel.isHidden = true
            }else{
                self.quickShareViewHeightConstraint.constant = 55.0
                quickShareLabel.isHidden = false
                
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25){
                    self.view.layoutIfNeeded()
                }
            }
            self.prevOffset = offsetY
        }else if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                //self.tableView.reloadData() paging.
            }
        }else if (scrollView.contentOffset.y < 0){
            //reach top
        }
        
    }
}
extension HomeViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 && isScrollingTopEnable {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }else{
            isScrollingTopEnable = false
        }
    }
}
