//
//  CategoriesProtocols.swift
//  NewsApp
//
//  Created by rendi on 07.07.2024.
//

import Foundation

protocol CategoriesViewProtocol: AnyObject {
    func displayCategories(_ categories: [String])
}

protocol CategoriesModelProtocol: AnyObject {
    func numberOfCategories() -> Int
    func category(at index: Int) -> String
}

protocol CategoriesViewDelegate: AnyObject {
    func numberOfCategories() -> Int
    func category(at index: Int) -> String
    func didSelectCategory(at index: Int)
}
