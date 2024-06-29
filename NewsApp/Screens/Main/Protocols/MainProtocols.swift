//
//  MainProtocols.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func displayData(_ articles: [Article])
}

protocol MainViewDelegate: AnyObject {
    func navigateToArticle(url: URL)
}

protocol MainModelProtocol {
    func fetchData(completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
}

protocol MainPresenterProtocol: AnyObject {
    func loadData()
}
