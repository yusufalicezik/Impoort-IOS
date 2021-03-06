//
// Comment.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Comment: Codable {


    public var commentId: Int?
    public var commentText: String?
    public var user: User?

    public init(commentId: Int?, commentText: String?, user: User?) {
        self.commentId = commentId
        self.commentText = commentText
        self.user = user
    }


}

