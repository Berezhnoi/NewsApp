//
//  ArticleViewProtocols.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import UIKit

protocol ArticleViewDelegate: AnyObject {
    func navigateToArticle(url: URL)
    func didScroll(_ scrollView: UIScrollView)
    func onFavoritePress(article: ArticleTableViewCellModel)
}
