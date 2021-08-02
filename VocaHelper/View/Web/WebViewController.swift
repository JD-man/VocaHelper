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
    public var viewModel = WebViewModel()
    
    public var loadLimit: Int = 10
    public var isStarting: Bool = true
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        button.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.isEnabled = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
        textField.rightViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.isEnabled = false
        textField.isUserInteractionEnabled = false
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let wordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WebTableViewCell.self, forCellReuseIdentifier: WebTableViewCell.identifier)
        tableView.rowHeight = 240
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "단어장 다운받기"
        navigationController?.navigationBar.prefersLargeTitles = true
        configure()
        constraintsConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(addStateObserver), name: NSNotification.Name("StateObserver"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configure() {
        view.addSubview(loginStatusTextField)
        view.addSubview(loginButton)
        view.addSubview(sortButton)
        view.addSubview(uploadButton)
        view.addSubview(wordsTableView)
        view.addSubview(activityIndicator)
    }
    
    private func constraintsConfigure() {
        let heightOffset: CGFloat = 15
        
        sortButton.topAnchor.constraint(equalTo: loginStatusTextField.topAnchor).isActive = true
        sortButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        sortButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.12).isActive = true
        sortButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        uploadButton.topAnchor.constraint(equalTo: loginStatusTextField.topAnchor).isActive = true
        uploadButton.rightAnchor.constraint(equalTo: sortButton.leftAnchor, constant: -10).isActive = true
        uploadButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.12).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: loginStatusTextField.topAnchor).isActive = true
        loginButton.rightAnchor.constraint(equalTo: uploadButton.leftAnchor, constant: -10).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.12).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginStatusTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        loginStatusTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        loginStatusTextField.rightAnchor.constraint(lessThanOrEqualTo: loginButton.leftAnchor, constant: -10).isActive = true
        loginStatusTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        wordsTableView.topAnchor.constraint(equalTo: loginStatusTextField.bottomAnchor, constant: heightOffset).isActive = true
        wordsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        wordsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        wordsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
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
        
        viewModel.webDataSubject            
            .bind(to: wordsTableView.rx.items(cellIdentifier: WebTableViewCell.identifier, cellType: WebTableViewCell.self)) { [weak self] indexPath, item, cell in
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
                cell.writerLabel.text = item.writer
                cell.downloadLabel.text = String(item.download)
                cell.likeLabel.text = String(item.like)
                
                let likeImage = item.liked ? "hand.thumbsup.fill" : "hand.thumbsup"
                cell.likeButton.setImage(UIImage(systemName: likeImage), for: .normal)

                cell.tapFunction = { self?.viewModel.getWebVocas(
                    email: item.email,
                    title: item.title,
                    isLiked: item.liked,
                    vocas: item.vocas,
                    view: self!)
                }
                
                if self?.isStarting == true && indexPath == (self?.loadLimit ?? 5) - 1 {
                    self?.isStarting = false
                }
                else if self?.isStarting == false && indexPath == (self?.loadLimit ?? 5) - 1 {
                    self?.isStarting = true
                    self?.loadLimit += 5
                    self?.viewModel.makeWebDataSubject(
                        orderBy: self?.orderBy ?? "date",
                        loadLimit: self?.loadLimit ?? 5,
                        indiciator: self?.activityIndicator ?? UIActivityIndicatorView())
                }
            }.disposed(by: disposeBag)
        
        Observable.of(sortTitle)
            .bind(to: sortPickerView.rx.itemTitles) {
                return $1
            }.disposed(by: disposeBag)
        
        sortButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.presentSortPickerView(view: self!)
            }.disposed(by: disposeBag)
        
        let refresher = UIRefreshControl()
        wordsTableView.refreshControl = refresher
        refresher.rx.controlEvent(.valueChanged)
            .bind { [weak self] in
                self?.isStarting = true
                self?.loadLimit = 5
                self?.viewModel.makeWebDataSubject(orderBy: self?.orderBy ?? "date", indiciator: self?.activityIndicator ?? UIActivityIndicatorView())
                refresher.endRefreshing()
            }.disposed(by: disposeBag)
    }
    
    @objc private func addStateObserver() {
        isStarting = true
        loadLimit = 5
        viewModel.setLoginButton(textField: loginStatusTextField, button: loginButton)
        viewModel.makeWebDataSubject(orderBy: orderBy, indiciator: activityIndicator)
    }
}
