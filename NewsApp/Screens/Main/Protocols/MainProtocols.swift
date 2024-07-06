//
//  MainProtocols.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func displayData(_ data: TopHeadlinesResponse)
}

protocol MainViewDelegate: AnyObject {
    func navigateToArticle(url: URL)
    func didScroll(_ scrollView: UIScrollView)
    func onFavoritePress(article: ArticleTableViewCellModel)
}

protocol MainModelProtocol {
    func fetchData(completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
    func fetchFavoriteArticles()
    func isFavorite(title: String) -> Bool
}

protocol MainPresenterProtocol: AnyObject {
    func loadData()
    func fetchFavoriteArticles()
    func isFavoriteArticle(title: String) -> Bool
}
