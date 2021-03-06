//
// UserUpdateDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserUpdateDto: Codable {

    public enum UserType: String, Codable { 
        case investor = "INVESTOR"
        case startup = "STARTUP"
        case developer = "DEVELOPER"
        case normalUser = "NORMAL_USER"
    }
    public var birthDate: String?
    public var city: String?
    public var department: String?
    public var _description: String?
    public var email: String?
    public var employeeCount: Int?
    public var employees: [User]?
    public var experiences: [Experience]?
    public var firstName: String?
    public var gender: String?
    public var lastName: String?
    public var links: [String:String]?
    public var password: String?
    public var phoneNumber: String?
    public var profileImgUrl: String?
    public var userId: String?
    public var userType: UserType?

    public init(birthDate: String?, city: String?, department: String?, _description: String?, email: String?, employeeCount: Int?, employees: [User]?, experiences: [Experience]?, firstName: String?, gender: String?, lastName: String?, links: [String:String]?, password: String?, phoneNumber: String?, profileImgUrl: String?, userId: String?, userType: UserType?) {
        self.birthDate = birthDate
        self.city = city
        self.department = department
        self._description = _description
        self.email = email
        self.employeeCount = employeeCount
        self.employees = employees
        self.experiences = experiences
        self.firstName = firstName
        self.gender = gender
        self.lastName = lastName
        self.links = links
        self.password = password
        self.phoneNumber = phoneNumber
        self.profileImgUrl = profileImgUrl
        self.userId = userId
        self.userType = userType
    }

    public enum CodingKeys: String, CodingKey { 
        case birthDate
        case city
        case department
        case _description = "description"
        case email
        case employeeCount
        case employees
        case experiences
        case firstName
        case gender
        case lastName
        case links
        case password
        case phoneNumber
        case profileImgUrl
        case userId
        case userType
    }


}

