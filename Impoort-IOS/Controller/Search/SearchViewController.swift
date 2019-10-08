//
//  SearchViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 8.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var searchTxtField: UITextField!
    let filterItems = ["Startup","Developer", "Investor", "Look for a team", "Just a user"]
    var filteredIndex = [Int]() // 0,1,2,3.. bu id türleri indexpath.row olarak alınacak. bu türlere göre sorgulama yapılacak. >1 ise and ile
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        if let flowLayout = filterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        
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
        cell.filterNameTxtLabel.text = self.filterItems[indexPath.row]
        cell.filterNameTxtLabel.layer.masksToBounds = true
        cell.filterNameTxtLabel.layer.cornerRadius = 11
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 11*self.filterItems[indexPath.row].count
        return CGSize(width: width, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterSearchCollectionViewCell else {return}
        if cell.isSelectedCell{
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
        cell.isSelectedCell = !cell.isSelectedCell
    }
    
}
