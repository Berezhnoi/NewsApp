//
//  FavoritesProtocol.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

protocol FavoritesViewProtocol: AnyObject {
    func displayData(_ data: [FavoriteArticleCD])
}

protocol FavoritesModelProtocol {
    func fetchData() -> [FavoriteArticleCD]
    func searchFavorites(with query: String) -> [FavoriteArticleCD]
}

protocol FavoritesPresenterProtocol: AnyObject {
    func loadData()
    func searchFavorites(with query: String) -> [FavoriteArticleCD]
}

