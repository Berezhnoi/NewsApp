//
//  TopHeadlines.swift
//  NewsApp
//
//  Created by rendi on 29.06.2024.
//

import Foundation

struct TopHeadlinesResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Decodable {
    let name: String
}
