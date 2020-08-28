//
//  Enum.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/26/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import Foundation

let APIKEY = "7ece0a8055e14ae09759cfa6a53d4c15"

enum APIPath : CustomStringConvertible {
    case FetchNews(String)
    
    var description : String {
        switch self {
        case .FetchNews(let keyword): return "https://newsapi.org/v2/everything?q=\(keyword)&apiKey=\(APIKEY)"
        }
    }
}

enum Messages: String {
    case Fail
    case Ok
}

enum CellIdentifier: String {
    case ArticleTableViewCell
}
