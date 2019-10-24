//
//  SearchView.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 24.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class SearchView: UIView {
    @IBOutlet weak var collectionViewFilter: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var filterItems = [FilterView(filterName: "Startup", isSelected: false),FilterView(filterName: "Developer", isSelected: false),
                       FilterView(filterName: "Investor", isSelected: false), FilterView(filterName: "Look for a team", isSelected: false),
                       FilterView(filterName: "Just a user", isSelected: false)]
    var filteredIndex = [Int]() // 0,1,2,3.. bu id türleri indexpath.row olarak alınacak. bu türlere göre sorgulama yapılacak. >1 ise and ile
    @IBOutlet weak var filterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterView: UIView!
    var searchVisible = true
    var prevOffset:CGFloat = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "FilterNewCollectionViewCell", bundle: nil)
        collectionViewFilter?.register(nib, forCellWithReuseIdentifier: "FilterNewCollectionViewCell")
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.collectionViewFilter.delegate = self
        self.collectionViewFilter.dataSource = self
        self.filterView.translatesAutoresizingMaskIntoConstraints = false
        

    }

}

extension SearchView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewFilter.dequeueReusableCell(withReuseIdentifier: "FilterNewCollectionViewCell", for: indexPath) as? FilterNewCollectionViewCell else { return UICollectionViewCell()}
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterNewCollectionViewCell else {return}
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


extension SearchView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("WatcherCell", owner: self, options: nil)?.first as? WatcherCell else {return UITableViewCell()}
        return cell
    }

    
}
extension SearchView:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
            let offsetY = scrollView.contentOffset.y
            if offsetY < 0 {
                scrollView.contentOffset.y = CGFloat(0.0)
                UIView.animate(withDuration: 0.2){
                    self.layoutIfNeeded()
                }
            }
            else if offsetY > prevOffset && offsetY > 0.0{
                self.filterHeightConstraint.constant = 0.0
            }else{
                self.filterHeightConstraint.constant = 45.0
                
            }
            UIView.animate(withDuration: 0.4){
                self.layoutIfNeeded()
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
            let cell = collectionViewFilter.cellForItem(at: IndexPath(row: i, section: 0)) as? FilterSearchCollectionViewCell
            guard let mCell = cell else {return}
            mCell.filterNameTxtLabel.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.7254901961, blue: 0.6470588235, alpha: 1)
        }
        for i in 0..<self.filterItems.count{
            let cell = collectionViewFilter.cellForItem(at: IndexPath(row: i, section: 0)) as? FilterSearchCollectionViewCell
            guard let mCell = cell else {return}
            if mCell.isSelectedCell{
                print("secilmiş mavi oalcak.  \(self.filterItems[i])")
            }
        }
        
    }
}
