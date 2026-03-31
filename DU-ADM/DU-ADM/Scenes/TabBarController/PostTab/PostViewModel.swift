//
//  PostViewModel.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class PostViewModel {
    
    private let repository = PostRepository()
    private let disposeBag = DisposeBag()
    
    // MARK: - Output
    let postsRelay = BehaviorRelay<[Post]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Load Posts (API)
    
    func loadPosts() {
        
        isLoading.accept(true)
        
        repository.fetchPosts {
            
            let data = self.repository.getPostsFromDB()
            self.postsRelay.accept(data)
            self.isLoading.accept(false)
        }
    }
    
    // MARK: - Load from DB
    
    func loadPostsFromDB() {
        
        let realm = try! Realm()
        let results = realm.objects(Post.self)
        
        postsRelay.accept(Array(results))
    }
    
    // MARK: - Update Favorite
    
    func updateFavorite(post: Post, isFavorite: Bool) {
        
        let realm = try! Realm()
        
        try? realm.write {
            post.isFavorite = isFavorite
        }
        
        // Refresh UI
        loadPostsFromDB()
    }
}

