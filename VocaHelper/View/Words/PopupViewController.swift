//
//  PopupViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit
import RxSwift
import RxCocoa

class PopupViewController: UIViewController {
    
    deinit {
        print("deinit PopUpView")
    }
    
    public var presenting: WordsViewController?
    public var viewModel: WordsViewModel?
    public var fileName: String = ""
    
    private var disposeBag = DisposeBag()
    private var stackViewHeightAnchor = NSLayoutConstraint()
    private var textFieldHeightAnchor = NSLayoutConstraint()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 15        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .label
        stackView.spacing = 1
        return stackView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.backgroundColor = .label
        textField.textColor = .systemBackground
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 15
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.adjustsFontSizeToFitWidth = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("단어장", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        return button
    }()
    
    let practiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("연습하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let examButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시험보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        stackViewConfigure()
        addSubViews()
        configure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        stackViewHeightAnchor.isActive = false
        textFieldHeightAnchor.isActive = false
        if size.width > size.height {
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/1.5)
            stackViewHeightAnchor.isActive = true
            textFieldHeightAnchor = textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/7)
            textFieldHeightAnchor.isActive = true
        }
        else {
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3)
            stackViewHeightAnchor.isActive = true
            textFieldHeightAnchor = textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/15)
            textFieldHeightAnchor.isActive = true
        }
    }
    
    private func stackViewConfigure() {
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(practiceButton)
        stackView.addArrangedSubview(examButton)
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(exitButton)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    }
    
    private func configure() {
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.7)
        
        let stackViewHeightMultiplier: CGFloat = view.bounds.width > view.bounds.height ? 1 / 1.5 : 1 / 3
        let textFieldHeightMultiplier: CGFloat = view.bounds.width > view.bounds.height ? 1 / 7 : 1 / 15
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 12).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: stackViewHeightMultiplier)
        stackViewHeightAnchor.isActive = true
        
        textField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        textFieldHeightAnchor = textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: textFieldHeightMultiplier)
        textFieldHeightAnchor.isActive = true
    }
    
    private func addSubViews() {
        view.addSubview(textField)
        view.addSubview(stackView)
    }
    
    func changeToRealName(fileName: String) -> String {
        return String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
    }
    
    private func rxConfigure() {
        exitButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.willExit(view: self!)
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.didTapEditButton(view: self!)                
            }.disposed(by: disposeBag)
        
        practiceButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.didTapPracticeButton(view: self!)
            }.disposed(by: disposeBag)
        
        examButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.didTapExamButton(view: self!)
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.didTapDeleteButton(view: self!)                
            }.disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
}

extension PopupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
