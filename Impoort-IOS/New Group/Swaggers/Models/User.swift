//
// User.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct User: Codable {

    public enum UserType: Int, Codable {
        case investor = 0
        case startup = 1
        case developer = 2
        case normalUser = 3
    }
    public var active: Bool?
    public var activeGuide: String?
    public var birthDate: String?
    public var city: String?
    public var confirmed: Bool?
    public var department: String?
    public var _description: String?
    public var email: String?
    public var employeeCount: Int?
    public var firstName: String?
    public var fullName: String?
    public var gender: String?
    public var lastName: String?
    public var links: [String:String]?
    public var password: String?
    public var phoneNumber: String?
    public var profileImgUrl: String?
    public var userId: String?
    public var userType: UserType?
    public var watchPosts: [WatchPost]?
    public var watcherCount: Int?
    public var watchingCount: Int?
    public var watchingPostCount: Int?

    public init(active: Bool?, activeGuide: String?, birthDate: String?, city: String?, confirmed: Bool?, department: String?, _description: String?, email: String?, employeeCount: Int?, firstName: String?, fullName: String?, gender: String?, lastName: String?, links: [String:String]?, password: String?, phoneNumber: String?, profileImgUrl: String?, userId: String?, userType: UserType?, watchPosts: [WatchPost]?, watcherCount: Int?, watchingCount: Int?, watchingPostCount: Int?) {
        self.active = active
        self.activeGuide = activeGuide
        self.birthDate = birthDate
        self.city = city
        self.confirmed = confirmed
        self.department = department
        self._description = _description
        self.email = email
        self.employeeCount = employeeCount
        self.firstName = firstName
        self.fullName = fullName
        self.gender = gender
        self.lastName = lastName
        self.links = links
        self.password = password
        self.phoneNumber = phoneNumber
        self.profileImgUrl = profileImgUrl
        self.userId = userId
        self.userType = userType
        self.watchPosts = watchPosts
        self.watcherCount = watcherCount
        self.watchingCount = watchingCount
        self.watchingPostCount = watchingPostCount
    }

    public enum CodingKeys: String, CodingKey { 
        case active
        case activeGuide
        case birthDate
        case city
        case confirmed
        case department
        case _description = "description"
        case email
        case employeeCount
        case firstName
        case fullName
        case gender
        case lastName
        case links
        case password
        case phoneNumber
        case profileImgUrl
        case userId
        case userType
        case watchPosts
        case watcherCount
        case watchingCount
        case watchingPostCount
    }


}

