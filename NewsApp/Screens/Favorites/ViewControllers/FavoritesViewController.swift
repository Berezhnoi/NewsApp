//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import UIKit
import SafariServices

class FavoritesViewController: UIViewController {
    private var favoritesView: ArticleView!
    private var presenter: FavoritesPresenterProtocol!
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        
        favoritesView = ArticleView(frame: view.bounds)
        favoritesView.delegate = self
        view.addSubview(favoritesView)
        
        let model = FavoritesModel()
        presenter = FavoritesPresenter(view: self, model: model)
        
        loadInitialData()
        
        // Add an observer for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleArticlesUpdated), name: .articlesUpdated, object: nil)
        
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

private extension FavoritesViewController {
    private func loadInitialData() {
        searchController.searchBar.text = nil
        presenter.loadData()
    }
    
    @objc private func handleArticlesUpdated() {
        loadInitialData()
    }
}

extension FavoritesViewController: ArticleViewDelegate {
    func didPullToRefresh() {
        loadInitialData()
        favoritesView.endRefreshing()
    }
    
    func onFavoritePress(article: ArticleTableViewCellModel) {
        guard !article.isFavorite else {
            return
        }
        
        // Remove the article from the favoritesView.articles
        favoritesView.articles = favoritesView.articles.filter { $0.title != article.title }
        
        // Delete the article from Core Data
        CoreDataFavoriteService.shared.deleteFavoriteArticleByTitle(title: article.title)
        
        // Post notification
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
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
         guard let searchText = searchBar.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
             return
         }
         let favorites = presenter.searchFavorites(with: searchText)
         displayData(favorites)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadInitialData()
    }
}
