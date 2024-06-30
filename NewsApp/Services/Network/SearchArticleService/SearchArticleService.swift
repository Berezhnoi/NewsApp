//
//  SearchArticleService.swift
//  NewsApp
//
//  Created by rendi on 30.06.2024.
//

import Foundation

class SearchArticleService {
    private static let apiClient: APIClient = APIClient()
    
    public static func getArticleByQuery(with query: String, page: Int, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        let endpoint: GetArticleByQueryEndpoint = GetArticleByQueryEndpoint(query: query, page: page)
        apiClient.request(endpoint) { result in
            completion(result)
        }
    }
}
