//
//  CategoryNewsPresenter.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import Foundation

class CategoryNewsPresenter: CategoryNewsPresenterProtocol {
    weak var view: CategoryNewsViewProtocol?
    var model: CategoryNewsModelProtocol
    let category: String
    
    init(category: String, view: CategoryNewsViewProtocol, model: CategoryNewsModelProtocol) {
        self.category = category
        self.view = view
        self.model = model
    }
    
    func loadData() {
        model.fetchData(category: category) { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.displayData(data)
            case .failure(let error):
                print("Error fetching headlines: \(error)")
            }
        }
    }
    
    func fetchFavoriteArticles() {
        model.fetchFavoriteArticles()
    }
    
    func isFavoriteArticle(title: String) -> Bool {
        model.isFavorite(title: title)
    }
}
