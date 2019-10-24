//
//  PostsView.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 16.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

enum SenderProfileTyle{
    case posts, watching, watcher
}
class PostsView: UIView {

    @IBOutlet weak var tableView: UITableView!
    var parentVC:UIViewController?
    var senderProfileType:SenderProfileTyle?
    //let refreshControl = UIRefreshControl()
    var isLoading = false
    var firstTime = true
    var fState = false
    @IBOutlet weak var loadingMorePostsActivityView:UIActivityIndicatorView!
    var currentOffset = CGPoint(x: 0, y: 0)
    var data = [1,1,1,1,1,1,1,1,1]
    var currentIndex = 0
    var isPagingMaking = false
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        //self.refreshControl.tintColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        //tableView.refreshControl = self.refreshControl
        //refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            self.firstTime = false
        }
    }
    func load(){
        if senderProfileType! == .posts{
            tableView.allowsSelection = false
        }
        if let parentVC = parentVC as? ProfileViewController{
            parentVC.containerView.addSubview(self)
            self.frame = parentVC.containerView.frame
            self.translatesAutoresizingMaskIntoConstraints = false
            self.topAnchor.constraint(equalTo: parentVC.containerView.topAnchor, constant: 0.0).isActive = true
            self.bottomAnchor.constraint(equalTo: parentVC.containerView.bottomAnchor, constant: 0.0).isActive = true
            self.leftAnchor.constraint(equalTo: parentVC.containerView.leftAnchor, constant: 0.0).isActive = true
            self.rightAnchor.constraint(equalTo: parentVC.containerView.rightAnchor, constant: 0.0).isActive = true
        }else if let parentVC = parentVC as? WatchingViewController{
            parentVC.containerView.addSubview(self)
            self.frame = parentVC.containerView.frame
            self.translatesAutoresizingMaskIntoConstraints = false
            self.topAnchor.constraint(equalTo: parentVC.containerView.topAnchor, constant: 0.0).isActive = true
            self.bottomAnchor.constraint(equalTo: parentVC.containerView.bottomAnchor, constant: 0.0).isActive = true
            self.leftAnchor.constraint(equalTo: parentVC.containerView.leftAnchor, constant: 0.0).isActive = true
            self.rightAnchor.constraint(equalTo: parentVC.containerView.rightAnchor, constant: 0.0).isActive = true
        }
    }
}
extension PostsView:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch senderProfileType! {
        case .posts:
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
            (cell as? PostCellWithImage)?.postID = indexPath.row
            (cell as? PostCellWithImage)?.perDelegate = self
            (cell as? PostCellWithImage)?.configCell()
            if (indexPath.row == self.data.count-1)  && !firstTime && !isLoading{
                print("yüklenecek")
                self.loadingMorePostsActivityView.isHidden = false
                self.isLoading = true
                getData()
            }
            
            //cell. config işlemleri posta göre
        case .watcher:
            cell = Bundle.main.loadNibNamed("WatcherCell", owner: self, options: nil)?.first as! WatcherCell
            if indexPath.row % 3 == 0{
                if let mCell = cell as? WatcherCell{
                    mCell.watchingWatcherButton.setTitle("Watch", for: .normal)
                    mCell.watchingWatcherButton.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
                }
            }
        default:
            cell = Bundle.main.loadNibNamed("WatcherCell", owner: self, options: nil)?.first as! WatcherCell
        }
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
    func getData(){
        if let mParentVC = (self.parentVC as? ProfileViewController){
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                if self.fState{
                    if mParentVC.postsView == self{
                        self.isPagingMaking = true
                        var indexes = [IndexPath]()
                        let startIndex = self.data.count
                        
                        for i in 0..<10{
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
                    }else{
                        self.getData()
                    }
                }
            }
        }else if let mParentVC = (self.parentVC as? WatchingViewController){
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                if self.fState{
                        self.isPagingMaking = true
                        var indexes = [IndexPath]()
                        let startIndex = self.data.count
                        
                        for i in 0..<10{
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
                    }else{
                        self.getData()
                    }
                }
            }
    }
}
extension PostsView:PostCellDelegate{
    func didSelectPost(_ id: Int) {
        print("clicked post \(id)")
    }
    func didSelectReadMore(_ id: Int) {
    }
}
