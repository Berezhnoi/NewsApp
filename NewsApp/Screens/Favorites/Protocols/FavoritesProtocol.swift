//
//  FavoritesProtocol.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation
import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func displayData(_ data: TopHeadlinesResponse)
}

protocol FavoritesViewDelegate: AnyObject {
    func navigateToArticle(url: URL)
    func didScroll(_ scrollView: UIScrollView)
}

protocol FavoritesModelProtocol {
    func fetchData(completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
}

protocol FavoritesPresenterProtocol: AnyObject {
    func loadData()
}

