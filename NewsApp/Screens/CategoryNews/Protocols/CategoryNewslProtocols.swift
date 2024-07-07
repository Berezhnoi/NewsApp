//
//  CategoryNewslProtocols.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

protocol CategoryNewsViewProtocol: AnyObject {
    func displayData(_ data: TopHeadlinesResponse)
}

protocol CategoryNewsModelProtocol {
    func fetchData(category: String, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
    func fetchFavoriteArticles()
    func isFavorite(title: String) -> Bool
}

protocol CategoryNewsPresenterProtocol: AnyObject {
    func loadData()
    func fetchFavoriteArticles()
    func isFavoriteArticle(title: String) -> Bool
}
