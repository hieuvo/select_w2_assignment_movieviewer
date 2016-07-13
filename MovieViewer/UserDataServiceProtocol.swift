//
//  UserDataServiceProtocol.swift
//  MovieViewer
//
//  Created by hvmark on 7/11/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

protocol UserDataServiceProtocol {
    static func userFavoriteMovie(username: String, movieID: Int)
    static func getUserFavorites(username: String, complete: ([Int]) -> Void )
}