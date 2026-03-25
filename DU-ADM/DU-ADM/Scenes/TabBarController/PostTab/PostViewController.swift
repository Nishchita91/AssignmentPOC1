//
//  PostViewController.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupNetworkListener()
    }
    
    // MARK: - Setup UI
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavigationBar() {
        
        title = "Posts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }
    
    // MARK: - To Check Network Connectivity
    
    private func setupNetworkListener() {
        
        NetworkManager.shared.onStatusChange = { [weak self] isConnected in
            
            guard let self = self else { return }
            
            if isConnected {
                self.viewModel.loadPosts {
                    self.tableView.reloadData()
                }
            } else {
                self.viewModel.loadPostsFromDB()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func logoutTapped() {
        
        // Clear session
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - UITableViewDataSource

extension PostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell",
                                                       for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        showFavoriteAlert(for: post)
    }
    
    private func showFavoriteAlert(for post: Post) {
        
        let alert = UIAlertController(title: "Post",
                                      message: "To Favorites",
                                      preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            if !post.isFavorite {
                self.viewModel.updateFavorite(post: post, isFavorite: true)
            }
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            
            if post.isFavorite {
                self.viewModel.updateFavorite(post: post, isFavorite: false)
            }
        }
        
        if post.isFavorite {
            alert.addAction(removeAction)
        } else {
            alert.addAction(addAction)
        }
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0,
                                        height: 0)
        }
        
        present(alert, animated: true)
    }
}
