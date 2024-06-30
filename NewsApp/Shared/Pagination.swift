//
//  Pagination.swift
//  NewsApp
//
//  Created by rendi on 30.06.2024.
//

import Foundation

struct Pagination {
    var currentPage: Int = 1
    var isLoading: Bool = false
    var totalResults: Int = 0
    
    mutating func reset() {
        currentPage = 1
        isLoading = false
        totalResults = 0
    }
    
    mutating func nextPage() {
        currentPage += 1
    }
}
