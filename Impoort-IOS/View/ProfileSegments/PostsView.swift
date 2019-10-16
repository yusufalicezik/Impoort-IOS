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
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshControl.tintColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
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
        self.tableView.isScrollEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.refreshControl.endRefreshing()
            self.tableView.isScrollEnabled = true
        }
    }
    
}
extension PostsView:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch senderProfileType! {
        case .posts:
            cell = Bundle.main.loadNibNamed("PostCell", owner: self, options: nil)?.first as! PostCell
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
    
}
