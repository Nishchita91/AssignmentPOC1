//
//  FavoriteViewController.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
}

// MARK: - Setup UI

extension FavoriteViewController {
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FavouriteCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteViewController {
    
    private func bindTableView() {
        
        viewModel.favoritesRelay
            .bind(to: tableView.rx.items(cellIdentifier: "FavouriteCell",
                                         cellType: FavoriteTableViewCell.self)) { row, post, cell in
                cell.configure(with: post)
                cell.selectionStyle = .none
            }
                                         .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let remove = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
            
            self?.viewModel.removeFromFavorites(at: indexPath.row)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [remove])
    }
}
