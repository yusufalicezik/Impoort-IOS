//
//  RegisterThirdStepViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 5.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import ViewAnimator

class RegisterThirdStepViewController: BaseViewController {

    @IBOutlet weak var userTypeTableView: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var sectorTxtField: UITextField!
    var fromAnimation : AnimationType?
    var sectorTypeStrings = ["Investor", "Developer", "Startup", "Just User"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func setup(){
        self.userTypeTableView.delegate = self
        self.userTypeTableView.dataSource = self

        finishButton.layer.cornerRadius = 12
        sectorTxtField.layer.cornerRadius = 12
        self.userTypeTableView.isHidden = true
        self.sectorTxtField.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
            UIView.animate(withDuration: 0.8){
                self.userTypeTableView.isHidden = false
                self.sectorTxtField.isHidden = false
            }
            self.fromAnimation = AnimationType.from(direction: .left, offset: 90.0)
            UIView.animate(views: self.userTypeTableView.visibleCells,
                           animations: [self.fromAnimation!], delay: 0.55)
        })
        
        TxtFieldConfig.shared.givePadding(to: sectorTxtField)
    }
    
    @IBAction func finisButtonClicked(_ sender: Any) {

    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.goToBack()
    }
    
 

}
extension RegisterThirdStepViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectorTypeStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userTypeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SectorCell else {return UITableViewCell()}
        cell.sectorNameTxtField.text = sectorTypeStrings[indexPath.row]
        cell.sectorNameTxtField.layer.masksToBounds = true
        cell.sectorNameTxtField.layer.cornerRadius = 12
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<self.sectorTypeStrings.count{
            let mIndexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: mIndexPath) as? SectorCell
            cell?.sectorNameTxtField.backgroundColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
        }
        let cell = tableView.cellForRow(at: indexPath) as? SectorCell
        cell?.sectorNameTxtField.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        //self.userTypeTableView.deselectRow(at: indexPath, animated: false)

    }
    
}
