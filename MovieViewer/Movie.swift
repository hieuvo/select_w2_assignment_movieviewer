//
//  Movie.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

class Movie {
    var id: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var isFavorited = false
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int ?? 0
        title = dictionary["title"] as? String ?? ""
        overview = dictionary["overview"] as? String ?? ""
        posterPath = dictionary["poster_path"] as? String ?? nil
        releaseDate = dictionary["release_date"] as? String ?? ""
    }
}
