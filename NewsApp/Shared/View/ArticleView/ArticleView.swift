//
//  ArticleView.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import UIKit

class ArticleView: UIView {
    weak var delegate: ArticleViewDelegate?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.separatorStyle = .none // Remove separator lines
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    var articles: [ArticleTableViewCellModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Add refresh control to the table view
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        delegate?.didPullToRefresh()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension ArticleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell
        else {
            fatalError()
        }
        cell.configure(with: articles[indexPath.row]) { [weak self] updatedArticle in
            self?.delegate?.onFavoritePress(article: updatedArticle)
        }
        return cell
    }
}

extension ArticleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let articleUrl = URL(string: article.url) else {
            return
        }
        
        delegate?.navigateToArticle(url: articleUrl)
    }
}

extension ArticleView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(scrollView)
    }
}

