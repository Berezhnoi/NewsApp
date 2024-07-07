//
//  FavoritesPresenter.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?
    var model: FavoritesModelProtocol
    
    init(view: FavoritesViewProtocol, model: FavoritesModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func loadData() {
        let data = model.fetchData()
        view?.displayData(data)
    }
    
    func searchFavorites(with query: String) -> [FavoriteArticleCD] {
        return model.searchFavorites(with: query)
    }
}
