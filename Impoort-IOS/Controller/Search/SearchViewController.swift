//
//  SearchViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 8.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
struct FilterView {
    var filterName:String
    var isSelected:Bool
}
class SearchViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var searchTxtField: UITextField!
    var filterItems = [FilterView(filterName: "Startup", isSelected: false),FilterView(filterName: "Developer", isSelected: false),
                       FilterView(filterName: "Investor", isSelected: false), FilterView(filterName: "Look for a team", isSelected: false),
                        FilterView(filterName: "Just a user", isSelected: false)]
    var filteredIndex = [Int]() // 0,1,2,3.. bu id türleri indexpath.row olarak alınacak. bu türlere göre sorgulama yapılacak. >1 ise and ile
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterHeightConstraint: NSLayoutConstraint!
    var searchVisible = true
    var prevOffset:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        self.searchTxtField.layer.cornerRadius = 15
        TxtFieldConfig.shared.givePadding(to: self.searchTxtField)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.filterView.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    @IBAction func messageButtonClicked(_ sender: Any) {
        self.goToMessagesGeneral()
    }
    
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MessagesGeneralCell
        return cell!
    }
    
    
}
extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterItems.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? FilterSearchCollectionViewCell else { return UICollectionViewCell()}
        cell.filterNameTxtLabel.text = self.filterItems[indexPath.row].filterName
        cell.filterNameTxtLabel.layer.masksToBounds = true
        cell.filterNameTxtLabel.layer.cornerRadius = 11
        if self.filterItems[indexPath.row].isSelected{
            cell.filterNameTxtLabel.backgroundColor =  #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }else{
            cell.filterNameTxtLabel.backgroundColor =  #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 11*self.filterItems[indexPath.row].filterName.count
        return CGSize(width: width, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterSearchCollectionViewCell else {return}
        if self.filterItems[indexPath.row].isSelected{
            cell.filterNameTxtLabel.backgroundColor =  #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
            var deletedFilterIndex = -1
            for i in 0..<filteredIndex.count{
                if self.filteredIndex[i] == indexPath.row{
                    deletedFilterIndex = i
                }
            }
            if deletedFilterIndex > -1{
                self.filteredIndex.remove(at: deletedFilterIndex)
            }
        }else{
            cell.filterNameTxtLabel.backgroundColor =  #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            self.filteredIndex.append(indexPath.row)
        }
        print("Filterelenecekler : \(self.filteredIndex)")
        filterItems[indexPath.row].isSelected = !filterItems[indexPath.row].isSelected
    }
    
}

extension SearchViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
            let offsetY = scrollView.contentOffset.y
            if offsetY < 0 {
                scrollView.contentOffset.y = CGFloat(0.0)
                UIView.animate(withDuration: 0.2){
                    self.view.layoutIfNeeded()
                }
            }
            else if offsetY > prevOffset && offsetY > 0.0{
                self.filterHeightConstraint.constant = 0.0
            }else{
                self.filterHeightConstraint.constant = 45.0
                
            }
            UIView.animate(withDuration: 0.4){
                self.view.layoutIfNeeded()
            }
            self.prevOffset = offsetY
        }else if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                //self.tableView.reloadData() paging.
            }
        }else if (scrollView.contentOffset.y < 0){
            //reach top
        }
        
    }
    
    func clearSearchFilter(){
        for i in 0..<self.filterItems.count{
            let cell = filterCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? FilterSearchCollectionViewCell
            guard let mCell = cell else {return}
            mCell.filterNameTxtLabel.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
        }
        for i in 0..<self.filterItems.count{
            let cell = filterCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? FilterSearchCollectionViewCell
            guard let mCell = cell else {return}
            if mCell.isSelectedCell{
                print("secilmiş mavi oalcak.  \(self.filterItems[i])")
            }
        }
        
    }
}
