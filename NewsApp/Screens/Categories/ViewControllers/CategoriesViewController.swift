//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import UIKit

class CategoriesViewController: UIViewController {
    private var categoriesView: CategoriesView!
    private let model: CategoriesModelProtocol = CategoriesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = .systemBackground
        setupCategoriesView()
    }
}

private extension CategoriesViewController {
    private func setupCategoriesView() {
        categoriesView = CategoriesView(frame: view.bounds)
        categoriesView.delegate = self
        view.addSubview(categoriesView)
        
        categoriesView.topInset = calculateTopInset()
        
        // Set delegate to self or appropriate delegate handler
        categoriesView.delegate = self
    }
    
    private func calculateTopInset() -> CGFloat {
        // Calculate topInset for CategoriesView
        var topInset: CGFloat = 0
         
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            topInset = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            topInset = UIApplication.shared.statusBarFrame.height
        }
         
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            topInset += navBarHeight
        }
        
        return topInset
    }
    
    private func navigateToCategoryNews(for category: String) {
        let categoryNewsVC = CategoryNewsViewController(category: category)
        navigationController?.pushViewController(categoryNewsVC, animated: true)
    }
}

extension CategoriesViewController: CategoriesViewDelegate {
    func numberOfCategories() -> Int {
        return model.numberOfCategories()
    }
    
    func category(at index: Int) -> String {
        return model.category(at: index)
    }
    
    func didSelectCategory(at index: Int) {
        let selectedCategory = model.category(at: index)
        // Navigate to category news view
        navigateToCategoryNews(for: selectedCategory)
    }
}
