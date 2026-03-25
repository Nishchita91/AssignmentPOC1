//
//  APIService.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 25/03/26.
//

import Alamofire
import RealmSwift

class APIService {
    
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        
        let url = "\(baseURL)/posts"
        
        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                
                switch response.result {
                    
                case .success(let data):
                    
                    guard let postData = try? JSONDecoder().decode([PostEntity].self, from: data) else {
                        completion([])
                        return
                    }
                    
                    let realm = try! Realm()
                    
                    let posts = postData.map { data -> Post in
                        
                        // Check if already exists in DB
                        if let existingPost = realm.object(ofType: Post.self, forPrimaryKey: data.id) {
                            
                            // Update existing
                            try? realm.write {
                                existingPost.title = data.title
                                existingPost.body = data.body
                                existingPost.userId = data.userId
                            }
                            
                            return existingPost
                        } else {
                            // Create new
                            let post = Post()
                            post.id = data.id
                            post.userId = data.userId
                            post.title = data.title
                            post.body = data.body
                            return post
                        }
                    }
                    self.saveToRealm(posts: posts)
                    completion(posts)
                    
                case .failure(let error):
                    print("Error: \(error)")
                    completion([])
                }
            }
    }
}

extension APIService {
    
    private func saveToRealm(posts: [Post]) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(posts, update: .modified)
            }
            
        } catch {
            print("Realm save error: \(error)")
        }
    }
    
    func fetchPostsFromDB() -> [Post] {
        let realm = try! Realm()
        return Array(realm.objects(Post.self))
    }
}
