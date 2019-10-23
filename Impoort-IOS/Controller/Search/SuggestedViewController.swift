//
//  SuggestedViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 22.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.clearHeader()
    }
    
    func setup(){
        self.searchTxtField.delegate = self
        self.searchTxtField.layer.cornerRadius = 15
        TxtFieldConfig.shared.addIconForSearch(to: self.searchTxtField, iconName: "search")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        leftRecognizer = UITapGestureRecognizer(target: self, action: #selector(didClickedSearch))
        self.searchTxtField.addGestureRecognizer(leftRecognizer!)
        self.searchTxtField.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
//        let width = (((collectionView?.layer.bounds.width)!-25) / 2.2   );
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//
//
//        layout.itemSize = CGSize(width: width, height: width);
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
}
extension SuggestedViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.didClickedSearch()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 && self.isOpenedSearchBar{
            self.widthConstraintShort = NSLayoutConstraint(item: searchTxtField!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .width, multiplier: 1, constant: 35)
            self.widthConstraint?.isActive = false
            self.widthConstraintShort?.isActive = true
            logo.isHidden = false
            UIView.animate(withDuration: 0.5){
                self.setPlaceHolder()
                self.headerView.layoutIfNeeded()
            }
            self.isOpenedSearchBar = false
            searchTxtField.addGestureRecognizer(leftRecognizer!)
        }else if textField.text!.count > 0{
            searchTxtField.removeGestureRecognizer(leftRecognizer!)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.searchTxtField.text!.count > -1 && !isOpenedSearchBar{
            self.didClickedSearch()
        }
        return true
    }
}
extension SuggestedViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SuggestedCollectionCell else{ return UICollectionViewCell()}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice().userInterfaceIdiom == .phone {

                
                return CGSize(width: (collectionView.frame.width / 2) - 5, height: (collectionView.frame.width / 1.9) - 7)
            }

            let widthDivide = collectionView.frame.width / 130
            return CGSize(width: (collectionView.frame.width / round(widthDivide)) - 10, height: 230)
    }
    
}
