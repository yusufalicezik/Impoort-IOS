//
//  WatchingViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 16.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class WatchingViewController: BaseViewController {
    @IBOutlet weak var containerView:UIView!
    var postView:PostsView?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearHeader()
        loadPosts()
    }
    
    func loadPosts(){
        postView?.removeFromSuperview()
        postView = Bundle.main.loadNibNamed("PostsView", owner: self, options: nil)?.first as? PostsView
        postView?.parentVC = self
        postView?.isWatchingPost = true
        postView?.senderProfileType = .posts
        postView?.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func clearHeader(){
        UIView.animate(withDuration: 0.2){
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
