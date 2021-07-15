//
//  PopupViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

class PopupViewController: UIViewController {
    
    deinit {
        print("deinit PopUpView")
    }
    
    public var editClosure: (() -> Void)?
    public var practiceClosure: (() -> Void)?
    public var examClosure: (() -> Void)?
    public var deleteClosure: (() -> Void)?
    public var exitClosure: (() -> Void)?
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        return button
    }()
    
    let practiceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Practice", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let examButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exam", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewConfigure()
        addSubViews()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTarget()
        textField.delegate = self        
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
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        textField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/15).isActive = true
    }
    
    private func addSubViews() {
        view.addSubview(textField)
        view.addSubview(stackView)
    }
    
    private func addTarget() {
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        practiceButton.addTarget(self, action: #selector(didTapPracticeButton), for: .touchUpInside)
        examButton.addTarget(self, action: #selector(didTapExamButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    }
    
    @objc private func didTapEditButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.editButton.backgroundColor = .systemGray4
            self?.editButton.backgroundColor = .systemBackground
        }
        guard let editClosure = editClosure,
              let exitClosure = exitClosure else {
            return
        }
        exitClosure()
        editClosure()
    }
    
    @objc private func didTapPracticeButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.practiceButton.backgroundColor = .systemGray4
            self?.practiceButton.backgroundColor = .systemBackground
        }
        guard let practiceClosure = practiceClosure,
              let exitClosure = exitClosure else {
            return
        }
        exitClosure()
        practiceClosure()
    }

    @objc private func didTapExamButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.examButton.backgroundColor = .systemGray4
            self?.examButton.backgroundColor = .systemBackground
        }
        guard let exitClosure = exitClosure,
              let examClosure = examClosure else {
            return
        }
        exitClosure()
        examClosure()
    }

    @objc private func didTapDeleteButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.deleteButton.backgroundColor = .systemGray4
            self?.deleteButton.backgroundColor = .systemBackground
        }
        guard let deleteClosure = deleteClosure else {
            return
        }
        deleteClosure()
    }

    @objc private func didTapExitButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.exitButton.backgroundColor = .systemGray4
            self?.exitButton.backgroundColor = .systemBackground
        }
        guard  let exitClosure = exitClosure else {
            return
        }
        exitClosure()
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
