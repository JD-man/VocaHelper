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
    
    public var webDataSubject = PublishSubject<[WebCell]>()
    public var webModalSubject = BehaviorSubject<[SectionOfWordsCell]>(value: [])
    
    // MARK: - For WebViewController
    
    public func makeWebDataSubject(orderBy: String = "date", loadLimit: Int = 5) {
        if AuthManager.shared.checkUserLoggedIn() {
            getUserLikes { result in
                switch result {
                case .success(let likes):
                    FirestoreManager.shared.getVocaDocuments(orderBy: orderBy, loadLimit: loadLimit) {
                        let cells = $0.map {
                            WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: likes.contains($0.writer + " - " + $0.title))
                        }
                        webDataSubject.onNext(cells)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            FirestoreManager.shared.getVocaDocuments(orderBy: orderBy, loadLimit: loadLimit) {
                let cells = $0.map {
                    WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: false)
                }
                webDataSubject.onNext(cells)
            }
        }
    }
    
    public func getUserLikes(completion: @escaping ( (Result<[String],Error>)  -> Void)) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {            
            return
        }
        FirestoreManager.shared.getUserLike(email: email) { result in
            switch result {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getWebVocas(writer: String, title: String, isLiked: Bool, vocas: [Voca], view: WebViewController) {
        VocaManager.shared.vocas = vocas
        let vc = WebVocaViewController()
        vc.webVocaName = writer + " - " + title
        vc.isLiked = isLiked
        view.tabBarController?.tabBar.isHidden.toggle()
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
                FirestoreManager.shared.getUserNickName(email: email) { result in
                    switch result {
                    case .success(let nickName):
                        textField.text = "안녕하세요, \(nickName)님!"
                        UserDefaults.standard.set(nickName, forKey: "nickname")
                    case .failure(_):
                        textField.text = "유저 정보를 가져오는데 실패했습니다."
                    }
                }
                return
            }
            textField.text = "안녕하세요, \(nickName)님!"
        }
        else {
            button.setTitle("로그인", for: .normal)
            textField.text = "로그아웃 상태입니다."
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "nickname")
        }
    }
    
    public func presentUploadModal(view: WebViewController) {
        if AuthManager.shared.checkUserLoggedIn() {
            let uploadModal = UploadModalViewController()
            uploadModal.viewModel = view.viewModel
            uploadModal.modalPresentationStyle = .overCurrentContext
            uploadModal.presenting = view
            view.tabBarController?.tabBar.isHidden.toggle()
            view.present(uploadModal, animated: false, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "로그인 중이 아닙니다!", message: "로그인 후 업로드가 가능합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    public func presentSortPickerView(view: WebViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let contentView = UIViewController()
        contentView.preferredContentSize = CGSize(width: view.view.bounds.size.width / 1.5, height: 150)
        contentView.view = view.sortPickerView

        // UIAlertController의 key, value값을 이용함. 다른 클래스들의 key,value값은 뭐가있는지 찾아볼것.
        
        let orderBys: [String] = ["date", "like", "download"]
        actionSheet.setValue(contentView, forKey: "contentViewController")
        actionSheet.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { [weak view] _ in
            guard let itemIdx: Int = view?.sortPickerView.selectedRow(inComponent: 0) else {
                return
            }
            let buttonTitle = view?.sortTitle[itemIdx]
            view?.sortButton.setTitle(buttonTitle, for: .normal)
            view?.loadLimit = 5
            if view?.isSearching == false {
                view?.viewModel.makeWebDataSubject(orderBy: orderBys[itemIdx])
            }
            else {
                view?.viewModel.searchWebVoca(
                    searchText: view?.searchText ?? "",
                    orderBy: orderBys[itemIdx],
                    loadLimit: view?.loadLimit ?? 5,
                    view: view!)
            }
            view?.orderBy = orderBys[itemIdx]
        }))
        view.present(actionSheet, animated: true, completion: nil)
    }
    
    public func searchWebVoca(searchText: String, orderBy: String, loadLimit: Int, view: WebViewController) {
        if AuthManager.shared.checkUserLoggedIn() {
            getUserLikes { result in
                switch result {
                case .success(let likes):
                    FirestoreManager.shared.getVocaDocuments(orderBy: orderBy, loadLimit: loadLimit) {
                        let cells = $0.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
                            .map {
                                WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: likes.contains($0.writer + " - " + $0.title))
                            }
                        webDataSubject.onNext(cells)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            FirestoreManager.shared.getVocaDocuments(orderBy: orderBy, loadLimit: loadLimit) {
                let cells = $0.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
                    .map {
                        WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: false)
                    }
                webDataSubject.onNext(cells)
            }
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
                                        FirestoreManager.shared.putUserDocuments(nickName: nickName, email: email) { isUserPut in
                                            switch isUserPut {
                                            case true:
                                                let successAlert = UIAlertController(title: "가입이 완료됐습니다.", message: nil, preferredStyle: .alert)
                                                successAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { [weak view] _ in
                                                    UserDefaults.standard.set(nickName, forKey: "nickname")
                                                    UserDefaults.standard.set(email, forKey: "email")
                                                    NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
                                                    view?.dismiss(animated: true, completion: nil)
                                                }))
                                                view?.present(successAlert, animated: true, completion: nil)
                                            case false:
                                                let failAlert = UIAlertController(title: "유저 정보를 입력하는데 실패했습니다.", message: "계속 이런 현상이 나타나면 문의해주세요.", preferredStyle: .alert)
                                                failAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                                                view?.present(failAlert, animated: true, completion: nil)
                                            }
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
                                    let reloadFailAlert = UIAlertController(title: "유저 정보 갱신에 실패했습니다.", message: "계속 이런 현상이 나타나면 문의해주세요.", preferredStyle: .alert)
                                    reloadFailAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                                    view?.present(reloadFailAlert, animated: true, completion: nil)
                                }
                            }
                        }))
                        view.present(sendEmailAlert, animated: true, completion: nil)
                    case false:
                        let sendEmailFailalert = UIAlertController(title: "이메일 전송이 실패했습니다.", message: "계속 이런 현상이 나타나면 문의해주세요.", preferredStyle: .alert)
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
    
    public func makeWebModalSubject() {
        var temp = VocaManager.shared.fileNames
        temp.removeLast()
        
        let cells = temp.map {
            WordsCell(identity: $0, fileName: changeToRealName(fileName: $0))
        }
        webModalSubject.onNext([SectionOfWordsCell(idx: 0, items: cells)])
    }
    
    public func handleAnimation(height: CGFloat, view: UploadModalViewController) {
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) { [weak view] in
            guard let handleView = view?.handleView else {
                return
            }
            handleView.frame = CGRect(x: handleView.frame.minX, y: height, width: handleView.frame.width, height: handleView.frame.height)
        }
        
        if height ==  view.handleView.frame.height {
            animator.addCompletion { [weak view] _ in
                view?.dismiss(animated: false) {
                    NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
                    view?.presenting?.tabBarController?.tabBar.isHidden.toggle()
                }
            }
        }
        animator.startAnimation()
    }
    
    var startY: CGFloat = 0
    var startHeight: CGFloat = 0
    public mutating func grabHandle(recognizer: UIPanGestureRecognizer, view: UploadModalViewController) {
        switch recognizer.state {
        case .began:
            startY = view.handleView.frame.minY
            startHeight = view.collectionView?.frame.height ?? 0
        case .changed:
            var y = startY + recognizer.translation(in: view.handleView).y
            var collectionViewHeight = startHeight - recognizer.translation(in: view.handleView).y
            if y <= view.maxHeight {
                y = view.maxHeight
                collectionViewHeight = view.handleView.frame.height - view.maxHeight - view.bottomBlockView.frame.height - 25
            }
            else if y >= view.minHeight {
                y = view.minHeight
                collectionViewHeight = view.handleView.frame.height - view.minHeight - view.bottomBlockView.frame.height - 25
            }
            view.handleView.frame = CGRect(x: view.handleView.frame.minX, y: y, width: view.handleView.frame.width, height: view.handleView.frame.height)
            view.collectionView?.frame = CGRect(x: 0, y: view.collectionView?.frame.origin.y ?? 0, width: view.collectionView?.frame.width ?? 0, height: collectionViewHeight)
            view.bottomBlockView.frame = CGRect(x: 0, y: view.collectionView?.frame.maxY ?? 0 + view.bottomBlockView.frame.height, width: view.bottomBlockView.frame.width, height: view.bottomBlockView.frame.height)
        
        case .ended:
            if recognizer.velocity(in: view.handleView).y >= 1550 {
                handleAnimation(height: view.handleView.frame.height, view: view)
            }
        default:
            break
        }
    }
    
    public func uploadVocas(fileIndex: Int, view: UploadModalViewController) {
        let fileName = VocaManager.shared.fileNames[fileIndex]
        VocaManager.shared.loadVocasLocal(fileName: fileName)
        
        // alert띄우고 타이틀, 간단설명 적게 한 후에 OK하면 올리기
        let alert = UIAlertController(title: "제목과 간단한 설명을 입력해주세요.", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "제목..."
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        alert.addTextField { textField in
            textField.placeholder = "간단한 설명..."
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        alert.addAction(UIAlertAction(title: "업로드", style: .default, handler: { [weak view] _ in
            guard let alertTextFields = alert.textFields,
                  let title = alertTextFields[0].text,
                  let description = alertTextFields[1].text else {
                return
            }
            if title == "" {
                let titleFailAlert = UIAlertController(title: "제목을 입력해주세요.", message: nil, preferredStyle: .alert)
                titleFailAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                    uploadVocas(fileIndex: fileIndex, view: view!)
                }))
                view?.present(titleFailAlert, animated: true, completion: nil)
            }
            else if description == "" {
                let descriptionFailAlert = UIAlertController(title: "간단한 설명을 입력해주세요.", message: nil, preferredStyle: .alert)
                descriptionFailAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: {  _ in
                    uploadVocas(fileIndex: fileIndex, view: view!)
                }))
                view?.present(descriptionFailAlert, animated: true, completion: nil)
            }
            else {
                FirestoreManager.shared.putVocaDocuments(
                    fileName: fileName,
                    title: title,
                    description: description,
                    vocas: VocaManager.shared.vocas) { isUploaded in
                    switch isUploaded {
                    case true:
                        let alert = UIAlertController(title: "업로드가 완료됐습니다.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            handleAnimation(height: view?.handleView.frame.height ?? 0, view: view!)
                        }))
                        view?.present(alert, animated: true, completion: nil)
                    case false:
                        let alert = UIAlertController(title: "업로드에 실패했습니다.", message: "계속 이런 현상이 나타나면 문의해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        view?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
