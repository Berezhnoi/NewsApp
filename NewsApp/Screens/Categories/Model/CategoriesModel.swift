//
//  CategoriesModel.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import Foundation

class CategoriesModel: CategoriesModelProtocol {
    private let categories = ["business", "entertainment", "health", "science", "sports", "technology"]
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func category(at index: Int) -> String {
        return categories[index]
    }
}
