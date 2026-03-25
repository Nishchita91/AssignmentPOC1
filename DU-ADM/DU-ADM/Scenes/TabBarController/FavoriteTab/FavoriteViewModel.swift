//
//  FavoriteViewModel.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import RealmSwift

class FavoriteViewModel {
    
    func loadFavorites() ->  [Post] {
        let realm = try! Realm()
        return Array(realm.objects(Post.self).filter("isFavorite == true"))
    }
    
    func updateFavorites(post: Post) {
        let realm = try! Realm()
        
        try? realm.write {
            post.isFavorite = false
        }
    }
}
