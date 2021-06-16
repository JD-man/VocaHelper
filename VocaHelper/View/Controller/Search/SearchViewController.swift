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
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
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
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier,
                                         cellType: SearchResultTableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = item.word + " : " + item.meaning
                cell.fileName = item.fileName
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind() { [weak self] in
                guard let cell = self?.tableView.cellForRow(at: $0) as? SearchResultTableViewCell,
                      let strongSelf = self else {
                    return
                }
                self?.tabBarController?.tabBar.isHidden.toggle()
                self?.viewModel.didTapResultCell(fileName: cell.fileName, view: strongSelf)
            }.disposed(by: disposeBag)
    }
}
