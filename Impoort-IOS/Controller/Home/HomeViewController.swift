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
import Zoomy
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
    var isLoading = false
    var firstTime = true
    lazy var quickQhareView = ProfileSettingsView()
    var shareRecognizer:UITapGestureRecognizer?
    var currentOffset = CGPoint(x: 0, y: 0)
    var prevOffsetx = CGPoint(x: 0, y: 0)
    var currentIndx = IndexPath(row: 0, section: 0)
    
    var fState = false
    var sState = false
    
    /*
     PostResponseDTO(commentCount: 2, commentList: nil, createdDateTime: "Cumartesi, 12:20", department: "Yazılım", isLiked: false, isWatched: false, likeCount: 12, likeList: nil, mediaUrl: "https://www.klasiksanatlar.com/img/sayfalar/b/1_1534620012_Ekran-Resmi-2018-08-18-22.25.18.png", postDescription: "Deneme post açıklaması..", postId: 1, postType: 1, tags: ["deneme", "bir", "iki"], user: UserResponseDTO(active: true, activeGuide: "asd", birthDate: "11", city: "", confirmed: true, department: "Yazilim", _description: "deneme", email: nil, employeeCount: nil, employees: nil, experiences: nil, firstName: "Yusuf Ali", fullName: "Yusuf Ali Cezik", gender: "erkek", lastName: "Cezik", links: nil, phoneNumber: nil, profileImgUrl: "https://mobile.tgrthaber.com.tr/images/ckfiles/images/1(801).jpg", userId: "22", userType: .developer, watcherCount: 0, watchingCount: 0, watchingPostCount: 2))
     */
    private var dataList: [PostResponseDTO] = []
    private var pageNumber: Int = 0
    private var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        self.pageNumber = 0
        fetchData(paging: false)
    }
    
    private func fetchData(paging:Bool) {
        PostControllerAPI.listPostsUsingGET(userId: CurrentUser.shared.userId ?? "", pageNumber: pageNumber, pageSize: 20, profilePost: false) { [weak self] postList, error in
            guard let self = self else { return }
            if error == nil {
                guard let posts = postList?.content else { return }
                self.pageNumber+=1
                if paging{
                    self.dataList.append(contentsOf: posts)
                } else {
                    self.dataList = posts

                }
                self.tableView.reloadData()
            } else {
                print("HOME fetching posts error: \(error?.localizedDescription ?? "error")")
            }
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
        tableView.delaysContentTouches = false
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
        self.pageNumber = 0
        PostControllerAPI.listPostsUsingGET(userId: CurrentUser.shared.userId ?? "", pageNumber: pageNumber, pageSize: 20, profilePost: false) { [weak self] postList, error in
            guard let self = self else { return }
            if error == nil {
                guard let posts = postList?.content else { return }
                self.pageNumber+=1
                self.dataList = posts
                self.refreshControl.endRefreshing()
                self.tableView.backgroundColor = #colorLiteral(red: 0.978782475, green: 0.9576403499, blue: 0.9845044017, alpha: 1)
                self.tableView.reloadData()
            } else {
                print("HOME fetching posts error: \(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    @IBAction func messagesButtonClicked(_ sender: Any) {
        self.goToMessagesGeneral()
    }
    @IBAction func discoverButtonClicked(_ sender: Any) {
        self.goToDiscoverHits()
    }
    
    @objc func goToShareQuickly(){
        let shareVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ShareVC") as? ShareViewController
        shareVc?.openedFromTab = false
        self.present(shareVc!, animated: true, completion: nil)
    }
    
}
extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.data.count+1
        return self.dataList.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //self.currentRow = indexPath
        var cell = UITableViewCell()
        if indexPath.row == 0{
            cell = Bundle.main.loadNibNamed("QuickShareCell", owner: self, options: nil)?.first as! QuickShareCell
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(shareRecognizer!)
        } else {
            guard let postType = dataList[indexPath.row-1].postType else { return UITableViewCell() }
            switch PostType(rawValue: postType) {
            case .withPhotoPost:
                cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
                guard let cell = cell as? PostCellWithImage else { return UITableViewCell() }
                cell.nameSurnameTxtFied.text = (dataList[indexPath.row-1].user?.firstName ?? "Guest") + (dataList[indexPath.row-1].user?.lastName ?? "")
                addZoombehavior(for: cell.postImage, settings: .instaZoomSettings)
                cell.perDelegate = self
                cell.configCell()
                cell.post = dataList[indexPath.row-1]
                cell.postDescription.text = dataList[indexPath.row-1].postDescription ?? ""
                cell.postDescription.numberOfLines = 7
                
                if (cell.postDescription.calculateMaxLines()) > 7{
                    cell.readMoreButton.isHidden = false
                }
            case .normalPost:
                cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
                guard let cell = cell as? PostCellWithImage else { return UITableViewCell() }
                cell.nameSurnameTxtFied.text = (dataList[indexPath.row-1].user?.firstName ?? "Guest") + (dataList[indexPath.row-1].user?.lastName ?? "")
                cell.postImageHeightConstraint.constant = 0.0
                cell.postDescription.text = dataList[indexPath.row-1].postDescription ?? ""
                cell.perDelegate = self
                cell.configCell()
                cell.post = dataList[indexPath.row-1]
            case .none:
                return UITableViewCell()
            }
            
            if (indexPath.row == self.dataList.count)  && !firstTime && !isLoading && self.dataList.count > 15{
                print("yüklenecek")
                self.loadingMorePostsActivityView.isHidden = false
                self.isLoading = true
                fetchData(paging: true)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.currentIndx = indexPath
    }
    
    
//    func getData(){
//        DispatchQueue.main.asyncAfter(deadline: .now()+2){
//            if self.fState{
//                var indexes = [IndexPath]()
//                let startIndex = self.dataList.count
//                for i in 1..<11{
//                    self.dataList.append(i)
//                    indexes.append(IndexPath(row: startIndex+i, section: 0))
//                }
//                self.tableView.beginUpdates()
//                self.tableView.insertRows(at: indexes, with: .fade)
//                //self.tableView.scrollToRow(at: self.currentRow, at: .none, animated: false)
//                self.tableView.endUpdates()
//                ///self.tableView.reloadData()
//                print(self.dataList.count)
//                self.isLoading = false
//                //self.tableView.scrollToRow(at: self.currentIndx, at: .bottom, animated: true)
//                self.tableView.setContentOffset(self.currentOffset, animated: true)
//                self.loadingMorePostsActivityView.isHidden = true
//            }else{
//                self.getData()
//            }
//        }
//    }
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
            if self.dataList.count > 0{
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                print(self.tableView.contentOffset)
            }
        }
    }
}
extension HomeViewController:PostCellDelegate{
    func didClickedProfilePic() {
        self.goToProfile(2)
    }
    
    func didSelectPost(_ id: Int) {
        print("tiklandi.. \(id)")
        self.goToPostDetailVC() //parametre olarak gelen post gönderilecek, şimdilik id geliyor, modellerden sonra eklenecek
    }
    
    func didSelectReadMore(_ id: Int) {
        print("asd")
    }
}
