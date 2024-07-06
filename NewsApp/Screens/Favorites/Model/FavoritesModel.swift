//
//  FavoritesModel.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation

class FavoritesModel: FavoritesModelProtocol {
    func fetchData(completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        TopHeadlinesService.getTopHeadlines(for: "us", completion: completion)
    }
}
