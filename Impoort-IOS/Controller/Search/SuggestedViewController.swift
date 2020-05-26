//
//  SuggestedViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 22.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

class SuggestedViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var searchRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTxtField: UITextField!
    var widthConstraint:NSLayoutConstraint?
    var widthConstraintShort:NSLayoutConstraint?
    var leftRecognizer:UITapGestureRecognizer?
    var isOpenedSearchBar = false
    var isFirstTime = true
    var isSearchResultOpened = false
    
    /*
     UserResponseDTO(active: true, activeGuide: "asd", birthDate: "123123", city: "İstanbul", confirmed: true, department: "iOS Geliştirici", _description: "iOS Developer at Appcent", email: "yusuf.cezik@appcent.mobi", employeeCount: 2, employees: nil, experiences:[
         
         Experience(companyId: "asd", companyName: "Appcent", department: "iOS Developer", experienceId: 2, stillWork: true, workerId: "dd"),
          Experience(companyId: "ased", companyName: "Nuevo Softwarehouse", department: "iOS Intern", experienceId: 2, stillWork: false, workerId: "dd"),
          Experience(companyId: "adsd", companyName: "Mercedes-Benz", department: "IT Intern", experienceId: 2, stillWork: false, workerId: "dd")
     
     
     ], firstName: "Yusuf Ali", fullName: "Yusuf Ali Cezik", gender: "Erkek", lastName: "Cezik", links: ["github": "/yusufalicezik", "facebook": "/yusufalicezik", "linkedin": "/klecon"], phoneNumber: "123123", profileImgUrl: "https://www.klasiksanatlar.com/img/sayfalar/b/1_1534620012_Ekran-Resmi-2018-08-18-22.25.18.png", userId: "23", userType: .developer, watcherCount: 123, watchingCount: 22, watchingPostCount: 2)
     */
    var userList: [UserResponseDTO] = []
    
    var searchResultView:SearchView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.clearHeader()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    func setup(){
        self.searchTxtField.delegate = self
        self.searchTxtField.layer.cornerRadius = 15
        self.searchTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        TxtFieldConfig.shared.addIconForSearch(to: self.searchTxtField, iconName: "search")

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        leftRecognizer = UITapGestureRecognizer(target: self, action: #selector(didClickedSearch))
        self.searchTxtField.addGestureRecognizer(leftRecognizer!)
        self.searchTxtField.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
        collectionView.delaysContentTouches = false

    }
    
    private func fetchData() {
        DiscoverControllerAPI.discoverUserUsingGET {  [weak self] (userResponseList, error) in
            if error == nil && userResponseList != nil {
                self?.userList = userResponseList!
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func didClickedSearch(){
        print("asd")
        if !self.isOpenedSearchBar{
            self.widthConstraint = NSLayoutConstraint(item: searchTxtField!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -30)
        self.widthConstraintShort?.isActive = false
        self.widthConstraint?.isActive = true
            logo.isHidden = true
        UIView.animate(withDuration: 0.4){
            self.headerView.layoutIfNeeded()
            self.setPlaceHolder(true)
        }
        self.searchTxtField.becomeFirstResponder()
        self.isOpenedSearchBar = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        fetchData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func clearHeader(){
        UIView.animate(withDuration: 0.2){
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func setPlaceHolder(_ isAppear:Bool = false){
        if isAppear{
            self.searchTxtField.placeholder = "Search"
        }else{
            self.searchTxtField.placeholder = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.textFieldDidEndEditing(self.searchTxtField)
        self.searchTxtField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text!.count)
        
        if textField.text!.count == 1{
            //            self.didClickedSearch()
            if !isSearchResultOpened{
                isSearchResultOpened = true
                TxtFieldConfig.shared.giveCloseToRight(to: textField, parentVC: self) {
                    self.searchTxtField.text = ""
                    self.closeSearchResult(self.searchTxtField)
                    self.searchTxtField.resignFirstResponder()
                    self.smallerSearchBar()
                }
            }
        }else if textField.text!.count == 0{
            self.closeSearchResult(textField)
        }
        
        if !textField.text!.isEmpty {
            self.loadSearchResultsView(text: textField.text!)
        }
    }
    
    
    func closeSearchResult(_ textfield:UITextField){
        TxtFieldConfig.shared.giveEmptyToRight(to: textfield)
        if let mSearchView = self.searchResultView{
            UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                mSearchView.removeFromSuperview()
                self.isSearchResultOpened = false
            }, completion: nil)
        }
    }
    
    func smallerSearchBar(){
        self.widthConstraintShort = NSLayoutConstraint(item: searchTxtField!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .width, multiplier: 1, constant: 35)
        widthConstraintShort?.priority = UILayoutPriority(rawValue: 999)
        self.widthConstraint?.isActive = false
        self.widthConstraintShort?.isActive = true
        logo.isHidden = false
        UIView.animate(withDuration: 0.3){
            self.setPlaceHolder()
            self.headerView.layoutIfNeeded()
        }
        self.isOpenedSearchBar = false
        searchTxtField.addGestureRecognizer(leftRecognizer!)
    }
}
extension SuggestedViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.didClickedSearch()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 && self.isOpenedSearchBar{
            self.smallerSearchBar()
        }else if textField.text!.count > 0{
            searchTxtField.removeGestureRecognizer(leftRecognizer!)
        }
    }
    
    func loadSearchResultsView(text: String){
        if let mSearchView = self.searchResultView{
            UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                mSearchView.removeFromSuperview()
                self.isSearchResultOpened = false
            }, completion: nil)
        }
        self.searchResultView = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as? SearchView
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.searchResultView!)
        }, completion: nil)
        self.searchResultView?.translatesAutoresizingMaskIntoConstraints = false
        self.searchResultView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        self.searchResultView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        let bottomConst = self.searchResultView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
        bottomConst?.priority = UILayoutPriority(rawValue: 999)
        bottomConst?.isActive = true
        self.searchResultView?.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0.0).isActive = true
        fetchSearchData(text: text)
    }
    
    
    private func fetchSearchData(text: String) {
        searchResultView?.fetchData(text: text)
    }
}
extension SuggestedViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SuggestedCollectionCell else{ return UICollectionViewCell()}
        cell.profileNameLabel.text = userList[indexPath.row].fullName ?? ""
        cell.profileSectorLabel.text = userList[indexPath.row].department ?? ""
        
        if let url = URL(string: userList[indexPath.row].profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png") {
            cell.profileImgView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice().userInterfaceIdiom == .phone {
            var height = collectionView.frame.width / 2.1
            return CGSize(width: (collectionView.frame.width / 2) - 5, height: (height) - 7)
        }
        let widthDivide = collectionView.frame.width / 130
            return CGSize(width: (collectionView.frame.width / round(widthDivide)) - 10, height: 230)
    }
    
}
