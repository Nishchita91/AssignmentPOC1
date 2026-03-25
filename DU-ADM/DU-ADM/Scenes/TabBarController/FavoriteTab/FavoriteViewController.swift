//
//  FavoriteViewController.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites: [Post] = []
    
    private let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
    }
    
    // MARK: - Setup UI
    
    func setupTableView() {
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FavouriteCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func loadFavorites() {
        favorites = viewModel.loadFavorites()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell",
                                                       for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let post = favorites[indexPath.row]
        cell.configure(with: post)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let remove = UIContextualAction(style: .destructive, title: "Remove") { _, _, completion in
            
            let post = self.favorites[indexPath.row]
            self.viewModel.updateFavorites(post: post)
            
            self.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [remove])
    }
}
