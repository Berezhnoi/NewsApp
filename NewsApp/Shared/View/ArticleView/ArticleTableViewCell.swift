//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"
    
    private let placeholderImage = UIImage(named: "placeholder_image")
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
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
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private var article: ArticleTableViewCellModel?
    private var heartButtonAction: ((ArticleTableViewCellModel) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
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
        let cellWrapperView = UIView()
        cellWrapperView.translatesAutoresizingMaskIntoConstraints = false
        cellWrapperView.backgroundColor = .secondarySystemBackground
        cellWrapperView.layer.cornerRadius = 8
        cellWrapperView.layer.masksToBounds = true
        contentView.addSubview(cellWrapperView)

        cellWrapperView.addSubview(articleImageView)
        cellWrapperView.addSubview(titleLabel)
        cellWrapperView.addSubview(descriptionLabel)
        cellWrapperView.addSubview(heartButton)
        cellWrapperView.addSubview(shareButton)

        NSLayoutConstraint.activate([
            cellWrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cellWrapperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellWrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cellWrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            articleImageView.leadingAnchor.constraint(equalTo: cellWrapperView.leadingAnchor, constant: 10),
            articleImageView.topAnchor.constraint(equalTo: cellWrapperView.topAnchor, constant: 10),
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            articleImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: cellWrapperView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: cellWrapperView.topAnchor, constant: 10),

            descriptionLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: cellWrapperView.trailingAnchor, constant: -15),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: cellWrapperView.bottomAnchor, constant: -25),

            heartButton.trailingAnchor.constraint(equalTo: cellWrapperView.trailingAnchor, constant: -8),
            heartButton.bottomAnchor.constraint(equalTo: cellWrapperView.bottomAnchor, constant: -2),
            
            shareButton.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -8),
            shareButton.bottomAnchor.constraint(equalTo: cellWrapperView.bottomAnchor, constant: -2),
        ])

        // Set minimum height constraint
        let minHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110)
        minHeightConstraint.priority = .defaultHigh
        minHeightConstraint.isActive = true
    }

    
    func configure(
        with article: ArticleTableViewCellModel,
        heartButtonAction: ((ArticleTableViewCellModel) -> Void)? = nil
    ) {
        self.article = article
        self.heartButtonAction = heartButtonAction
        
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        
        // Set placeholder image initially
        articleImageView.image = placeholderImage
        
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
        heartButtonAction?(article)
    }
    
    @objc private func shareButtonTapped() {
        guard let article = article else { return }
        let content = "\(article.title)\n\n\(article.url)"
        
        let activityViewController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        
        // Find the current view controller to present the activity view controller from
        var viewController: UIViewController?
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let nextResponder = responder as? UIViewController {
                viewController = nextResponder
                break
            }
        }
        
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}
