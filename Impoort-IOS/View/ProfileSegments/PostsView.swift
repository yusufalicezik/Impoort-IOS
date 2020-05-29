//
//  PostsView.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 16.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SDWebImage

enum SenderProfileTyle{
    case posts, watching, watcher
}
class PostsView: UIView {

    @IBOutlet weak var tableView: UITableView!
    weak var parentVC:UIViewController? //weak for memory leaks/retain cycle
    var senderProfileType:SenderProfileTyle! = .posts
    //let refreshControl = UIRefreshControl()
    var isLoading = false
    var firstTime = true
    var fState = false
    @IBOutlet weak var loadingMorePostsActivityView:UIActivityIndicatorView!
    var currentOffset = CGPoint(x: 0, y: 0)
    var currentIndex = 0
    var isPagingMaking = false

    var isWatchingPost = false
    
    /*
     PostResponseDTO(commentCount: 2, commentList: nil, createdDateTime: "Cumartesi, 12:20", department: "Yazılım", isLiked: false, isWatched: false, likeCount: 12, likeList: nil, mediaUrl: "https://www.klasiksanatlar.com/img/sayfalar/b/1_1534620012_Ekran-Resmi-2018-08-18-22.25.18.png", postDescription: "Deneme post açıklaması..", postId: 1, postType: 1, tags: ["deneme", "bir", "iki"], user: UserResponseDTO(active: true, activeGuide: "asd", birthDate: "11", city: "", confirmed: true, department: "Yazilim", _description: "deneme", email: nil, employeeCount: nil, employees: nil, experiences: nil, firstName: "Yusuf Ali", fullName: "Yusuf Ali Cezik", gender: "erkek", lastName: "Cezik", links: nil, phoneNumber: nil, profileImgUrl: "https://mobile.tgrthaber.com.tr/images/ckfiles/images/1(801).jpg", userId: "22", userType: .developer, watcherCount: 0, watchingCount: 0, watchingPostCount: 2))
     */
    private var dataList: [PostResponseDTO] = []
    private var pageNumber: Int = 0
    var userId: String = CurrentUser.shared.userId ?? ""
    
    
    /*
     Watcher(beingWatch: true, _id: 1, user: User(active: true, activeGuide: "asd", birthDate: nil, city: nil, confirmed: nil, department: nil, _description: nil, email: nil, employeeCount: nil, firstName: "Deneme", fullName: "Deeme user", gender: nil, lastName: "user", links: nil, password: "asdasdasd", phoneNumber: "123123", profileImgUrl: "https://mobile.tgrthaber.com.tr/images/ckfiles/images/1(801).jpg", userId: "3", userType: .normalUser, watchPosts: nil, watcherCount: nil, watchingCount: 2, watchingPostCount: 3), watchMapId: UUID(uuidString: "dasdasdasd"), watchingUser: nil)
     */
    private var watcherDataList: [Watcher] = []
    private var watchingDataList: [Watching] = []

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false

