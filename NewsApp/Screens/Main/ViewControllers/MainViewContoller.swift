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
        presenter = MainPresenter(view: self, model: model)
        
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
    
    private func appendData(articles: [Article]) {
        let newArticles = articles.compactMap({
            ArticleTableViewCellModel(
                title: $0.title,
                description: $0.description ?? "-",
                url: $0.url,
                urlToImage: $0.urlToImage,
                imageData: nil
            )
        })
        mainView.articles.append(contentsOf: newArticles)
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
                imageData: nil
            )
        })
    }
}

extension MainViewController: MainViewDelegate {
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
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

extension MainViewController {
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
