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
    let sortTitle = ["다운순", "좋아요순"]
    
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
    
    let loginStatusTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.text = "로그인 중이 아닙니다."
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.isEnabled = false
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let wordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WebTableViewCell.self, forCellReuseIdentifier: WebTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 250
        tableView.allowsSelection = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "다운받기"
        navigationController?.navigationBar.prefersLargeTitles = true
        configure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightOffset: CGFloat = 15
        searchBar.frame = CGRect(x: 0, y: navigationController!.navigationBar.frame.maxY, width: view.bounds.size.width, height: 50)
        sortButton.frame = CGRect(x: 20, y: searchBar.frame.maxY + heightOffset, width: view.bounds.size.width / 6, height: 30)
        loginStatusTextField.frame = CGRect(x: view.bounds.maxX - view.bounds.size.width / 1.5 - 10, y: searchBar.frame.maxY + heightOffset, width: view.bounds.size.width / 1.5, height: 30)
        loginButton.frame = CGRect(x: loginStatusTextField.bounds.maxX - loginStatusTextField.bounds.width/4, y: loginStatusTextField.bounds.origin.y, width: loginStatusTextField.bounds.width/4, height: 30)
        
        
        wordsTableView.frame = CGRect(x: 0, y: loginStatusTextField.frame.maxY + heightOffset, width: view.bounds.size.width, height: view.bounds.size.height - (loginStatusTextField.frame.maxY + heightOffset))
    }
    
    private func configure() {
        view.addSubview(searchBar)
        view.addSubview(sortButton)
        loginStatusTextField.addSubview(loginButton)
        view.addSubview(loginStatusTextField)
        view.addSubview(wordsTableView)
    }
    
    private func rxConfigure() {
        searchBar.rx.text
            .bind {
                print($0!)
            }.disposed(by: disposeBag)
        
        wordsTableView.rx.itemSelected
            .bind() { [weak self] in
                self?.wordsTableView.deselectRow(at: $0, animated: false)
                // 업로드된 단어장 띄우기
                print("Table")
            }.disposed(by: disposeBag)
        
        Observable<[String]>.of(["단어장이름", "단어장이름", "단어장이름", "단어장이름", "단어장이름", "단어장이름"])
            .bind(to: wordsTableView.rx.items(cellIdentifier: WebTableViewCell.identifier, cellType: WebTableViewCell.self)) {indexPath, item, cell in
                cell.titleLabel.text = String(item)
            }.disposed(by: disposeBag)
        
        Observable.of(sortTitle)
            .bind(to: sortPickerView.rx.itemTitles) {
                return $1
            }.disposed(by: disposeBag)
        
        sortPickerView.rx.itemSelected
            .bind() { [weak self] in
                self?.sortButton.setTitle(self?.sortTitle[$0.row], for: .normal)
                // 정렬하기
            }.disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let contentView = UIViewController()
                contentView.preferredContentSize = CGSize(width: strongSelf.view.bounds.size.width / 1.5, height: 150)
                contentView.view = strongSelf.sortPickerView
                
                // UIAlertController의 key, value값을 이용함. 다른 클래스들의 key,value값은 뭐가있는지 찾아볼것.
                actionSheet.setValue(contentView, forKey: "contentViewController")
                actionSheet.addAction(UIAlertAction(title: "확인", style: .cancel, handler:  nil ))
                strongSelf.present(actionSheet, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
}
