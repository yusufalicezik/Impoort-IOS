//
//  MessagesGeneralViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class MessagesGeneralViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var searchTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        self.searchTxtField.layer.cornerRadius = 15
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        TxtFieldConfig.shared.givePadding(to: self.searchTxtField)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }

}
extension MessagesGeneralViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MessagesGeneralCell
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToChatVC() // id gönderilecek. indexpath.row.id
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
