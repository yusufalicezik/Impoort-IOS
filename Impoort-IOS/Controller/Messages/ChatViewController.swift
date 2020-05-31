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
import SDWebImage

struct Message2Model {
    var text:String
    var fromMe:Bool
}
class ChatViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageTxtField: UITextField!
    @IBOutlet weak var profileNameSurnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    var messageList: [Message] = []

    
    var timer:Repeater!
    var userDetails: UserResponseDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        
        if let details = self.userDetails {
            if let url = URL(string: details.profileImgUrl ?? "") {
                profileImage.sd_setImage(with: url, completed: nil)
            }
            profileNameSurnameLabel.text = (details.firstName ?? "") + (details.lastName ?? "")
            departmentLabel.text = details.department ?? ""
            setup()
        }
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
        self.timer = Repeater.every(.seconds(5.0)) { [weak self] timer  in
            self?.fetchMessages()
        }
        
        
        //Keyboard Change
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addSwipeDismiss(vc: self)
    }
    
    private func fetchMessages() {
        guard let user = userDetails, let userId = user.userId else { return }
        MessageControllerAPI.getAllMessageWithReceiverUserUsingGET(receiverId: userId, senderId: CurrentUser.shared.userId ?? "") { [weak self] (messageList, error) in
            guard let self = self else { return }
            if error == nil {
                if let list = messageList {
                    self.messageList = list
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
        }
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

        print("reload...")
    }
    
    func scrollToBottom(_ animated:Bool = false){
        if self.messageList.count > 0 {
            let indexPath = IndexPath(row: self.messageList.count-1, section: 0)
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        //
        guard let text = sendMessageTxtField.text, let user = userDetails, let receiverId = user.userId else { return }
        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        
        let message = Message(messageDate: nil, messageId: nil, messageReceiverUserId: receiverId, messageSenderUserId: CurrentUser.shared.userId ?? "", messageText: text)
        self.messageList.append(message)
        self.tableView.reloadData()
        self.scrollToBottom()
        MessageControllerAPI.sendNewMessageToReceiverUsingPOST(message: message) { [weak self] (respo, error) in
            print("error: \(error)")
            print("error: \(error?.localizedDescription)")

            if error == nil {
                print("added success")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.fire(andPause: true)
    }
 

}
extension ChatViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let senderId = messageList[indexPath.row].messageSenderUserId else { return UITableViewCell() }
        if senderId == (CurrentUser.shared.userId ?? "")  { //From me
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as? ChatRightCell
            cell?.messageTextLabel.text = messageList[indexPath.row].messageText ?? ""
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as? ChatLeftCell
            cell?.messageTextLabel.text = messageList[indexPath.row].messageText ?? ""
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
