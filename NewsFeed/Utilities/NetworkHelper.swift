//
//  NetworkHelper.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/26/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case clientError
    case serverError
    case noData
    case dataDecodingError
}


class NetworkHelper<T: ResponseModel> {
    static func APICall(_ apiUrl : String,
                        searchText: String = "",
                        method: String = "GET",
                        resultHandler : @escaping((Result<T, RequestError>) -> Void)) {
        
        ActivityIndicatorHelper.sharedInstance.startLoader()
        let url = URL(string: apiUrl)!

        let search = SearchKeyword()
        
        let isAlreadySearched = search.isKeywordAlreadySearched(keywordToSearch: searchText)
        if isAlreadySearched {
            ActivityIndicatorHelper.sharedInstance.stopLoader()
            let model = T(from: [String : AnyObject]())
            model.fetchData(with: searchText)
            resultHandler(.success(model))
            return
        } else {
            search.addSearchTextToDB(search: searchText)
        }

        let urlTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                resultHandler(.failure(.clientError))
                ActivityIndicatorHelper.sharedInstance.stopLoader()
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                resultHandler(.failure(.serverError))
                ActivityIndicatorHelper.sharedInstance.stopLoader()
                return
            }
            
            guard let data = data else {
                resultHandler(.failure(.noData))
                ActivityIndicatorHelper.sharedInstance.stopLoader()
                return
            }
            ActivityIndicatorHelper.sharedInstance.stopLoader()
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        let model = T(from: json, with: searchText)
                        resultHandler(.success(model))
                    }
                }
            } catch {
                resultHandler(.failure(.noData))
            }
        }
        urlTask.resume()
    }
}

