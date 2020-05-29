//
//  SearchService.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 29.05.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchService {
    
    static let shared = SearchService()
    
    typealias completion = ((_ responseList: [UserResponseDTO])->Void)
    
    func searchRequest(text: String, types: [String],
                       completion: @escaping completion) {
        
        var type = ""
        for i in 0..<types.count {
            if i != types.count-1 {
                type += "\(types[i]),"
            } else {
                type += "\(types[i])"
            }
        }
        print(type)
        let params = [
            "fullName": text,
            "userType": type] as [String : Any]
                
        let h: HTTPHeaders = ["Content-Type": "application/json",
        "Accept": "application/json", "Authorization": UserDefaults.standard.string(forKey: "AuthJWT")!]
                
        Alamofire.request(URL(string: "http://ec2-18-156-84-119.eu-central-1.compute.amazonaws.com/api/v1/search/ios")!, method: .get, parameters: params ,headers: h).responseJSON { (data) in
            print(data)
            if data.result.isSuccess {
                let json = JSON(data.result.value!)
                print(json)
                var response: [UserResponseDTO] = []
                for i in 0..<json.arrayValue.count {
                    
                    var profUrl = ""
                    if let url = json[i]["profileImgUrl"].string {
                        profUrl = url
                    }
                    
                    let user = UserResponseDTO(active: false, activeGuide: "", birthDate: "", city: "", confirmed: false, department: json[i]["department"].stringValue , _description: "", email: "", employeeCount: 0, employees: nil, experiences: nil, firstName: json[i]["firstName"].stringValue, fullName: json[i]["fullName"].stringValue, gender: "", lastName: json[i]["lastName"].stringValue, links: nil, phoneNumber: nil, profileImgUrl: profUrl, userId: json[i]["userId"].stringValue, userType: nil, watcherCount: 0, watchingCount: 0, watchingPostCount: 0)
                    
                    response.append(user)
                    
                }
                completion(response)
            }
            print(data)
        }

    }
    
}
