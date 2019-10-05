import Foundation
import PopupDialog

public class AlertController {
    public static let shared = AlertController()
    
    public func showBasicAlert(viewCont:UIViewController,title:String, message:String, buttonTitle:String, _ dismissAction:@escaping ()->() = {}){
        let popup = PopupDialog(title: title, message: message)
        let buttonOne = DefaultButton(title: buttonTitle) {
            dismissAction()
        }
        popup.addButtons([buttonOne])
        popup.transitionStyle = .fadeIn
        let dialogAppearance = PopupDialogDefaultView.appearance()
//        dialogAppearance.titleColor = #colorLiteral(red: 0.9725490196, green: 0.9450980392, blue: 0.9803921569, alpha: 1)
//        dialogAppearance.titleFont = UIFont(name: "Avenir Heavy", size: 15.0)!
//        dialogAppearance.messageColor = #colorLiteral(red: 0.978782475, green: 0.9576403499, blue: 0.9845044017, alpha: 1)
//        dialogAppearance.backgroundColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
//        buttonOne.backgroundColor = #colorLiteral(red: 0.4375773668, green: 0.8031894565, blue: 0.7201564908, alpha: 1)
//        buttonOne.titleColor = #colorLiteral(red: 0.978782475, green: 0.9576403499, blue: 0.9845044017, alpha: 1)
//        buttonOne.titleFont = UIFont(name: "Avenir Heavy", size: 15.0)
        buttonOne.titleColor = #colorLiteral(red: 0.3952077329, green: 0.7244434953, blue: 0.6477216482, alpha: 1)
        viewCont.present(popup, animated: true, completion: nil)
    }
}
