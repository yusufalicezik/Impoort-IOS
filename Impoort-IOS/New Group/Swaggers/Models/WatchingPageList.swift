//
// WatchingPageList.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct WatchingPageList: Codable {

    public var content: [Watching]?
    public var empty: Bool?
    public var first: Bool?
    public var last: Bool?
    public var number: Int?
    public var numberOfElements: Int?
    public var pageable: Pageable?
    public var size: Int?
    public var sort: Sort?
    public var totalElements: Int64?
    public var totalPages: Int?

    public init(content: [Watching]?, empty: Bool?, first: Bool?, last: Bool?, number: Int?, numberOfElements: Int?, pageable: Pageable?, size: Int?, sort: Sort?, totalElements: Int64?, totalPages: Int?) {
        self.content = content
        self.empty = empty
        self.first = first
        self.last = last
        self.number = number
        self.numberOfElements = numberOfElements
        self.pageable = pageable
        self.size = size
        self.sort = sort
        self.totalElements = totalElements
        self.totalPages = totalPages
    }


}

