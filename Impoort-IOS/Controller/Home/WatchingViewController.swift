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
        loadPosts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    func loadPosts(){
        postView?.removeFromSuperview()
        postView = Bundle.main.loadNibNamed("PostsView", owner: self, options: nil)?.first as? PostsView
        postView?.parentVC = self
        postView?.senderProfileType = .posts
        postView?.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

}
