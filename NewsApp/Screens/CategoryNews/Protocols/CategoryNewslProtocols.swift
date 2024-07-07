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
    func fetchData(countryCode: String?, category: String, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
    func fetchFavoriteArticles()
    func isFavorite(title: String) -> Bool
}

protocol CategoryNewsPresenterProtocol: AnyObject {
    func loadData(countryCode: String?)
    func fetchFavoriteArticles()
    func isFavoriteArticle(title: String) -> Bool
}