        //self.refreshControl.tintColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        //tableView.refreshControl = self.refreshControl
        //refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            self.firstTime = false
        }
    }
    func load(){
        if senderProfileType == .posts{
            tableView.allowsSelection = false
            if let parentVC = parentVC as? ProfileViewController{
                parentVC.containerView.addSubview(self)
                self.frame = parentVC.containerView.frame
                self.translatesAutoresizingMaskIntoConstraints = false
                self.topAnchor.constraint(equalTo: parentVC.containerView.topAnchor, constant: 0.0).isActive = true
                self.bottomAnchor.constraint(equalTo: parentVC.containerView.bottomAnchor, constant: 0.0).isActive = true
                self.leftAnchor.constraint(equalTo: parentVC.containerView.leftAnchor, constant: 0.0).isActive = true
                self.rightAnchor.constraint(equalTo: parentVC.containerView.rightAnchor, constant: 0.0).isActive = true
                fetchPostData()
            } else if let parentVC = parentVC as? WatchingViewController {
                parentVC.containerView.addSubview(self)
                self.frame = parentVC.containerView.frame
                self.translatesAutoresizingMaskIntoConstraints = false
                self.topAnchor.constraint(equalTo: parentVC.containerView.topAnchor, constant: 0.0).isActive = true
                self.bottomAnchor.constraint(equalTo: parentVC.containerView.bottomAnchor, constant: 0.0).isActive = true
                self.leftAnchor.constraint(equalTo: parentVC.containerView.leftAnchor, constant: 0.0).isActive = true
                self.rightAnchor.constraint(equalTo: parentVC.containerView.rightAnchor, constant: 0.0).isActive = true
                fetchWatchingPostData()
            }
        } else if senderProfileType == .watching {
             if let parentVC = parentVC as? ProfileViewController{
                parentVC.containerView.addSubview(self)
                self.frame = parentVC.containerView.frame
                self.translatesAutoresizingMaskIntoConstraints = false
                self.topAnchor.constraint(equalTo: parentVC.containerView.topAnchor, constant: 0.0).isActive = true
                self.bottomAnchor.constraint(equalTo: parentVC.containerView.bottomAnchor, constant: 0.0).isActive = true
                self.leftAnchor.constraint(equalTo: parentVC.containerView.leftAnchor, constant: 0.0).isActive = true
                self.rightAnchor.constraint(equalTo: parentVC.containerView.rightAnchor, constant: 0.0).isActive = true
                fetchWatchingData()
            }
        }else {
            if let parentVC = parentVC as? ProfileViewController{
                parentVC.containerView.addSubview(self)
                self.frame = parentVC.containerView.frame
                self.translatesAutoresizingMaskIntoConstraints = false
                self.topAnchor.constraint(equalTo: parentVC.containerView.topAnchor, constant: 0.0).isActive = true
                self.bottomAnchor.constraint(equalTo: parentVC.containerView.bottomAnchor, constant: 0.0).isActive = true
                self.leftAnchor.constraint(equalTo: parentVC.containerView.leftAnchor, constant: 0.0).isActive = true
                self.rightAnchor.constraint(equalTo: parentVC.containerView.rightAnchor, constant: 0.0).isActive = true
                fetchWatcherData()
            }
        }
    }
    
    
    private func fetchPostData() {
        PostControllerAPI.listPostsUsingGET(userId: userId, pageNumber: pageNumber, pageSize: 20, profilePost: true) { [weak self] postList, error in
            guard let self = self else { return }
            if error == nil {
                guard let posts = postList?.content else { return }
                self.dataList = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.setNeedsDisplay()
                }
                self.pageNumber+=1
            } else {
                print("watchng post fetching posts error: \(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    private func fetchWatchingPostData() {
        PostControllerAPI.listWatchedPostsUsingGET(userId: userId) { [weak self] (postList, error) in
            guard let self = self else { return }
            if error == nil {
                guard let posts = postList else { return }
                self.dataList = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    private func fetchWatchingData() {
        WatchControllerAPI.getWatchingUsingGET(myId: userId, userId: userId, pageNumber: 0, pageSize: 20, completion: { [weak self] (list, error) in
            if error == nil {
                guard let watchingList = list?.content else { return }
                self?.watchingDataList = watchingList
                self?.tableView.reloadData()
            } else {
                print("Error Fetching Watcthing data : \(error)")
            }
        })
    }
    
    private func fetchWatcherData() {
        WatchControllerAPI.getWatcherUsingGET(myId: userId, userId: userId, pageNumber: 0, pageSize: 20) { [weak self] (list, error) in
            if error == nil {
                guard let watcherList = list?.content else { return }
                self?.watcherDataList = watcherList
                self?.tableView.reloadData()
            } else {
                print("Error Fetching Watcthing data : \(error?.localizedDescription ?? "error")")
            }
        }
    }
}
extension PostsView:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.dataList.count)
        switch senderProfileType! {
        case .posts:
             return self.dataList.count
        case .watcher:
             return self.watcherDataList.count
        case .watching:
             return self.watchingDataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch senderProfileType! {
        case .posts:
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
            guard let cell = cell as? PostCellWithImage else { return UITableViewCell() }
            //(cell as? PostCellWithImage)?.postID = indexPath.row
            cell.post = dataList[indexPath.row]
            cell.perDelegate = self
            cell.configCell()
            
            cell.nameSurnameTxtFied.text = (dataList[indexPath.row].user?.firstName ?? "Guest") + (dataList[indexPath.row].user?.lastName ?? "")
            cell.postDescription.text = dataList[indexPath.row].postDescription ?? ""
            cell.postDescription.numberOfLines = 7
            
            if PostType(rawValue: dataList[indexPath.row].postType ?? 1) == PostType.normalPost {
                cell.postImageHeightConstraint.constant = 0.0
            }
            
            if (cell.postDescription.calculateMaxLines()) > 7 {
                cell.readMoreButton.isHidden = false
            }
            
            
            if (indexPath.row == self.dataList.count-1)  && !firstTime && !isLoading && self.dataList.count > 15{
                print("yüklenecek")
                self.loadingMorePostsActivityView.isHidden = false
                self.isLoading = true
                fetchPostData()
            }
            
            //cell. config işlemleri posta göre
        case .watching:
            cell = Bundle.main.loadNibNamed("WatcherCell", owner: self, options: nil)?.first as! WatcherCell
            if let mCell = cell as? WatcherCell{
                mCell.profileSectorLabel.text = watchingDataList[indexPath.row].user?.department ?? ""
                mCell.profileNAmeSurnameLabel.text = (watchingDataList[indexPath.row].user?.firstName ?? "") + (watchingDataList[indexPath.row].user?.lastName ?? "")
                
                let isWatching = watchingDataList[indexPath.row].beingWatch ?? true ? "Watching" : "Watch"
                mCell.watchingWatcherButton.setTitle(isWatching, for: .normal)
                mCell.watchingWatcherButton.backgroundColor = watchingDataList[indexPath.row].beingWatch ?? true ? #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1) : #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                
                
                if let url = URL(string: watchingDataList[indexPath.row].user?.profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png") {
                    mCell.profileImg?.sd_setImage(with: url, completed: nil)
                }
            }
        default:
            cell = Bundle.main.loadNibNamed("WatcherCell", owner: self, options: nil)?.first as! WatcherCell
            if let mCell = cell as? WatcherCell{
                mCell.profileSectorLabel.text = watcherDataList[indexPath.row].user?.department ?? ""
                mCell.profileNAmeSurnameLabel.text = (watcherDataList[indexPath.row].user?.firstName ?? "") + (watcherDataList[indexPath.row].user?.lastName ?? "")
                
                let isWatching = watcherDataList[indexPath.row].beingWatch ?? true ? "Watching" : "Watch"
                mCell.watchingWatcherButton.setTitle(isWatching, for: .normal)
                mCell.watchingWatcherButton.backgroundColor = watcherDataList[indexPath.row].beingWatch ?? true ? #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1) : #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                if let url = URL(string: watcherDataList[indexPath.row].user?.profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png") {
                    mCell.profileImg?.sd_setImage(with: url, completed: nil)
                }
            }
        }
        print("printtt")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
    }
}
extension PostsView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let parentVC = parentVC as? ProfileViewController else {return}
        if (scrollView.contentOffset.y >= 80 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)) && !parentVC.isChanged && scrollView.contentOffset.y != 0{
            UIView.animate(withDuration: 0.3){
                parentVC.headerBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
                parentVC.isDarkHeader = true
            }
        }
        else if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && scrollView.contentOffset.y != 0 {
            UIView.animate(withDuration: 0.3){
//                parentVC.headerBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
//                UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
//                parentVC.isDarkHeader = true
            }
        }
        else {
            if scrollView.contentOffset.y <= 0{
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: false)
                UIView.animate(withDuration: 0.3){
                    parentVC.headerBarView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    parentVC.isDarkHeader = false
                }
            }
        }
        parentVC.setNeedsStatusBarAppearanceUpdate()
    }



    //Pagination:
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isLoading{
            self.fState = false
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.fState = true
    }
