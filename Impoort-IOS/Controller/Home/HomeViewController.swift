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
import SDWebImage
class HomeViewController: BaseViewController {

    @IBOutlet weak var loadingMorePostsActivityView: UIView!
    @IBOutlet weak var quickShareViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var quickShareView: UIView!
    @IBOutlet weak var quickShareGreenView: UIView!
    @IBOutlet weak var quickShareLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topRightButton:UIButton!
    var prevOffset:CGFloat = 0.0
    let refreshControl = UIRefreshControl()
    var data = [4,4,4,4,4,4,4,4,4,4]
    var isLoading = false
    var firstTime = true
    //var currentRow = IndexPath(row: 0, section: 0)
    var currentOffset = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            self.firstTime = false
        }

        
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
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.currentRow = indexPath
        var cell = UITableViewCell()
        if indexPath.row % 3 == 0{
            cell = Bundle.main.loadNibNamed("PostCell", owner: self, options: nil)?.first as! PostCell
            (cell as? PostCell)?.nameSurnameTxtField.text = String(indexPath.row)
        }else{
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
            (cell as? PostCellWithImage)?.nameSurnameTxtFied.text = String(indexPath.row)

        }
        if (indexPath.row == self.data.count-1)  && !firstTime && !isLoading{
            print("yüklenecek")
            self.loadingMorePostsActivityView.isHidden = false
            //self.tableView.isScrollEnabled = false
            self.isLoading = true
            getData()
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func getData(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            var indexes = [IndexPath]()
            let startIndex = self.data.count
        for i in 0..<10{
            self.data.append(i)
            indexes.append(IndexPath(row: startIndex+i, section: 0))
        }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexes, with: .none)
            //self.tableView.scrollToRow(at: self.currentRow, at: .none, animated: false)
            self.tableView.setContentOffset(self.currentOffset, animated: false)
            self.tableView.endUpdates()
            self.loadingMorePostsActivityView.isHidden = true
            print(self.data.count)
            self.isLoading = false
            self.tableView.isScrollEnabled = true
            
        }
    }
}
extension HomeViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentOffset = scrollView.contentOffset
//        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
//            //not top and not bottom
//            let offsetY = scrollView.contentOffset.y
//            if offsetY < 0 {
//                scrollView.contentOffset.y = CGFloat(0.0)
//                UIView.animate(withDuration: 0.2){
//                    //self.view.layoutIfNeeded()
//                }
//            }
//            else if offsetY > prevOffset && offsetY > 0.0{
//                self.quickShareViewHeightConstraint.constant = 0.0
//                quickShareLabel.isHidden = true
//            }else{
//                self.quickShareViewHeightConstraint.constant = 55.0
//                quickShareLabel.isHidden = false
//
//            }
//            UIView.animate(withDuration: 0.35, delay: 0.0, options: .allowUserInteraction, animations: {
//                self.view.layoutIfNeeded()
//
//            }, completion: nil)
//            self.prevOffset = offsetY
//        }else if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
//            //reach bottom
//            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
//                //self.tableView.reloadData() paging.
//            }
//        }else if (scrollView.contentOffset.y < 0){
//            //reach top
//        }
//
   }
}
extension HomeViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            if self.data.count > 0{
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            print(self.tableView.contentOffset)
            }
        }
    }
}
