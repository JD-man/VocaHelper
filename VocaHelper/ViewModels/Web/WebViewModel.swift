//
//  WebViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/09.
//

import Foundation
import RxSwift

struct WebViewModel {
    private let disposeBag = DisposeBag()
    
    public var webDataSubject = BehaviorSubject<[WebData]>(value: [])
    public var webModalSubject = BehaviorSubject<[SectionOfWordsCell]>(value: [])
    
    
    init() {
        makeWebDataSubject()
    }
    
    // MARK: - For WebViewController
    
    private func makeWebDataSubject() {
        FirestoreManager.shared.getVocaDocuments {
            webDataSubject.onNext($0)
        }
    }
    
    public func getWebVocas(vocas: [Voca], view: WebViewController) {
        VocaManager.shared.vocas = vocas
        let vc = WebVocaViewController()
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func didTapLoginButtonInWebViewController(button: UIButton, view: WebViewController) {
        if button.titleLabel?.text == "로그인" {
            let loginVC = LoginViewController()
            loginVC.viewModel = view.viewModel
            loginVC.presentingView = view
            view.present(loginVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
                AuthManager.shared.logoutUser()
                NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
            }))
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    public func setLoginButton(textField: UITextField, button: UIButton) {
        if AuthManager.shared.checkUserLoggedIn() {
            button.setTitle("로그아웃", for: .normal)
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return
            }
            guard let nickName = UserDefaults.standard.value(forKey: "nickname") as? String else {
                FirestoreManager.shared.getUserNickName(email: email) { nickName in
                    textField.text = nickName
                    UserDefaults.standard.set(nickName, forKey: "nickname")
                }
                return
            }
            textField.text = nickName
        }
        else {
            button.setTitle("로그인", for: .normal)
            textField.text = "로그아웃 상태입니다."
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "nickname")
        }
    }
    
    // MARK: - For LoginViewConroller
    
    public func didTapLoginButton(email: String, password: String, view: LoginViewController) {
        AuthManager.shared.loginUser(email: email, password: password) { isLoggedIn in
            switch isLoggedIn {
            case true:
                view.dismiss(animated: true) {
                    UserDefaults.standard.set(email, forKey: "email")
                    NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
                }
            case false:
                let alert = UIAlertController(title: "로그인에 실패했습니다.", message: "아이디와 이메일을 확인해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                view.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    public func didTapSignUpButton(view: LoginViewController, presenting: WebViewController) {
        view.dismiss(animated: true) { [weak presenting] in
            let createUserVC = CreateUserViewController()
            createUserVC.viewModel = view.viewModel
            presenting?.present(createUserVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - For CreateUserViewController
    
    public func createNewUser(nickName: String, email: String, password: String, view: CreateUserViewController) {
        AuthManager.shared.createNewUser(email: email, password: password) { isCreated in
            switch isCreated {
            case true:
                AuthManager.shared.sendVerificationEmail { isEmailSent in
                    switch isEmailSent {
                    case true:
                        let sendEmailAlert = UIAlertController(title: "인증메일이 전송되었습니다.", message: "인증을 완료한 후 확인을 눌러주세요", preferredStyle: .alert)
                        sendEmailAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { [weak view] _ in
                            AuthManager.shared.userReload { isReloaded in
                                switch isReloaded {
                                case true:
                                    if AuthManager.shared.checkUserVeryfied() {
                                        FirestoreManager.shared.putUserDocuments(nickName: nickName, email: email) {
                                            let successAlert = UIAlertController(title: "가입이 완료됐습니다.", message: nil, preferredStyle: .alert)
                                            successAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { [weak view] _ in
                                                UserDefaults.standard.set(nickName, forKey: "nickname")
                                                UserDefaults.standard.set(email, forKey: "email")
                                                NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
                                                view?.dismiss(animated: true, completion: nil)
                                            }))
                                            view?.present(successAlert, animated: true, completion: nil)
                                        }
                                    }
                                    else {
                                        let verificationFailalert = UIAlertController(title: "인증에 실패했습니다.", message: "가입을 다시 시도해주세요.", preferredStyle: .alert)
                                        verificationFailalert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                                            AuthManager.shared.deleteCurrentUser()
                                            AuthManager.shared.logoutUser()
                                        }))
                                        view?.present(verificationFailalert, animated: true, completion: nil)
                                    }
                                case false:
                                    let reloadFailAlert = UIAlertController(title: "유저 정보 갱신에 실패했습니다.", message: "이런현상이 계속 발생하는 경우 문의해주세요.", preferredStyle: .alert)
                                    reloadFailAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                                    view?.present(reloadFailAlert, animated: true, completion: nil)
                                }
                            }
                        }))
                        view.present(sendEmailAlert, animated: true, completion: nil)
                    case false:
                        let sendEmailFailalert = UIAlertController(title: "이메일 전송이 실패했습니다.", message: "이런현상이 계속 발생하는 경우 문의해주세요.", preferredStyle: .alert)
                        sendEmailFailalert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                        view.present(sendEmailFailalert, animated: true, completion: nil)
                    }
                }                
            case false:
                let failAlert = UIAlertController(title: "가입이 실패했습니다.", message: "닉네임과 이메일을 확인해주세요.", preferredStyle: .alert)
                failAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                view.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    public func nickNameExistCheck(nickName: String, view: CreateUserViewController) {
        FirestoreManager.shared.checkNickNameExist(nickName: nickName) { isChecked in
            switch isChecked {
            case true:
                view.isNickNameUsable = false
                let alert = UIAlertController(title: "이미 존재하는 닉네임입니다.", message: "다른 닉네임을 사용해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                view.present(alert, animated: true, completion: nil)
            case false:
                view.isNickNameUsable = true
            }
        }
    }
    
    public func emailExistCheck(email: String, view: CreateUserViewController) {
        FirestoreManager.shared.checkEmailExist(email: email) { isChecked in
            switch isChecked {
            case true:
                view.isEmailUsable = false
                let alert = UIAlertController(title: "이미 존재하는 이메일입니다.", message: "다른 이메일을 사용해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                view.present(alert, animated: true, completion: nil)
            case false:
                view.isEmailUsable = true
            }
        }
    }
    
    // MARK: - For UploadModalViewController
    
    func changeToRealName(fileName: String) -> String {
        return String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
    }
    
    public func makewebModalSubject() {
        var temp = VocaManager.shared.fileNames
        temp.removeLast()
        
        let cells = temp.map {
            WordsCell(identity: $0, fileName: changeToRealName(fileName: $0))
        }
        webModalSubject.onNext([SectionOfWordsCell(idx: 0, items: cells)])
    }
}
