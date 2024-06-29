//
//  GetTopHeadlinesEndpoint.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class GetTopHeadlinesEndpoint: APIEndpoint {
    typealias ResponseType = TopHeadlinesResponse
    
    let path: String
    let method = "GET"
    let headers: [String: String]?
    let body: Data?
    
    init(countryCode: String) {
        self.path = "/top-headlines?country=\(countryCode)"
        self.headers = nil
        self.body = nil
    }
}
