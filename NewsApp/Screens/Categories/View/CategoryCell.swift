//
//  CategoryCell.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // Ensure the image does not overflow
        return imageView
    }()
    
    let titleLabel: UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.textAlignment = .center
          label.font = UIFont.boldSystemFont(ofSize: 16)
          label.numberOfLines = 0
          label.textColor = .white
          label.layer.shadowColor = UIColor.black.cgColor
          label.layer.shadowOpacity = 0.7
          label.layer.shadowOffset = CGSize(width: 1, height: 1)
          label.layer.shadowRadius = 2
          return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with categoryName: String, textColor: UIColor) {
        imageView.image = UIImage(named: categoryName.lowercased())
        titleLabel.text = categoryName.capitalized
        titleLabel.textColor = textColor
    }
}
