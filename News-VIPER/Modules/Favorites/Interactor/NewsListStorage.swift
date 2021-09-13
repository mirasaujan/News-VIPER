//
//  NewsListStorage.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 12.09.2021.
//

import UIKit
import CoreData

protocol NewsListStorageProtocol {
    func add(news: News)
    
    func fetch() -> [News]
}

class NewsListStorage: NewsListStorageProtocol {
    static let newsListChangedNotificationName = NSNotification.Name("NewsListStorage.NewsList.Changed")
    private let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
    }
    
    func add(news: News) {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return
        }
        
        if let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "NewsEntity",
                                                          into: context) as? NewsEntity {
            newsEntity.title = news.title
            newsEntity.contentDescription = news.description
            newsEntity.content = news.content
            
            appDelegate?.saveContext()
            
            notificationCenter.post(name: Self.newsListChangedNotificationName,
                                    object: self,
                                    userInfo: ["newsList": fetch()])
        }
    }
    
    func fetch() -> [News] {
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return []
        }
        
        do {
            let newsEntityRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
            let result = try context.fetch(newsEntityRequest)
            
            return result.map { News(title: $0.title ?? "",
                                     description: $0.contentDescription ?? "",
                                     content: $0.content ?? "",
                                     urlToImage: $0.imageURL ?? URL(fileURLWithPath: ""))}
        } catch {
            return []
        }
    }
}
