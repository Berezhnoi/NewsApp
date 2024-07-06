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
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    func didScroll(_ scrollView: UIScrollView) {}
}

extension FavoritesViewController: FavoritesViewProtocol {
    func displayData(_ data: TopHeadlinesResponse) {
        favoritesView.articles = data.articles.compactMap({
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

extension FavoritesViewController: UISearchBarDelegate {
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
