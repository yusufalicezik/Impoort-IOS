//
//  HitsViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 8.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import collection_view_layouts
import SDWebImage

class HitsViewController: BaseViewController {

    let imgData = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6"),UIImage(named: "7"),UIImage(named: "8"),UIImage(named: "9"),UIImage(named: "10"),UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6"),UIImage(named: "7"),UIImage(named: "8"),UIImage(named: "9"),UIImage(named: "10"),UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6"),UIImage(named: "7"),UIImage(named: "8")]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    private var bestPostsList: [PostResponseDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearHeader()
        setup()
        fetchPostsData()
        // Do any additional setup after loading the view.
    }
    func setup(){
        self.addSwipeDismiss(vc: self)
        IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.enableAutoToolbar = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.searchTxtField.delegate = self
        setCollectionLayout()
        self.searchTxtField.layer.cornerRadius = 15
        TxtFieldConfig.shared.addIconForSharp(to: self.searchTxtField, iconName: "diyez")
    }
    
    func setCollectionLayout(){
        let layout:BaseLayout = FlickrLayout()
        layout.delegate = self
        layout.cellsPadding = ItemsPadding(horizontal: 6, vertical: 6)
        self.collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    private func fetchPostsData() {
        DiscoverControllerAPI.discoverPostsUsingGET { [weak self] (postList, error) in
            if error == nil {
                if let postsList = postList {
                    self?.bestPostsList = postsList
                }
            }
        }
    }

}
extension HitsViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestPostsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HitsCollectionCell else {return UICollectionViewCell()}
        cell.postImageView.sd_setImage(with: URL(string: bestPostsList[indexPath.row].mediaUrl ?? "https://pngimage.net/wp-content/uploads/2019/05/empty-profile-picture-png-2.png")!, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected index \(indexPath.row)")
    }
}

extension HitsViewController: LayoutDelegate{
    func cellSize(indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 120)
    }
}
extension HitsViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty{
            openSearchVCWithKey(with:textField.text!)
        }
        return true
    }
    func openSearchVCWithKey(with txtKey:String){
        print(txtKey)
        let vc = UIStoryboard(name: "External", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as? FilterResultViewController
        vc?.searchFilterKey = txtKey
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}
