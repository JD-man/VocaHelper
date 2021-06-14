//
//  PopupViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

class PopupViewController: UIViewController {
    
    deinit {
        print("deinit")
    }
    
    public var editClosure: (() -> Void)?
    public var practiceClosure: (() -> Void)?
    public var testClosure: (() -> Void)?
    public var deleteClosure: (() -> Void)?
    public var exitClosure: (() -> Void)?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.backgroundColor = .label
        textField.textColor = .systemBackground
        textField.layer.cornerRadius = 20
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.adjustsFontSizeToFitWidth = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        return textField
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let practiceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Practice", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("Test", for: .normal)
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
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        addSubViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let popupWidth = view.bounds.width / 2
        let popupHeight = view.bounds.height / 15
        let popupX = view.bounds.width / 2 - popupWidth / 2
        let popupY = view.bounds.height / 2 - (popupHeight / 2) * 6
        
        textField.frame = CGRect(x: popupX, y: popupY, width: popupWidth, height: popupHeight)
        editButton.frame = CGRect(x: popupX, y: textField.frame.origin.y + +textField.bounds.height + 5, width: popupWidth, height: popupHeight)
        practiceButton.frame = CGRect(x: popupX, y: editButton.frame.origin.y + +editButton.bounds.height, width: popupWidth, height: popupHeight)
        testButton.frame = CGRect(x: popupX, y: practiceButton.frame.origin.y + +practiceButton.bounds.height, width: popupWidth, height: popupHeight)
        deleteButton.frame = CGRect(x: popupX, y: testButton.frame.origin.y + +testButton.bounds.height, width: popupWidth, height: popupHeight)
        exitButton.frame = CGRect(x: popupX, y: deleteButton.frame.origin.y + +deleteButton.bounds.height, width: popupWidth, height: popupHeight)
        
        addTarget()
        
        textField.delegate = self        
    }
    
    private func configure() {
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.7)
    }
    
    private func addSubViews() {
        view.addSubview(textField)
        view.addSubview(editButton)
        view.addSubview(practiceButton)
        view.addSubview(testButton)
        view.addSubview(deleteButton)
        view.addSubview(exitButton)
    }
    
    private func addTarget() {
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        practiceButton.addTarget(self, action: #selector(didTapPracticeButton), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(didTapTestButton), for: .touchUpInside)
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

    @objc private func didTapTestButton() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.testButton.backgroundColor = .systemGray4
            self?.testButton.backgroundColor = .systemBackground
        }
        guard let exitClosure = exitClosure,
              let testClosure = testClosure else {
            return
        }
        exitClosure()
        testClosure()
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
