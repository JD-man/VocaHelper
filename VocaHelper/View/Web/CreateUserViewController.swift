//
//  CreateUserViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class CreateUserViewController: UIViewController {
    
    deinit {
        print("deinit CreateUserVC")
    }
    
    var viewModel: WebViewModel?
    var disposeBag = DisposeBag()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = nil
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isNickNameUsable: Bool = true
    var isEmailUsable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        viewConfigure()
        constraintsConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func viewConfigure() {
        if UIDevice.current.orientation != .portrait {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        UINavigationController.attemptRotationToDeviceOrientation()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        scrollView.addSubview(handleView)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(nickNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(exitButton)
        view.addSubview(scrollView)
        
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요...", attributes: [.foregroundColor : UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요...", attributes: [.foregroundColor : UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요...", attributes: [.foregroundColor : UIColor.lightGray])
    }
    
    private func constraintsConfigure() {
        let gap: CGFloat = 10
        
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        handleView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: gap).isActive = true
        handleView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        handleView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.1).isActive = true
        handleView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.01).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 2 * gap).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/2).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/4).isActive = true
        
        nickNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 2 * gap).isActive = true
        nickNameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nickNameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/1.3).isActive = true
        nickNameTextField.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/12).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 2 * gap).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 2 * gap).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 1.5 * gap).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor, multiplier: 0.5).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor).isActive = true
        
        exitButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 1.5 * gap).isActive = true
        exitButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        exitButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, multiplier: 0.5).isActive = true
        exitButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30).isActive = true
    }
    
    private func rxConfigure() {
        signUpButton.rx.tap
            .bind { [weak self] in
                guard let strongSelf = self,
                      let viewModel = self?.viewModel else {
                    return
                }
                if strongSelf.isNickNameUsable, strongSelf.isEmailUsable {
                    viewModel.createNewUser(
                        nickName: strongSelf.nickNameTextField.text ?? "",
                        email: strongSelf.emailTextField.text ?? "",
                        password: strongSelf.passwordTextField.text ?? "",
                        view: strongSelf)
                }
                else {
                    print("닉네임, 이메일 확인")
                }
            }.disposed(by: disposeBag)
        
        nickNameTextField.rx.controlEvent(.editingDidEnd)
            .bind { [weak self] in
                self?.viewModel?.nickNameExistCheck(nickName: self?.nickNameTextField.text ?? "", view: self!)
            }.disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingDidEnd)
            .bind { [weak self] in
                self?.viewModel?.emailExistCheck(email: self?.emailTextField.text ?? "" , view: self!)
            }.disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
}
