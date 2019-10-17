//
//  MessagesGeneralViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 7.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class MessagesGeneralViewController: BaseViewController {

    var exData = ["Yusuf Ali Cezik", "Can Yardımcı", "Mehmet Burak Hammuşoğlu", "Hasan Cerit", "Cyoxes"]
    var isLoading = false
    var filteredExData = [String]()
    @IBOutlet weak var errorLabel: UILabel!
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
        
        searchTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        if self.exData.count == 0{
            self.errorLabel.isHidden = false
        }else{
            self.errorLabel.isHidden = true
        }
        self.addSwipeDismiss(vc: self)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.searchTxtField{
            if textField.text!.count > 0{
                isLoading = true
                filterSearchData(withKeyword: textField.text!)
            }else{
                isLoading = false
            }
            self.tableView.reloadData()
        }
    }
    
    func filterSearchData(withKeyword keyword:String){
        filteredExData = exData.filter({ (dataItem) -> Bool in
            return dataItem.hasPrefix(keyword)
        })
    }

}
extension MessagesGeneralViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading{
            return filteredExData.count
        }else{
            return exData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MessagesGeneralCell
        if self.isLoading{
            cell?.nameSurnameTxtField.text = self.filteredExData[indexPath.row]
        }else{
            cell?.nameSurnameTxtField.text = self.exData[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToChatVC() // id gönderilecek. indexpath.row.id
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
