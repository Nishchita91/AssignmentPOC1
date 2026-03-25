//
//  Post.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 25/03/26.
//

import RealmSwift

struct PostEntity: Codable, Sendable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class Post: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userId: Int
    @Persisted var title: String = ""
    @Persisted var body: String = ""
    @Persisted var isFavorite: Bool = false
}

extension Post {
    convenience init(post: PostEntity) {
        self.init()
        self.id = post.id
        self.userId = post.userId
        self.title = post.title
        self.body = post.body
    }
}
