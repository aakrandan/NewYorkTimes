//
//  File.swift
//  NewYorkTimes
//
//  Created by Monitor Team on 09/06/22.
//

import Foundation

struct MostViewedNews: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let url: String
    let media: [MetaData]
    let title: String
    let abstract: String
    let byline: String
    let pubDate: String
    
    private enum CodingKeys: String, CodingKey {
        case url = "url"
        case media = "media"
        case title = "title"
        case abstract = "abstract"
        case byline = "byline"
        case pubDate = "published_date"
    }
}

struct MetaData: Decodable {
    let mediaMetaData : [ImageName]
    
    private enum CodingKeys: String, CodingKey {
        case mediaMetaData = "media-metadata"
    }
}

struct ImageName: Decodable {
    let url: String
}
