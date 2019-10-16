//
//  WatchingViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 16.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class WatchingViewController: UIViewController {
    @IBOutlet weak var containerView:UIView!
    var postView:PostsView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadPosts(){
        postView?.removeFromSuperview()
        postView = Bundle.main.loadNibNamed("PostsView", owner: self, options: nil)?.first as? PostsView
        postView?.parentVC = self
        postView?.senderProfileType = .posts
        postView?.load()
    }
    


}
