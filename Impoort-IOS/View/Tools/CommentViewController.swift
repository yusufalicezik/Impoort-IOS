//
//  CommentViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 21.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

struct Comment2Model {
    var commentOwnerName:String
    var commentText:String
}

class CommentViewController: BaseViewController {
   
    var commentDataList: [CommentResponseDTO] = []
    
    var post: PostResponseDTO?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendCommentTxtField: UITextField!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()
        fetchComment()
        // Do any additional setup after loading the view.
    }
    
    private func fetchComment() {
        guard let post = self.post, let id = post.postId else { return }
        PostControllerAPI.getPostCommentUsingGET(postId: id) { [weak self] (response, errro) in
            guard let self = self else { return }
            guard let list = response else { return }
            self.commentDataList = list
            self.tableView.reloadData()
        }
    }
    
    func setup(){
       // self.commentDataList.insert(commentOwnerPost, at: 0)
       IQKeyboardManager.shared.enable = false
        TxtFieldConfig.shared.givePadding(to: self.sendCommentTxtField)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        //Keyboard Change
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addSwipeDismiss(vc: self)
    }
    
    func scrollToBottom(_ animated:Bool = false){
        //if self.messageDataList.count > 0 {
        let indexPath = IndexPath(row: self.commentDataList.count-1, section: 0)
        DispatchQueue.main.async {
            if self.commentDataList.count > 0{
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
        //}
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    

}
extension CommentViewController {
    //Keyboard
    @objc func keyboardChanged(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let keyboardValue = userInfo["UIKeyboardFrameEndUserInfoKey"]
        let bottomDistance = UIScreen.main.bounds.size.height - keyboardValue!.cgRectValue.origin.y
        
        if bottomDistance > 0 {
            inputViewBottomConstraint.constant = bottomDistance
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
extension CommentViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDataList.count+1 //owner +1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCell", for: indexPath) as? CommentPostOwnerCell else {return UITableViewCell()}
            cell.profileNameLabel.text = (post?.user?.firstName ?? "") + (post?.user?.lastName ?? "")
            cell.profilePostDescription.text = post?.postDescription ?? ""
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else {return UITableViewCell()}
            cell.profileNameLabel.text = (self.commentDataList[indexPath.row-1].user?.firstName ?? "") +
                (self.commentDataList[indexPath.row-1].user?.lastName ?? "")
            cell.profilePostComment.text = self.commentDataList[indexPath.row-1].commentText ?? ""
            return cell
        }
    }
    
    
}
