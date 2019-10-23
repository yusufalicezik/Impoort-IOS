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
    var data = [4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    var isLoading = false
    var firstTime = true
    lazy var quickQhareView = ProfileSettingsView()
    var shareRecognizer:UITapGestureRecognizer?

    //var currentRow = IndexPath(row: 0, section: 0)
    var currentOffset = CGPoint(x: 0, y: 0)
    var prevOffsetx = CGPoint(x: 0, y: 0)
    var currentIndx = IndexPath(row: 0, section: 0)
    
    var fState = false
    var sState = false

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
        //tableView.isDragging = false

        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        shareRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToShareQuickly))
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
            UIView.animate(withDuration: 0.5){
                self.tableView.backgroundColor = #colorLiteral(red: 0.978782475, green: 0.9576403499, blue: 0.9845044017, alpha: 1)
            }
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
        return self.data.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.currentRow = indexPath
        var cell = UITableViewCell()
        if indexPath.row == 0{
            cell = Bundle.main.loadNibNamed("QuickShareCell", owner: self, options: nil)?.first as! QuickShareCell
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(shareRecognizer!)
        }
        else if indexPath.row % 3 == 0{
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
            (cell as? PostCellWithImage)?.nameSurnameTxtFied.text = String(indexPath.row)
            (cell as? PostCellWithImage)?.postImageHeightConstraint.constant = 0.0
            (cell as? PostCellWithImage)?.perDelegate = self
            (cell as? PostCellWithImage)?.configCell()
            (cell as? PostCellWithImage)?.postID = indexPath.row
        }else{
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
            (cell as? PostCellWithImage)?.nameSurnameTxtFied.text = String(indexPath.row)
            (cell as? PostCellWithImage)?.perDelegate = self
            (cell as? PostCellWithImage)?.configCell()
            (cell as? PostCellWithImage)?.postID = indexPath.row
        }
        if (indexPath.row == self.data.count)  && !firstTime && !isLoading{
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.currentIndx = indexPath
    }
    
    
    func getData(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            if self.fState{
            var indexes = [IndexPath]()
            let startIndex = self.data.count

        for i in 1..<11{
            self.data.append(i)
            indexes.append(IndexPath(row: startIndex+i, section: 0))
        }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexes, with: .fade)
            //self.tableView.scrollToRow(at: self.currentRow, at: .none, animated: false)
            self.tableView.endUpdates()
            ///self.tableView.reloadData()
            print(self.data.count)
            self.isLoading = false
            //self.tableView.scrollToRow(at: self.currentIndx, at: .bottom, animated: true)
            self.tableView.setContentOffset(self.currentOffset, animated: true)
            self.loadingMorePostsActivityView.isHidden = true

            //self.tableView.isScrollEnabled = true
            }else{
                self.getData()
                //self.isLoading = false
                //self.loadingMorePostsActivityView.isHidden = true


            }
            
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
//        if (scrollView.contentOffset.y <= 0){
//            self.quickQhareView.dsms()
//            self.quickQhareView = (Bundle.main.loadNibNamed("ProfileSettingsView", owner: self, options: nil)?.first as? ProfileSettingsView)!
//            self.view.addSubview(quickQhareView)
//            self.tableView.setContentOffset(CGPoint(x: self.tableView.contentOffset.x, y: 0), animated: false)
//            quickQhareView.configEx(self, mView: quickQhareView)
//
//        }else {
//           self.quickQhareView.dsms()
//            self.view.layoutIfNeeded()
//
//        }
        if scrollView.contentOffset.y < 0{
            self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.tableView.backgroundColor = #colorLiteral(red: 0.978782475, green: 0.9576403499, blue: 0.9845044017, alpha: 1)
        }
   }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Drag begin")
        if isLoading{
            self.fState = false
        }
        
  

   }

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.fState = true
       
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
extension HomeViewController:PostCellDelegate{
    func didSelectPost(_ id: Int) {
        print("tiklandi.. \(id)")
       self.goToPostDetailVC() //parametre olarak gelen post gönderilecek, şimdilik id geliyor, modellerden sonra eklenecek
    }
    
    func didSelectReadMore(_ id: Int) {
        print("asd")
    }
    
    
}
