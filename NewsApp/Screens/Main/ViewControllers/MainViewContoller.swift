//
//  MainViewContoller.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    private var mainView: MainView!
    private var presenter: MainPresenterProtocol!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var pagination = Pagination()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .white
        
        mainView = MainView(frame: view.bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        let model = MainModel()
        model.fetchFavoriteArticles()
        presenter = MainPresenter(view: self, model: model)
        
        presenter.loadData()
        
        // Add an observer for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated), name: .favoritesUpdated, object: nil)
        
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

private extension MainViewController {
    private func appendData(articles: [Article]) {
        let newArticles = articles.compactMap({
            ArticleTableViewCellModel(
                title: $0.title,
                description: $0.description ?? "-",
                url: $0.url,
                urlToImage: $0.urlToImage,
                imageData: nil,
                isFavorite: self.presenter.isFavoriteArticle(title: $0.title)
            )
        })
        mainView.articles.append(contentsOf: newArticles)
    }
    
    @objc private func handleFavoritesUpdated() {
        presenter.fetchFavoriteArticles()
        presenter.loadData()
    }
}

extension MainViewController: MainViewProtocol {
    func displayData(_ data: TopHeadlinesResponse) {
        pagination.totalResults = data.totalResults
        mainView.articles = data.articles.compactMap({
            ArticleTableViewCellModel(
                title: $0.title,
                description: $0.description ?? "-",
                url: $0.url,
                urlToImage: $0.urlToImage,
                imageData: nil,
                isFavorite: self.presenter.isFavoriteArticle(title: $0.title)
            )
        })
    }
}

extension MainViewController: MainViewDelegate {
    func onFavoritePress(article: ArticleTableViewCellModel) {
        if article.isFavorite {
            let payload: CreateFavoriteArticleModel = CreateFavoriteArticleModel(
                title: article.title,
                description: article.description,
                url: article.url,
                urlToImage: article.urlToImage
            )
            CoreDataFavoriteService.shared.saveFavoriteArticle(article: payload)
        } else {
            CoreDataFavoriteService.shared.deleteFavoriteArticleByTitle(title: article.title)
        }
        
        // Post notification
        NotificationCenter.default.post(name: .articlesUpdated, object: nil)
    }
    
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight - 100) && !pagination.isLoading && mainView.articles.count < pagination.totalResults {
            
            guard let searchText = searchController.searchBar.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            pagination.isLoading = true
            pagination.nextPage()
            
            SearchArticleService.getArticleByQuery(with: searchText, page: pagination.currentPage) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.pagination.totalResults = data.totalResults
                    self?.appendData(articles: data.articles)
                case .failure(let error):
                    print("Error fetching headlines: \(error)")
                }
                DispatchQueue.main.async {
                    self?.pagination.isLoading = false
                }
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            presenter.loadData()
            return
        }
        
        SearchArticleService.getArticleByQuery(with: text, page: 1){ [weak self] result in
            switch result {
            case .success(let data):
                self?.displayData(data)
            case .failure(let error):
                print("Error fetching headlines: \(error)")
            }
            DispatchQueue.main.async {
                self?.searchController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.loadData()
    }
}
