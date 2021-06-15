//
//  SearchViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        searchBarConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func searchBarConfigure() {
        view.addSubview(tableView)
        navigationItem.titleView = searchBar
    }
    
    private func rxConfigure() {
        // 서치바 -> 뷰모델
        // 뷰모델 -> 테이블뷰 바인드
        
        searchBar.rx.text
            .bind() { [weak self] in
                self?.viewModel.makeSearchResultSubject(word: $0!)
            }.disposed(by: disposeBag)
        
        viewModel.searchResultSubject
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = item.word + " : " + item.meaning
            }.disposed(by: disposeBag)
    }
}
