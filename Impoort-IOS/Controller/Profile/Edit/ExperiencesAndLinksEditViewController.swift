//
//  ExperiencesAndLinksEditViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 2.12.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

enum PageType{
    case experiences, links
}

struct ExperiencesAndLinks{
    var companyAndWebName, departmentAndLinkName:String
}

class ExperiencesAndLinksEditViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CompanyNameTxtField: UITextField!
    @IBOutlet weak var departmentTxtField: UITextField!
    @IBOutlet weak var tableViewExperiences: UITableView!
    @IBOutlet weak var tableViewSearchResult: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var searchResultsDataList:[String] = []
    private var experiencesDataList:[ExperiencesAndLinks] = []
    
    private var expList: [Experience] = []
    
    public var pageType:PageType = PageType.experiences
    public weak var expDelegate: ExperienceViewProtocol?
    public weak var linkDelegate: LinksViewProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = 8
        self.saveButton.layer.cornerRadius = 8
        tableViewExperiences.separatorStyle = .none
        tableViewExperiences.rowHeight = 40
        containerView.layer.cornerRadius = 12
        if pageType == PageType.experiences{
            //CompanyNameTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }else{
            CompanyNameTxtField.placeholder = "Add New Link"
            departmentTxtField.placeholder = "Address"
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(openLinksPopup))
            CompanyNameTxtField.addGestureRecognizer(recognizer)
            CompanyNameTxtField.isUserInteractionEnabled = true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !textField.text!.isEmpty{
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.searchResultsDataList.append("Microsoft1")
                self.searchResultsDataList.append("Microsoft2")
                self.searchResultsDataList.append("Microsoft3")
                self.searchResultsDataList.append("Microsoft4")
                self.searchResultsDataList.append("Microsoft5")
                if !self.searchResultsDataList.isEmpty{
                    self.tableViewSearchResult.reloadData()
                    self.tableViewSearchResult.isHidden = false
                }else{
                    self.tableViewSearchResult.isHidden = true
                }
            }
        }else{
            self.tableViewSearchResult.isHidden = true //and clear list
        }
    }
    
    @objc func openLinksPopup(){
        self.view.endEditing(true)
        let p = StringPickerPopover(title: "Website", choices: ["Facebook","Twitter","Linkedin","Instagram","Youtube","Github"])
            .setDoneButton(color:#colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)){
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
                self.CompanyNameTxtField.text = selectedString
            }
            .setCancelButton(color: #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1), action: { _, _, _ in
                print("cancel")
            })
        p.setArrowColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        p.appear(originView: self.CompanyNameTxtField, baseViewController: self)
        p.disappearAutomatically(after: 5.0, completion: { print("automatically hidden")} )
    }
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        switch pageType {
        case .experiences:
            self.expList.append(Experience(companyId: "1", companyName: CompanyNameTxtField.text!, department: departmentTxtField.text!, experienceId: nil, stillWork: true, workerId: CurrentUser.shared.userId ?? ""))
        case .links:
            print("links")
        }
        
        //self.experiencesDataList.insert(ExperiencesAndLinks(companyAndWebName: CompanyNameTxtField.text!,
                                                            //departmentAndLinkName: departmentTxtField.text!), at: 0)
        self.tableViewExperiences.reloadData()
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        expDelegate?.didUpdatedExperiences(expList: expList)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExperiencesAndLinksEditViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == tableViewExperiences{
//            return experiencesDataList.count
//        }else{
//            return searchResultsDataList.count
//        }
        switch pageType {
        case .experiences:
            return expList.count
        case .links:
            print("links")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewExperiences{
            let cell = Bundle.main.loadNibNamed("ExperiencesEditCell", owner: self, options: nil)?.first as? ExperiencesEditCell
            cell?.compNameLabel.text = expList[indexPath.row].companyName ?? ""
            cell?.deptLabel.text = expList[indexPath.row].department ?? ""
            if indexPath.row == self.experiencesDataList.count-1{ //last one
                cell?.icon.image = UIImage(named:"normalExp")
            }
            return cell!
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.textLabel?.text = self.searchResultsDataList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewExperiences{
            tableView.deselectRow(at: indexPath, animated: false)
        }else{
            tableView.isHidden = true
            self.CompanyNameTxtField.text = self.searchResultsDataList[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == tableViewExperiences{
            if editingStyle == .delete{
                self.expList.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}
