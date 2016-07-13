//
//  Firebase.swift
//  MovieViewer
//
//  Created by hvmark on 7/11/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Firebase

//class FirebaseUserDataService: UserDataServiceProtocol {
class FirebaseUserDataService {

    static func userFavoriteMovie(username: String, movieID: Int) {
        getUserFavorites("hieuvo") { (userFavorites) in
            guard !userFavorites.contains(movieID) else { return }
            
            var newFavorites = userFavorites
            newFavorites.append(movieID)
            
            let firebaseRef = FIRDatabase.database().reference()
            firebaseRef.child("users").child(username).updateChildValues(["favorites": newFavorites])
            
            print ("----")
            print ("finish updating favorites for \(username)")
        }
    }
    
    static func getUserFavorites(username: String, complete: ([Int]) -> Void ) {
        let firebaseRef = FIRDatabase.database().reference()
        
        firebaseRef.child("users").observeSingleEventOfType(.Value, withBlock: { snapshot in
            var userFavorites: [Int] = []
            var tmpSnapshot = snapshot
            if tmpSnapshot.hasChild(username) {
                tmpSnapshot = snapshot.childSnapshotForPath(username)
                if tmpSnapshot.hasChild("favorites") {
                    for movieId in (tmpSnapshot.childSnapshotForPath("favorites").value! as! Array<AnyObject>) {
                        if let movieId = movieId as? Int {
                            userFavorites.append(movieId)
                        }
                    }
                }
            }
          
            print ("----")
            print ("finish loading user's favorites")
            print (userFavorites)
            complete(userFavorites)
        })
    }
    
}
