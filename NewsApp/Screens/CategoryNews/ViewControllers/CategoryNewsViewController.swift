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
    
    private let dropdownMenuView: DropdownMenuView = DropdownMenuView.generateCountriesDropdownMenu()
    
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
        model.fetchFavoriteArticles()
        presenter = CategoryNewsPresenter(category: category, view: self, model: model)
        
        loadInitialData()
        
        // Setup search controller
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        // Add observers for notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdated), name: .articlesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCountryChanged), name: .countryChanged, object: nil)
        
        setupDropdownMenu()
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

private extension CategoryNewsViewController {
    private func loadInitialData() {
        searchController.searchBar.text = nil
        pagination.reset()
        presenter.loadData(countryCode: UserDefaultsCountryService.getCountryCode())
    }
    
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
        categoryNewsView.articles.append(contentsOf: newArticles)
    }

    private func setupDropdownMenu() {
         let menuButton = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.down.fill"), style: .plain, target: self, action: #selector(showDropdownMenu))
         navigationItem.rightBarButtonItem = menuButton

         dropdownMenuView.delegate = self
     }

     @objc private func showDropdownMenu() {
         dropdownMenuView.showDropdown(in: view)
     }
    
     @objc private func handleFavoritesUpdated() {
        presenter.fetchFavoriteArticles()
        loadInitialData()
     }
    
     @objc private func handleCountryChanged() {
         loadInitialData()
     }
}

extension CategoryNewsViewController: ArticleViewDelegate {
    func didPullToRefresh() {
        loadInitialData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.categoryNewsView.endRefreshing()
        }
    }
    
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
        NotificationCenter.default.post(name: .categoryArticlesUpdated, object: nil)
    }
    
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func didScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight - 100) && !pagination.isLoading && categoryNewsView.articles.count < pagination.totalResults {
            
            pagination.isLoading = true
            pagination.nextPage()
            
            // TODO improve logic not to make request in controller
            TopHeadlinesService.getTopHeadlines(
                for: UserDefaultsCountryService.getCountryCode(),
                category: category,
                page: pagination.currentPage) { [weak self] result in
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

extension CategoryNewsViewController: DropdownMenuDelegate {
    func didSelectOption(_ option: String?) {
        guard let selectedCountryCode = option else {
            return
        }
        UserDefaultsCountryService.saveCountryCode(selectedCountryCode)
    }
}

extension CategoryNewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadInitialData()
            return
        }
        
        TopHeadlinesService.getTopHeadlines(
            for: UserDefaultsCountryService.getCountryCode(),
            page: pagination.currentPage,
            query: searchText
        ) { [weak self] result in
            switch result {
            case .success(let data):
                self?.displayData(data)
            case .failure(let error):
                print("Error fetching headlines: \(error)")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadInitialData()
    }
}
