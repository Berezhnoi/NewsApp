//
//  TopHeadlinesService.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class TopHeadlinesService {
    private static let apiClient: APIClient = APIClient()
    
    public static func getTopHeadlines(
        for countryCode: String? = nil,
        category: String? = nil,
        page: Int? = 1,
        completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
    {
        let endpoint: GetTopHeadlinesEndpoint = GetTopHeadlinesEndpoint(countryCode: countryCode, category: category, page: page)
        apiClient.request(endpoint) { result in
            completion(result)
        }
    }
}
