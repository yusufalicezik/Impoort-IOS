//
//  HomeViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 6.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        
    }
    @objc func refreshWeatherData(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now()+4){
            self.refreshControl.endRefreshing()
        }
    }


}
extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row % 3 == 0{
            cell = Bundle.main.loadNibNamed("PostCell", owner: self, options: nil)?.first as! PostCell
        }else{
            cell = Bundle.main.loadNibNamed("PostCellWithImage", owner: self, options: nil)?.first as! PostCellWithImage
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
