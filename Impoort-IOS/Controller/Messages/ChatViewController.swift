//
//  ChatViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

struct Message {
    var text:String
    var fromMe:Bool
}
class ChatViewController: BaseViewController {

    var exData = [Message(text: "Selam", fromMe: false), Message(text: "Selam Yusuf", fromMe: true),
    Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo. Adipiscing bibendum est Lorem ipsum dolor sit amet.", fromMe: false), Message(text: "Bibendum est ultricies integer quis auctor elit.", fromMe: false), Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo.", fromMe: true), Message(text: "Ok.", fromMe: false)]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageTxtField: UITextField!
    @IBOutlet weak var profileNameSurnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.sendMessageTxtField.layer.cornerRadius = 14
        TxtFieldConfig.shared.givePadding(to: self.sendMessageTxtField)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
    }
    
 

}
extension ChatViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if exData[indexPath.row].fromMe{
            var cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as? ChatRightCell
            cell?.messageTextLabel.text = exData[indexPath.row].text
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as? ChatLeftCell
            cell?.messageTextLabel.text = exData[indexPath.row].text
            return cell!
        }
    }
    
    
    
    
}
