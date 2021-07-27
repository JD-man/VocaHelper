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
    private var disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchTextField.autocapitalizationType = .none
        bar.searchTextField.autocorrectionType = .no
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let noResultView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.text = "검색결과가 없습니다!"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGray4
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "저장한 단어찾기"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBarConfigure()
        constraintsConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func searchBarConfigure() {
        view.addSubview(noResultView)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        toolBar.barStyle = .default
        toolBar.items = [
            UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(didTapBarbutton))
        ]
        toolBar.sizeToFit()
        searchBar.searchTextField.inputAccessoryView = toolBar
    }
    
    private func constraintsConfigure() {
        //searchBar.frame = CGRect(x: 0, y: navigationController!.navigationBar.frame.maxY, width: view.bounds.size.width, height: 50)
//        tableView.frame = CGRect(x: 0, y: searchBar.frame.origin.y + searchBar.frame.size.height, width: view.bounds.size.width, height: view.bounds.size.height - searchBar.frame.size.height)
//        noResultView.frame = view.bounds
        
        searchBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: searchBar.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        noResultView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        noResultView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        noResultView.widthAnchor.constraint(equalTo: searchBar.widthAnchor).isActive = true
        noResultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func didTapBarbutton() {
        searchBar.searchTextField.endEditing(true)
    }
    
    private func rxConfigure() {
        // 서치바 -> 뷰모델
        // 뷰모델 -> 테이블뷰 바인드
        
        // 키보드를 넣을때 word가 한번 더 방출된다. 그러면서 테이블뷰가 사라지는 버그가 발생함.
        // 그래서 distinctUntilChanged()를 넣음. 연속으로 같은게 오면 무시하는 오퍼레이터라고함.
        searchBar.rx.text
            .distinctUntilChanged()
            .bind() { [weak self] in
                self?.viewModel.makeSearchResultSubject(word: $0!, tableView: self?.tableView, noResultView: self?.noResultView)
            }.disposed(by: disposeBag)
        
        viewModel.searchResultSubject
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier,
                                         cellType: SearchResultTableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = item.word + " : " + item.meaning
                cell.fileName = item.fileName
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
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
