//
//  CategoriesView.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

// CategoriesView.swift

import UIKit

class CategoriesView: UIView {
    weak var delegate: CategoriesViewDelegate?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var topInset: CGFloat = 0 {
        didSet {
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = frame.width / 2
                let itemHeight = (frame.height / 2) - topInset
                flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.sectionInset = .zero
            
            let itemWidth = frame.width / 2
            let itemHeight = (frame.height / 2) - topInset
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension CategoriesView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfCategories() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        if let category = delegate?.category(at: indexPath.row) {
            let textColor: UIColor = category.elementsEqual("health") || category.elementsEqual("science") ? .black : .white
            cell.configure(with: category, textColor: textColor)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCategory(at: indexPath.row)
    }
}
