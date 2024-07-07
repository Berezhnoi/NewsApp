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
    
    init(countryCode: String? = nil, category: String? = nil) {
        self.headers = nil
        self.body = nil
        self.path = GetTopHeadlinesEndpoint.buildPath(countryCode: countryCode, category: category)
    }
    
    private static func buildPath(countryCode: String?, category: String? = nil) -> String {
        var basePath = "/top-headlines"
        
        var queryParams: [String] = []
        
        if let countryCode = countryCode {
            queryParams.append("country=\(countryCode)")
        } else {
            queryParams.append("country=ua")
        }
        
        if let category = category, !category.isEmpty {
            let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
            queryParams.append("category=\(encodedCategory)")
        }
        
        if !queryParams.isEmpty {
            basePath += "?" + queryParams.joined(separator: "&")
        }
        
        return basePath
    }
}
