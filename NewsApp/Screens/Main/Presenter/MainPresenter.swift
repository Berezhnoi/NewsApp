//
//  MainPresenter.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var model: MainModelProtocol
    
    init(view: MainViewProtocol, model: MainModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func loadData(countryCode: String? = nil) {
        model.fetchData(countryCode: countryCode) { [weak self] result in
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
