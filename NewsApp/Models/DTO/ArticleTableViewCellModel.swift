//
//  ArticleTableViewCellModel.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

class ArticleTableViewCellModel {
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    var imageData: Data?
    
    init(title: String, description: String, url: String, urlToImage: String?, imageData: Data? = nil) {
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.imageData = imageData
    }
}
