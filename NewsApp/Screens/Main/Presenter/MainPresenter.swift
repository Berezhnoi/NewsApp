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
    
    func loadData() {
        model.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.displayData(data.articles)
            case .failure(let error):
                print("Error fetching headlines: \(error)")
            }
        }
    }
}
