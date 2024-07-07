//
//  FavoritesModel.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation

class FavoritesModel: FavoritesModelProtocol {
    private var favorites: [FavoriteArticleCD] = []

    func fetchData() -> [FavoriteArticleCD] {
        favorites = CoreDataFavoriteService.shared.fetchFavoriteArticles()
        return favorites
    }
    
    func searchFavorites(with query: String) -> [FavoriteArticleCD] {
        if query.isEmpty {
            return favorites
        } else {
            return favorites.filter { $0.title?.localizedCaseInsensitiveContains(query) == true }
        }
    }
}