//    func getData(){
//        if let mParentVC = (self.parentVC as? ProfileViewController){
//            DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                if self.fState{
//                    if mParentVC.postsView == self{
//                        self.isPagingMaking = true
//                        var indexes = [IndexPath]()
//                        let startIndex = self.data.count
//
//                        for i in 0..<10{
//                            self.data.append(i)
//                            indexes.append(IndexPath(row: startIndex+i, section: 0))
//                        }
//                        self.tableView.beginUpdates()
//                        self.tableView.insertRows(at: indexes, with: .fade)
//                        //self.tableView.scrollToRow(at: self.currentRow, at: .none, animated: false)
//                        self.tableView.endUpdates()
//                        ///self.tableView.reloadData()
//                        print(self.data.count)
//                        self.isLoading = false
//                        //self.tableView.scrollToRow(at: self.currentIndx, at: .bottom, animated: true)
//                        self.tableView.setContentOffset(self.currentOffset, animated: true)
//                        self.loadingMorePostsActivityView.isHidden = true
//                    }else{
//                        self.getData()
//                    }
//                }
//            }
//        }else if let mParentVC = (self.parentVC as? WatchingViewController){
//            DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                if self.fState{
//                        self.isPagingMaking = true
//                        var indexes = [IndexPath]()
//                        let startIndex = self.data.count
//
//                        for i in 0..<10{
//                            self.data.append(i)
//                            indexes.append(IndexPath(row: startIndex+i, section: 0))
//                        }
//                        self.tableView.beginUpdates()
//                        self.tableView.insertRows(at: indexes, with: .fade)
//                        //self.tableView.scrollToRow(at: self.currentRow, at: .none, animated: false)
//                        self.tableView.endUpdates()
//                        ///self.tableView.reloadData()
//                        print(self.data.count)
//                        self.isLoading = false
//                        //self.tableView.scrollToRow(at: self.currentIndx, at: .bottom, animated: true)
//                        self.tableView.setContentOffset(self.currentOffset, animated: true)
//                        self.loadingMorePostsActivityView.isHidden = true
//                    }else{
//                        self.getData()
//                    }
//                }
//            }
//    }
}
extension PostsView:PostCellDelegate{
    func didCommentClicked(post: PostResponseDTO) {}
    
    func didClickedDislikeButton(postId: Int, indexPath: Int) {}
    
    func didClickedlikeDisLikeButton(postId: Int, indexPath: Int) {}
    
    func didClickedWatchButton(postId: Int) {}
    
    func didClickedProfilePic(id: String) {}
    
    func didSelectPost(_ id: Int) {
        print("clicked post \(id)")
    }
    func didSelectReadMore(_ id: Int) {
    }
}
