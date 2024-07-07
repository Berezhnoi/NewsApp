//
//  CategoryNewsViewController.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import UIKit
import SafariServices

class CategoryNewsViewController: UIViewController {
    private let category: String
    private var categoryNewsView: ArticleView!
    private var presenter: CategoryNewsPresenterProtocol!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var pagination = Pagination()
    
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = category.capitalized
        
        categoryNewsView = ArticleView(frame: view.bounds)
        categoryNewsView.delegate = self
        view.addSubview(categoryNewsView)
        
        let model = CategoryNewsModel()
        presenter = CategoryNewsPresenter(category: category, view: self, model: model)
        
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

extension CategoryNewsViewController: ArticleViewDelegate {
    func onFavoritePress(article: ArticleTableViewCellModel) {
        guard !article.isFavorite else {
            return
        }
    }
    
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func didScroll(_ scrollView: UIScrollView) {}
}

extension CategoryNewsViewController: CategoryNewsViewProtocol {
    func displayData(_ data: TopHeadlinesResponse) {
        pagination.totalResults = data.totalResults
        categoryNewsView.articles = data.articles.compactMap({
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

extension CategoryNewsViewController: UISearchBarDelegate {
    
}
