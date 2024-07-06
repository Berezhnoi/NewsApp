//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import UIKit
import SafariServices

class FavoritesViewController: UIViewController {
    private var favoritesView: FavoritesView!
    private var presenter: FavoritesPresenterProtocol!
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Favorites"
        
        favoritesView = FavoritesView(frame: view.bounds)
        favoritesView.setMainViewDelegate(mainViewDelegate: self)
        view.addSubview(favoritesView)
        
        let model = FavoritesModel()
        presenter = FavoritesPresenter(view: self, model: model)
        
        presenter.loadData()
        
        // Setup search controller
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension FavoritesViewController: MainViewDelegate {
    func onFavoritePress(article: ArticleTableViewCellModel) {
        guard !article.isFavorite else {
            return
        }
        
        // Remove the article from the favoritesView.articles
        favoritesView.articles = favoritesView.articles.filter { $0.title != article.title }
        
        // Delete the article from Core Data
        CoreDataFavoriteService.shared.deleteFavoriteArticleByTitle(title: article.title)
    }
    
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func didScroll(_ scrollView: UIScrollView) {}
}

extension FavoritesViewController: FavoritesViewProtocol {
    func displayData(_ data: [FavoriteArticleCD]) {
        favoritesView.articles = data.compactMap({
            ArticleTableViewCellModel(
                title: $0.title ?? "",
                description: $0.descriptionText ?? "",
                url: $0.url ?? "",
                urlToImage: $0.urlToImage,
                imageData: nil,
                isFavorite: true
            )
        })
    }
}

extension FavoritesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            presenter.loadData()
            return
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.loadData()
    }
}
