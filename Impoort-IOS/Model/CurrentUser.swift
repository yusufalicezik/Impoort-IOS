//
//  CurrentUser.swift
//  Impoort-IOS
//
//  Created by Yusuf ali cezik on 24.05.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

class CurrentUser {
    static let shared = CurrentUser()
    var userId: String?
    var description:String?
    var sector:String?
    var userType:Int?
    var firstName:String?
    var password:String?
    var lastName:String?
    var email:String?
    var city:String?
    var birthDate:String?
    var gender:String?
    var phoneNumber:String?
    var experienceYear:String?
    var experiences: [Experience]?
    var links: [String:String]?
    var employeeCount:Int?
    var profileImgUrl: String?
}
