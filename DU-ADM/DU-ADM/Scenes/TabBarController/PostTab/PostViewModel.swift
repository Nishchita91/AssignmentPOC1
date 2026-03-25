//
//  PostViewModel.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import RealmSwift

class PostViewModel {
    
    private let repository = PostRepository()
    
    var posts: [Post] = []
    
    func loadPosts(completion: @escaping () -> Void) {
        
        repository.fetchPosts {
            self.posts = self.repository.getPostsFromDB()
            completion()
        }
    }
    
    func loadPostsFromDB() {
        
        let realm = try! Realm()
        let results = realm.objects(Post.self)
        
        self.posts = Array(results)
    }
    
    func updateFavorite(post: Post, isFavorite: Bool) {
        
        let realm = try! Realm()
        
        try? realm.write {
            post.isFavorite = isFavorite
        }
    }
}

