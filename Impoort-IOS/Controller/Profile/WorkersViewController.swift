//
//  WorkersViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 24.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class WorkersViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var containerView:UIView!
    
    private var workerList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.layer.cornerRadius = 15
        self.tableView.layer.cornerRadius = 15
        self.tableView.delaysContentTouches = false
        self.tableView.register(UINib(nibName: "WatcherCell", bundle: nil), forCellReuseIdentifier: "watcherCell")
        let recognizerDismiss = UITapGestureRecognizer(target: self, action: #selector(self.dismissSelf))
        self.view.addGestureRecognizer(recognizerDismiss)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismissSelf()
    }
}

extension WorkersViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "watcherCell", for: indexPath) as? WatcherCell else{return UITableViewCell()}
        return cell
    }
    
    
}
