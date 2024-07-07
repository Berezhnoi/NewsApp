//
//  FavoritesProtocol.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation
import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func displayData(_ data: [FavoriteArticleCD])
}

protocol FavoritesModelProtocol {
    func fetchData() -> [FavoriteArticleCD]
}

protocol FavoritesPresenterProtocol: AnyObject {
    func loadData()
}

