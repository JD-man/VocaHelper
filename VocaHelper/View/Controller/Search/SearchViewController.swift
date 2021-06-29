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
        tableView.isHidden = true
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchTextField.autocapitalizationType = .none
        bar.searchTextField.autocorrectionType = .no        
        return bar
    }()
    
    private let noResultView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.text = "검색결과가 없습니다!"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGray4
        label.isHidden = false
        return label
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
        noResultView.frame = view.bounds
    }
    
    private func searchBarConfigure() {
        view.addSubview(tableView)
        navigationItem.titleView = searchBar
        view.addSubview(noResultView)
    }
    
    private func rxConfigure() {
        // 서치바 -> 뷰모델
        // 뷰모델 -> 테이블뷰 바인드
        
        searchBar.rx.text
            .bind() { [weak self] in
                self?.viewModel.makeSearchResultSubject(word: $0!, tableView: self?.tableView, noResultView: self?.noResultView)
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
