//
//  MainModel.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class MainModel: MainModelProtocol {
    private var favoriteArticles: [FavoriteArticleCD] = []
    
    init() {
        fetchFavoriteArticles()
    }
    
    func fetchFavoriteArticles() {
        favoriteArticles = CoreDataFavoriteService.shared.fetchFavoriteArticles()
    }
    
    func isFavorite(title: String, url: String) -> Bool {
        return favoriteArticles.contains { $0.title == title && $0.url == url }
    }

    func fetchData(completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        TopHeadlinesService.getTopHeadlines(for: "us", completion: completion)
    }
}
