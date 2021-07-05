//
//  WebViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/04.
//

import UIKit
import RxSwift
import RxCocoa

class WebViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.autocorrectionType = .no
        bar.autocapitalizationType = .none
        return bar
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("다운순", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let sortPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        return button
    }()
    
    let loginStatusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.text = "로그인 중이 아닙니다."
        label.textAlignment = .center
        return label
    }()
    
    let wordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WebTableViewCell.self, forCellReuseIdentifier: WebTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        navigationItem.title = "다운받기"
        navigationController?.navigationBar.prefersLargeTitles = true
        configure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightOffset: CGFloat = 15
        searchBar.frame = CGRect(x: 0, y: navigationController!.navigationBar.frame.maxY, width: view.bounds.size.width, height: 50)
        sortButton.frame = CGRect(x: 10, y: searchBar.frame.maxY + heightOffset, width: view.bounds.size.width / 6, height: 30)
        loginStatusLabel.frame = CGRect(x: sortButton.frame.maxX + 10, y: searchBar.frame.maxY + heightOffset, width: view.bounds.size.width / 1.5, height: 30)
        loginButton.frame = CGRect(x: loginStatusLabel.bounds.maxX - loginStatusLabel.bounds.width/4, y: loginStatusLabel.bounds.origin.y, width: loginStatusLabel.bounds.width/4, height: 30)
        wordsTableView.frame = CGRect(x: 0, y: loginStatusLabel.frame.maxY + heightOffset, width: view.bounds.size.width, height: view.bounds.size.height - 80)
    }
    
    private func configure() {
        view.addSubview(searchBar)
        view.addSubview(sortButton)
        loginStatusLabel.addSubview(loginButton)
        view.addSubview(loginStatusLabel)
        view.addSubview(wordsTableView)
    }
    
    private func rxConfigure() {
        searchBar.rx.text
            .bind {
                print($0)
            }.disposed(by: disposeBag)
        
        Observable<String>.just("hi")
            .bind(to: wordsTableView.rx.items(cellIdentifier: WebTableViewCell.identifier, cellType: WebTableViewCell.self)) {indexPath, item, cell in
                //cell.titleLabel.text = String(item)
            }.disposed(by: disposeBag)
        
        Observable.of(["다운순", "좋아요순"])
            .bind(to: sortPickerView.rx.itemTitles) {
                return $1
            }.disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind { [weak self] in
                // 팝오버 컨트롤러를 공부하고 해야할듯
                
            }.disposed(by: disposeBag)
    }
}
