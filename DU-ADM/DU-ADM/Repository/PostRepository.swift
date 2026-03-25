//
//  PostRepository.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 25/03/26.
//

import RealmSwift

class PostRepository {
    
    func fetchPosts(completion: @escaping () -> Void) {
        APIService.shared.fetchPosts { _ in
            completion()
        }
    }
    
    func getPostsFromDB() -> [Post] {
        let realm = try! Realm()
        return Array(realm.objects(Post.self))
    }
}
