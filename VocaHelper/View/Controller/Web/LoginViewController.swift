//
//  LoginViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    deinit {
        print("deinit LoginVC")
    }
    
    var viewModel: WebViewModel?
    var disposeBag = DisposeBag()
    var presentingView: WebViewController?
    
    
    let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    let findPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = nil
        button.setTitle("비밀번호찾기", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        viewConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gap: CGFloat = 10
        let textFieldWidth: CGFloat = view.bounds.width / 1.3
        let textFieldHeight: CGFloat = textFieldWidth / 9
        let buttonOffset: CGFloat = 40
        
        handleView.frame = CGRect(x: (view.bounds.width - 50) * 0.5, y: view.safeAreaInsets.top + gap, width: 50, height: 5)
        logoImageView.frame = CGRect(x: view.bounds.width/4, y: handleView.frame.maxY + 2 * gap, width: view.bounds.width/2, height: view.bounds.width/4)
        emailTextField.frame = CGRect(x: 0.5 * (view.bounds.width - textFieldWidth), y: logoImageView.frame.maxY + 2*gap, width: textFieldWidth, height: textFieldHeight)
        passwordTextField.frame = CGRect(x: 0.5 * (view.bounds.width - textFieldWidth), y: emailTextField.frame.maxY + 1.5 * gap, width: textFieldWidth, height: textFieldHeight)
        loginButton.frame = CGRect(x: 0.5 * (view.bounds.width - (textFieldWidth - buttonOffset)), y: passwordTextField.frame.maxY + 1.5 * gap, width: textFieldWidth - buttonOffset, height: textFieldHeight)
        signUpButton.frame = CGRect(x: 0.5 * (view.bounds.width - (textFieldWidth - buttonOffset)), y: loginButton.frame.maxY + 1.5 * gap, width: textFieldWidth - buttonOffset, height: textFieldHeight)
        findPasswordButton.frame = CGRect(x: 0.5 * (view.bounds.width - (textFieldWidth - buttonOffset)), y: signUpButton.frame.maxY + 1.5 * gap, width: textFieldWidth - buttonOffset, height: textFieldHeight)
    }
    
    private func viewConfigure() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        view.addSubview(handleView)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(findPasswordButton)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요...", attributes: [.foregroundColor : UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요...", attributes: [.foregroundColor : UIColor.lightGray])
    }
    
    private func rxConfigure() {
        loginButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.didTapLoginButton(
                    email: self?.emailTextField.text ?? "",
                    password: self?.passwordTextField.text ?? "",
                    view: self!)
            }.disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.didTapSignUpButton(view: self!, presenting: self!.presentingView!)
            }.disposed(by: disposeBag)
    }
}
