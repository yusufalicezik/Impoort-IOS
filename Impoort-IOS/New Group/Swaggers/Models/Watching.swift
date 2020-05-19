//
// Watching.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Watching: Codable {

    public var beingWatch: Bool?
    public var _id: Int?
    public var user: User?
    public var watchMapId: UUID?
    public var watcherUser: String?

    public init(beingWatch: Bool?, _id: Int?, user: User?, watchMapId: UUID?, watcherUser: String?) {
        self.beingWatch = beingWatch
        self._id = _id
        self.user = user
        self.watchMapId = watchMapId
        self.watcherUser = watcherUser
    }

    public enum CodingKeys: String, CodingKey { 
        case beingWatch
        case _id = "id"
        case user
        case watchMapId
        case watcherUser
    }


}

