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
        model.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.displayData(data)
            case .failure(let error):
                print("Error fetching headlines: \(error)")
            }
        }
    }
}
