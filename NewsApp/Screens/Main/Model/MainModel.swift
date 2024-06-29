//
//  MainModel.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class MainModel: MainModelProtocol {
    func fetchData(completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        TopHeadlinesService.getTopHeadlines(for: "us", completion: completion)
    }
}
