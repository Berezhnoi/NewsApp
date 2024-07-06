//
//  FavoritesModel.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation

class FavoritesModel: FavoritesModelProtocol {
    func fetchData() -> [FavoriteArticleCD] {
        return CoreDataFavoriteService.shared.fetchFavoriteArticles()
    }
}
