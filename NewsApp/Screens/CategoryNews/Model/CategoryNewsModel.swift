//
//  CategoryNewsModel.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import Foundation

class CategoryNewsModel: CategoryNewsModelProtocol {
    private var favoriteArticles: [FavoriteArticleCD] = []
    
    func fetchFavoriteArticles() {
        favoriteArticles = CoreDataFavoriteService.shared.fetchFavoriteArticles()
    }
    
    func isFavorite(title: String) -> Bool {
        return favoriteArticles.contains { $0.title == title }
    }

    func fetchData(countryCode: String? = nil, category: String, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        TopHeadlinesService.getTopHeadlines(for: countryCode, category: category, completion: completion)
    }
}
