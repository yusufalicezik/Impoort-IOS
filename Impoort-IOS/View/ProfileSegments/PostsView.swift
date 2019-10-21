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
    let refreshControl = UIRefreshControl()
    var isLoading = false
    var firstTime = true
    var fState = false
    var sState = false
    @IBOutlet weak var loadingMorePostsActivityView:UIActivityIndicatorView!
    var currentOffset = CGPoint(x: 0, y: 0)
    var data = [1,2,2,2,2,2,22,2,2,2,2] //parentVC den gönderilebilri.
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshControl.tintColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
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
    
    @objc func refreshWeatherData(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.refreshControl.endRefreshing()
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
    
    
}
extension PostsView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let parentVC = parentVC as? ProfileViewController else {return}
        if scrollView.contentOffset.y <= 0{
            parentVC.profileImageHeight?.constant = 160.0
            parentVC.profileImageWidth?.constant = 160.0
            parentVC.barWidthConstraint?.constant = 0.0
            parentVC.barHeightConstraint?.constant = 0.0
        }else if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            parentVC.profileImageHeight?.constant = 0
            parentVC.profileImageWidth?.constant = 0
            parentVC.barWidthConstraint?.constant = 35.0
            parentVC.barHeightConstraint?.constant = 35.0
            //self.barImageView.layer.masksToBounds = true
            parentVC.barImageView.layer.cornerRadius = parentVC.barImageView.frame.width / 2
            //            self.profileImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
            //            self.profileImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        }
       
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: {
            parentVC.view.layoutIfNeeded()

        }, completion: nil)
       
    }
    
    
    
    //Pagination:
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Drag begin")
        if isLoading{
            self.fState = false
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.fState = true
    }
    func getData(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            if self.fState{
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
                
                //self.tableView.isScrollEnabled = true
            }else{
                self.getData()
                //self.isLoading = false
                //self.loadingMorePostsActivityView.isHidden = true
                
                
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
