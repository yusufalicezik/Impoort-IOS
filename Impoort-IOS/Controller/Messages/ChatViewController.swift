//
//  ChatViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Repeat

struct Message {
    var text:String
    var fromMe:Bool
}
class ChatViewController: BaseViewController {

    var exData = [Message(text: "Selam", fromMe: false), Message(text: "Selam Yusuf", fromMe: true),
    Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo. Adipiscing bibendum est Lorem ipsum dolor sit amet.", fromMe: false), Message(text: "Bibendum est ultricies integer quis auctor elit.", fromMe: false), Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo.", fromMe: true), Message(text: "Ok.", fromMe: false),  Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo.", fromMe: true), Message(text: "Ok.", fromMe: false),  Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo.", fromMe: true), Message(text: "Ok.", fromMe: false),  Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis auctor elit. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo.", fromMe: true), Message(text: "Ok.", fromMe: false)]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageTxtField: UITextField!
    @IBOutlet weak var profileNameSurnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    var timer:Repeater!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        IQKeyboardManager.shared.enable = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.sendMessageTxtField.layer.cornerRadius = 14
        TxtFieldConfig.shared.givePadding(to: self.sendMessageTxtField)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.sendMessageTxtField.becomeFirstResponder()
        self.timer = Repeater.every(.seconds(5.0)) { timer  in
            self.getDataFromService()
        }
        
        
        //Keyboard Change
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addSwipeDismiss(vc: self)
    }
    
    func getDataFromService(){
//        DataService.shared.getMessages(completion: { (data) in
//            if self.messageDataList.count != data.count{
//                print("reload..")
//                //self.messageDataList = data
//                //self.tableView.reloadData()
//                self.scrollToBottom()
//            }
//
//
//        })
        //if oldCount != newCount
            self.scrollToBottom()

        print("reload...")
    }
    
    func scrollToBottom(_ animated:Bool = false){
        //if self.messageDataList.count > 0 {
            let indexPath = IndexPath(row: self.exData.count-1, section: 0)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        //}
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.fire(andPause: true)
    }
 

}
extension ChatViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if exData[indexPath.row].fromMe{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as? ChatRightCell
            cell?.messageTextLabel.text = exData[indexPath.row].text
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as? ChatLeftCell
            cell?.messageTextLabel.text = exData[indexPath.row].text
            return cell!
        }
    }
    
    
    
    
}
extension ChatViewController {
    //Keyboard
    @objc func keyboardChanged(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let keyboardValue = userInfo["UIKeyboardFrameEndUserInfoKey"]
        let bottomDistance = UIScreen.main.bounds.size.height - keyboardValue!.cgRectValue.origin.y
        
        if bottomDistance > 0 {
            inputViewBottomConstraint.constant = -bottomDistance
            //self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ) { // change 2 to desired number of seconds
                // Your code with delay
                self.scrollToBottom(true)

                
            }
            
        } else {
            inputViewBottomConstraint.constant = 0
        }
        self.view.layoutIfNeeded()

    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.inputViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.scrollToBottom(true)
            
        }
    }
}
extension ChatViewController{
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
