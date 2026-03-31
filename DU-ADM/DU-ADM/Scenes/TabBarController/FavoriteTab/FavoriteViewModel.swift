//
//  FavoriteViewModel.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class FavoriteViewModel {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Output
    let favoritesRelay = BehaviorRelay<[Post]>(value: [])
    
    // MARK: - Load Data
    
    func loadFavorites() {
        let realm = try! Realm()
        let results = realm.objects(Post.self).filter("isFavorite == true")
        favoritesRelay.accept(Array(results))
    }
    
    // MARK: - Remove Favorite
    
    func removeFromFavorites(at index: Int) {
        
        let realm = try! Realm()
        var current = favoritesRelay.value
        
        let post = current[index]
        
        try? realm.write {
            post.isFavorite = false
        }
        
        current.remove(at: index)
        favoritesRelay.accept(current)
    }
}
