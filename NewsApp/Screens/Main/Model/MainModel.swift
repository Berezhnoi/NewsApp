//
//  MainModel.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class MainModel: MainModelProtocol {
    private var favoriteArticles: [FavoriteArticleCD] = []
    
    func fetchFavoriteArticles() {
        favoriteArticles = CoreDataFavoriteService.shared.fetchFavoriteArticles()
    }
    
    func isFavorite(title: String) -> Bool {
        return favoriteArticles.contains { $0.title == title }
    }

    func fetchData(countryCode: String? = nil, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        TopHeadlinesService.getTopHeadlines(for: countryCode, completion: completion)
    }
}
