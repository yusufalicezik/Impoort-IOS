//
//  SearchView.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 24.10.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SDWebImage

class SearchView: UIView {
    
    private var lastText: String = ""
    
    @IBOutlet weak var collectionViewFilter: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var filterItems = [FilterView(filterName: "startup", isSelected: false),FilterView(filterName: "developer", isSelected: false),
                       FilterView(filterName: "investor", isSelected: false), FilterView(filterName: "Look for a team", isSelected: false),
                       FilterView(filterName: "Just a user", isSelected: false)]
    var filteredIndex = [Int]() // 0,1,2,3.. bu id türleri indexpath.row olarak alınacak. bu türlere göre sorgulama yapılacak. >1 ise and ile
    @IBOutlet weak var filterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterView: UIView!
    var searchVisible = true
    var prevOffset:CGFloat = 0.0
    weak var parentVC: SuggestedViewController?
    
    var searchUserList: [UserResponseDTO] = []
    /*
     UserResponseDTO(active: true, activeGuide: "asd", birthDate: "123123", city: "İstanbul", confirmed: true, department: "iOS Geliştirici", _description: "iOS Developer at Appcent", email: "yusuf.cezik@appcent.mobi", employeeCount: 2, employees: nil, experiences:[
         
         Experience(companyId: "asd", companyName: "Appcent", department: "iOS Developer", experienceId: 2, stillWork: true, workerId: "dd"),
          Experience(companyId: "ased", companyName: "Nuevo Softwarehouse", department: "iOS Intern", experienceId: 2, stillWork: false, workerId: "dd"),
          Experience(companyId: "adsd", companyName: "Mercedes-Benz", department: "IT Intern", experienceId: 2, stillWork: false, workerId: "dd")
     
     
     ], firstName: "Yusuf Ali", fullName: "Yusuf Ali Cezik", gender: "Erkek", lastName: "Cezik", links: ["github": "/yusufalicezik", "facebook": "/yusufalicezik", "linkedin": "/klecon"], phoneNumber: "123123", profileImgUrl: "https://www.klasiksanatlar.com/img/sayfalar/b/1_1534620012_Ekran-Resmi-2018-08-18-22.25.18.png", userId: "23", userType: .developer, watcherCount: 123, watchingCount: 22, watchingPostCount: 2)
     */
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

    func fetchData(text: String) {
        lastText = text

        var userTypes: [String] = []
        for i in filteredIndex {
            if i <= 2 {
                userTypes.append(filterItems[i].filterName.lowercased())
            }
        }

        
//        SearchService.shared.searchRequest(text: text, types: userTypes) { [weak self] (responseList) in
//                self?.searchUserList = responseList
//                self?.tableView.reloadData()
//        }
        
        SearchControllerAPI.searchUserUsingGET(searchRequest: SearchRequest(fullName: lastText, userTypes: [.developer, .normalUser])) { [weak self] (respo, err) in
            if let resp = respo {
                self?.searchUserList = resp
                self?.tableView.reloadData()
            }
        }
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
        var userTypes: [String] = []
        
        for i in filteredIndex {
            if i <= 2 {
                userTypes.append(filterItems[i].filterName.lowercased())
            }
        }
        
  
        
        SearchControllerAPI.searchUserUsingGET(searchRequest: SearchRequest(fullName: lastText, userTypes: [.developer, .investor, .startup])) { [weak self] (respo, err) in
            if let resp = respo {
                self?.searchUserList = resp
                self?.tableView.reloadData()
            }
        }
    }
    
}


extension SearchView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("WatcherCell", owner: self, options: nil)?.first as? WatcherCell else {return UITableViewCell()}
        cell.profileNAmeSurnameLabel.text = (searchUserList[indexPath.row].firstName ?? "") + (searchUserList[indexPath.row].lastName ?? "")
        cell.profileSectorLabel.text = searchUserList[indexPath.row].department ?? ""
        
        if let url = URL(string: searchUserList[indexPath.row].profileImgUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png") {
            cell.profileImg.sd_setImage(with: url, completed: nil)

        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let vc = parentVC, let id = searchUserList[indexPath.row].userId  else { return }
        vc.goToProfile(id)
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
