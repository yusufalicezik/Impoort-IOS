//
//  SplashViewController.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 6.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class SplashViewController: UIViewController {

    var text = "Find Your\nInvestor\nStartup\nor\nTeam \nWith Impoort."
    var index = 0

    @IBOutlet weak var impoort: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonHeightConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        try? VideoBackground.shared.play(view: view, videoName: "myvideo", videoType: "mp4")
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.getTypeWriterAnim()
        }
    }
    func getTypeWriterAnim(){
        for i in self.text{
            self.impoort.text! += "\(i)"
                RunLoop.current.run(until: Date()+0.20)
            if i == "."{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    self.showLoginButton()
                }
            }
        }
    }
    
    deinit {
        VideoBackground.shared.pause()
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    func showLoginButton(){
        self.loginButtonHeightConst.constant = 40.0
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
            self.loginButton.isHidden = false
        }
    }
    @IBAction func loginClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
     }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
