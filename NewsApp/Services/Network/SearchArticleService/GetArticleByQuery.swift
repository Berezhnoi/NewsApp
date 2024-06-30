//
//  GetArticleByQuery.swift
//  NewsApp
//
//  Created by rendi on 30.06.2024.
//

import Foundation

class GetArticleByQueryEndpoint: APIEndpoint {
    typealias ResponseType = TopHeadlinesResponse
    
    let path: String
    let method = "GET"
    let headers: [String: String]?
    let body: Data?
    
    init(query: String, page: Int) {
        self.path = "/everything?q=\(query)&sortBy=popularity&page=\(page)"
        self.headers = nil
        self.body = nil
    }
}

