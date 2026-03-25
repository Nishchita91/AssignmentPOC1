//
//  PostTableViewCell.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        descriptionLabel.text = post.body
    }
    
}
