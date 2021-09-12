//
//  NewsEntity+CoreDataProperties.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//
//

import Foundation
import CoreData


extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var contentDescription: String?
    @NSManaged public var imageURL: URL?

}

extension NewsEntity : Identifiable {

}
