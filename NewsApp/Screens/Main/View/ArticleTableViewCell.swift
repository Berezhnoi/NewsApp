//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 4
        return label
    }()
    
    let heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private var article: ArticleTableViewCellModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        articleImageView.image = nil
        article = nil
    }
    
    private func setupViews() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(heartButton)
        
        NSLayoutConstraint.activate([
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            articleImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        
        // Set minimum height constraint
        let minHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        minHeightConstraint.priority = .defaultHigh
        minHeightConstraint.isActive = true
    }
    
    func configure(with article: ArticleTableViewCellModel) {
        self.article = article
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        
        if let imageData = article.imageData {
            articleImageView.image = UIImage(data: imageData)
        } else if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            articleImageView.loadImage(url: url) { imageData in
                // Cache the image
                article.imageData = imageData
            }
        }
        
        updateHeartButton(isFavorite: article.isFavorite)
    }
    
    private func updateHeartButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        heartButton.setImage(image, for: .normal)
    }
    
    @objc private func heartButtonTapped() {
        guard let article = article else { return }
        article.isFavorite.toggle()
        updateHeartButton(isFavorite: article.isFavorite)
        
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
    }
}
