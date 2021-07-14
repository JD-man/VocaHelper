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
    public let sortTitle = ["최신순","추천순", "다운순"]
    public var orderBy: String = "date"
    public var userLikeList: [String] = []
    public let viewModel = WebViewModel()
    
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.autocorrectionType = .no
        bar.autocapitalizationType = .none
        return bar
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    let sortPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("업로드", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.isEnabled = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    let loginStatusTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.text = "로그아웃 상태입니다."
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
        navigationItem.title = "찾아보기"
        navigationController?.navigationBar.prefersLargeTitles = true
        configure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightOffset: CGFloat = 15
        searchBar.frame = CGRect(x: 0, y: navigationController!.navigationBar.frame.maxY, width: view.bounds.size.width, height: 50)
        
        loginStatusTextField.frame = CGRect(x: 10, y: searchBar.frame.maxY + heightOffset, width: view.bounds.size.width / 2, height: 30)
        loginButton.frame = CGRect(x: loginStatusTextField.frame.maxX  + 10, y: loginStatusTextField.frame.minY, width: loginStatusTextField.frame.width/4, height: 30)
        uploadButton.frame = CGRect(x: loginButton.frame.maxX + 10, y: loginStatusTextField.frame.minY, width: loginButton.frame.width, height: loginButton.frame.height)
        sortButton.frame = CGRect(x: uploadButton.frame.maxX + 10, y: loginStatusTextField.frame.minY, width: loginButton.frame.width, height: loginButton.frame.height)
        wordsTableView.frame = CGRect(x: 0, y: loginStatusTextField.frame.maxY + heightOffset, width: view.bounds.size.width, height: view.bounds.size.height - (loginStatusTextField.frame.maxY + heightOffset))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(addStateObserver), name: NSNotification.Name("StateObserver"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configure() {
        view.addSubview(searchBar)
        view.addSubview(loginStatusTextField)
        view.addSubview(loginButton)
        view.addSubview(sortButton)
        view.addSubview(uploadButton)
        view.addSubview(wordsTableView)
    }
    
    private func rxConfigure() {
        
        loginButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.didTapLoginButtonInWebViewController(button: self?.loginButton ?? UIButton(), view: self!)
            }.disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.presentUploadModal(view: self!)
            }.disposed(by: disposeBag)
        
//        searchBar.rx.text
//            .bind {
//                print($0!)
//            }.disposed(by: disposeBag)


        viewModel.webDataSubject
            .distinctUntilChanged({
                return $0 == $1
            }).bind(to: wordsTableView.rx.items(cellIdentifier: WebTableViewCell.identifier, cellType: WebTableViewCell.self)) { [weak self] indexPath, item, cell in
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
                cell.writerLabel.text = item.writer
                cell.downloadLabel.text = String(item.download)
                cell.likeLabel.text = String(item.like)
                
                let likeImage = item.liked ? "hand.thumbsup.fill" : "hand.thumbsup"
                
                cell.likeButton.setImage(UIImage(systemName: likeImage), for: .normal)

                cell.tapFunction = { self?.viewModel.getWebVocas(
                    writer: item.writer,
                    title: item.title,
                    isLiked: item.liked,
                    vocas: item.vocas,
                    view: self!) }
            }.disposed(by: disposeBag)
        
        Observable.of(sortTitle)
            .bind(to: sortPickerView.rx.itemTitles) {
                return $1
            }.disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.presentSortPickerView(view: self!)
            }.disposed(by: disposeBag)
    }
    
    @objc private func addStateObserver() {
        viewModel.setLoginButton(textField: loginStatusTextField, button: loginButton)
        viewModel.makeWebDataSubject(orderBy: orderBy)
    }
}
