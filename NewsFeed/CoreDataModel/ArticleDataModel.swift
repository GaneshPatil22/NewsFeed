//
//  ArticleDataModel.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/27/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import Foundation
import CoreData


class ResponseModel {
    required public init(from json: [String : AnyObject], with keyword: String = "") {}
    func fetchData(with keyword: String = "") {}
}


class ArticleDataModel: ResponseModel {
    
    var data: [Article] = []
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    required init(from json: [String : AnyObject], with keyword: String = "") {
        super.init(from: json)
        guard let articleJsonArray = json["articles"] as? [[String: AnyObject]] else {
            return
        }
        saveInCoreDataWith(array: articleJsonArray, with: keyword)
    }
    
    private func createPhotoEntityFrom(dictionary: [String: AnyObject], with keyword: String = "") {
        let article = Article(context: context)
        article.title = dictionary["title"] as? String
        article.articleDescription = dictionary["description"] as? String
        article.urlToImage = dictionary["urlToImage"] as? String
        article.keyword = keyword
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]], with keyword: String = "") {
        _ = array.map{self.createPhotoEntityFrom(dictionary: $0, with: keyword)}
        do {
            try context.save()
            fetchData(with: keyword)
        } catch let error {
            print(error)
        }
    }
    
    override func fetchData(with keyword: String = "") {
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        let sort = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            data = try context.fetch(fetchRequest)
            data = data.filter{
                $0.keyword?.lowercased() == keyword.lowercased()
            }
        } catch {
            print("Fetch failed")
        }
    }
}
