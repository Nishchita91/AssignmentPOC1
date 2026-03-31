//
//  PostViewController.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let viewModel = PostViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindTableView()
        setupNavigationBar()
        bindSelection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindLoader()
        setupNetworkListener()
    }
    
    // MARK: - Actions
    
    @objc private func logoutTapped() {
        
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

// MARK: - Setup UI

extension PostViewController {
    
    private func setupUI() {
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PostCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func setupNavigationBar() {
        title = "Posts"
        navigationItem.rightBarButtonItem = UIBarButtonItem( title: "Logout",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(logoutTapped) )
    }
}
 
// MARK: - Setup ActivityIndicator

extension PostViewController {
    
    private func bindLoader() {
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] loading in
                
                if loading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNetworkListener() {
        
        NetworkManager.shared.onStatusChange = { [weak self] isConnected in
            
            guard let self = self else { return }
            
            if isConnected {
                self.viewModel.loadPosts()
            } else {
                self.viewModel.loadPostsFromDB()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension PostViewController {
    
    private func bindTableView() {
        
        viewModel.postsRelay
            .bind(to: tableView.rx.items(cellIdentifier: "PostCell",
                                         cellType: PostTableViewCell.self)) { row, post, cell in
                cell.configure(with: post)
                cell.selectionStyle = .none
            }
                                         .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension PostViewController {
    
    private func bindSelection() {
        
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                self?.showFavoriteAlert(for: post)
            })
            .disposed(by: disposeBag)
    }
    
    private func showFavoriteAlert(for post: Post) {
        
        let alert = UIAlertController(title: "Post",
                                      message: "To Favorites",
                                      preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.viewModel.updateFavorite(post: post, isFavorite: true)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            self.viewModel.updateFavorite(post: post, isFavorite: false)
        }
        
        if post.isFavorite {
            alert.addAction(removeAction)
        } else {
            alert.addAction(addAction)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}
