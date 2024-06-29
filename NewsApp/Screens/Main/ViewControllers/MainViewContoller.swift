//
//  MainViewContoller.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, MainViewProtocol, MainViewDelegate {
    private var mainView: MainView!
    private var presenter: MainPresenterProtocol!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func displayData(_ articles: [Article]) {
        mainView.articles = articles.compactMap({
            ArticleTableViewCellModel(
                title: $0.title,
                description: $0.description ?? "-",
                url: $0.url,
                urlToImage: $0.urlToImage,
                imageData: nil
            )
        })
    }
    
    func navigateToArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
