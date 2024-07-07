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
        for countryCode: String?,
        category: String? = nil,
        completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
    {
        let endpoint: GetTopHeadlinesEndpoint = GetTopHeadlinesEndpoint(countryCode: countryCode, category: category)
        apiClient.request(endpoint) { result in
            completion(result)
        }
    }
}
