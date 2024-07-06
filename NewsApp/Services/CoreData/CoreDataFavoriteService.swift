//
//  CoreDataFavoriteService.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//

import CoreData

class CoreDataFavoriteService {
    static let shared = CoreDataFavoriteService()

    private init() {}

    func saveFavoriteArticle(article: CreateFavoriteArticleModel) {
        let context = CoreDataStack.shared.context
        let favoriteArticle = FavoriteArticleCD(context: context)

        favoriteArticle.id = UUID().uuidString
        favoriteArticle.title = article.title
        favoriteArticle.url = article.url
        favoriteArticle.descriptionText = article.description
        favoriteArticle.urlToImage = article.urlToImage

        CoreDataStack.shared.saveContext()
    }

    func fetchFavoriteArticles() -> [FavoriteArticleCD] {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<FavoriteArticleCD> = FavoriteArticleCD.fetchRequest()

        do {
            let favoriteArticles = try context.fetch(fetchRequest)
            return favoriteArticles
        } catch {
            print("Failed to fetch favorite articles: \(error)")
            return []
        }
    }

    func deleteFavoriteArticle(article: FavoriteArticleCD) {
        let context = CoreDataStack.shared.context
        context.delete(article)
        CoreDataStack.shared.saveContext()
    }
    
    func deleteFavoriteArticleById(id: String) {
        let fetchRequest: NSFetchRequest<FavoriteArticleCD> = FavoriteArticleCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let result = try CoreDataStack.shared.context.fetch(fetchRequest)
            if let favoriteArticle = result.first {
                deleteFavoriteArticle(article: favoriteArticle)
            }
        } catch {
            print("Failed to fetch article: \(error)")
        }
    }
    
    func deleteFavoriteArticleByTitle(title: String) {
        let fetchRequest: NSFetchRequest<FavoriteArticleCD> = FavoriteArticleCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let result = try CoreDataStack.shared.context.fetch(fetchRequest)
            if let favoriteArticle = result.first {
                deleteFavoriteArticle(article: favoriteArticle)
            }
        } catch {
            print("Failed to fetch article: \(error)")
        }
    }
}

