//
//  FavoriteArticleCD+CoreDataProperties.swift
//  NewsApp
//
//  Created by rendi on 06.07.2024.
//
//

import Foundation
import CoreData


extension FavoriteArticleCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteArticleCD> {
        return NSFetchRequest<FavoriteArticleCD>(entityName: "FavoriteArticleCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension FavoriteArticleCD : Identifiable {

}
