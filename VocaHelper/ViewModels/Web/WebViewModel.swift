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
    public var uploadModalSubject = BehaviorSubject<[SectionOfWordsCell]>(value: [])
    public var userUploadVocaSubject = BehaviorSubject<[WebCell]>(value: [])
    
    // MARK: - For WebViewController
    
    public func makeWebDataSubject(orderBy: String = "date", loadLimit: Int = 5, indiciator: UIActivityIndicatorView) {
        indiciator.startAnimating()
        if AuthManager.shared.checkUserLoggedIn() {
            getUserLikes { result in
                switch result {
                case .success(let likes):
                    FirestoreManager.shared.getVocaDocuments(orderBy: orderBy, loadLimit: loadLimit) {
                        let cells = $0.map {
                            WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: likes.contains($0.email + " - " + $0.title), email: $0.email)
                        }
                        webDataSubject.onNext(cells)
                        indiciator.stopAnimating()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            FirestoreManager.shared.getVocaDocuments(orderBy: orderBy, loadLimit: loadLimit) {
                let cells = $0.map {
                    WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: false, email: $0.email)
                }
                webDataSubject.onNext(cells)
                indiciator.stopAnimating()
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
    
    public func getWebVocas(email: String, title: String, isLiked: Bool, vocas: [Voca], view: WebViewController) {
        // 닉네임으로 이메일을 가져와야함.
        VocaManager.shared.vocas = vocas
        VocaManager.shared.examResults = []
        let vc = WebVocaViewController()
        vc.webVocaName = email + " - " + title
        vc.isLiked = isLiked
        //view.tabBarController?.tabBar.isHidden.toggle()
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
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "닉네임 수정", style: .default, handler: { [weak view] _ in
                let nicknameAlert = UIAlertController(title: "사용할 닉네임을 입력해주세요.", message: nil, preferredStyle: .alert)
                nicknameAlert.addTextField {
                    $0.placeholder = "사용할 닉네임..."
                }
                nicknameAlert.addAction(UIAlertAction(title: "변경", style: .default, handler: { [weak view] _ in
                    guard let textField = nicknameAlert.textFields,
                          let newNickname = textField[0].text else {
                        return
                    }
                    FirestoreManager.shared.checkNickNameExist(nickName: newNickname) { isChecked in
                        switch isChecked {
                        case true:
                            let existAlert = UIAlertController(title: "이미 존재하는 닉네임입니다.", message: "다른 닉네임으로 변경해주세요.", preferredStyle: .alert)
                            existAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
                                view?.present(nicknameAlert, animated: true, completion: nil)
                            }))
                            view?.present(existAlert, animated: true, completion: nil)
                        case false:
                            guard let email = UserDefaults.standard.value(forKey: "email") as? String,
                                  let prevNickname = UserDefaults.standard.value(forKey: "nickname") as? String else {
                                return
                            }
                            FirestoreManager.shared.changeUserNickname(newNickname: newNickname, email: email) { isPut in
                                switch isPut {
                                case true:
                                    let successAlert = UIAlertController(title: "닉네임 변경이 완료됐습니다.", message: nil, preferredStyle: .alert)
                                    successAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                        // 유저디폴트 닉네임 변경
                                        UserDefaults.standard.setValue(newNickname, forKey: "nickname")
                                        // 웹뷰 컨트롤러에 포스트
                                        NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
                                        // 이메일로 찾아서 VocaCollection에서 writer 변경
                                        FirestoreManager.shared.changeWebVocaWriter(prevNickname: prevNickname, newNickname: newNickname) { isChanged in
                                            print(isChanged)
                                        }
                                    }))
                                    view?.present(successAlert, animated: true, completion: nil)
                                case false:
                                    let failureAlert = UIAlertController(title: "닉네임 변경에 실패했습니다.", message: "계속 이런 현상이 나타나면 문의해주세요.", preferredStyle: .alert)
                                    failureAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                        view?.present(nicknameAlert, animated: true, completion: nil)
                                    }))
                                    view?.present(failureAlert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }))
                nicknameAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                view?.present(nicknameAlert, animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "업로드한 단어장", style: .default, handler: { [weak view] _ in
                let userWebVocaVC = UserWebVocaViewController()
                userWebVocaVC.viewModel = view?.viewModel
                view?.navigationController?.pushViewController(userWebVocaVC, animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { [weak view] _ in
                didTapLogout(view: view!)
            }))
            actionSheet.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
            view.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    public func setLoginButton(textField: UITextField, button: UIButton) {
        if AuthManager.shared.checkUserLoggedIn() {
            button.setTitle("프로필", for: .normal)
            var email = ""
            if let userDefaultsEmail = UserDefaults.standard.value(forKey: "email") as? String {
                email = userDefaultsEmail
            } else {
                email = AuthManager.shared.getUserEmail()
                UserDefaults.standard.setValue(email, forKey: "email")
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
            view.present(uploadModal, animated: false, completion: nil)
            view.tabBarController?.tabBar.isHidden.toggle()
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
            view?.viewModel.makeWebDataSubject(orderBy: orderBys[itemIdx], indiciator: view!.activityIndicator)
            view?.orderBy = orderBys[itemIdx]
        }))
        view.present(actionSheet, animated: true, completion: nil)
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
                let failAlert = UIAlertController(title: "유저 생성에 실패했습니다.", message: "계속 이런 현상이 나타나면 문의해주세요.", preferredStyle: .alert)
                failAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                view.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    public func nickNameExistCheck(nickName: String, view: CreateUserViewController) {
        view.checkGroup.enter()
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) { [weak view] in
            view?.view.layoutIfNeeded()
        }
        guard nickName.count <= 8 else {
            view.isNickNameUsable = false
            DispatchQueue.main.async {
                view.nickNameErrorLabel.text = "8자 이하로 만들어주세요.     "
                view.nickNameErrorLabelHeightAnchor.isActive = false
                animator.startAnimation()
            }
            view.checkGroup.leave()
            print("닉네임 체크")
            return
        }
        guard nickName.count != 0 else {
            view.isNickNameUsable = false
            DispatchQueue.main.async {
                view.nickNameErrorLabelHeightAnchor.isActive = true
                animator.startAnimation()
            }
            view.checkGroup.leave()
            print("닉네임 체크")
            return
        }
        
        FirestoreManager.shared.checkNickNameExist(nickName: nickName) { isChecked in
            switch isChecked {
            case true:
                view.isNickNameUsable = false
                DispatchQueue.main.async {
                    view.nickNameErrorLabel.text = "이미 존재하는 닉네임입니다."
                    view.nickNameErrorLabelHeightAnchor.isActive = false
                    animator.startAnimation()
                }
                view.checkGroup.leave()
                print("닉네임 체크")
            case false:
                view.isNickNameUsable = true
                DispatchQueue.main.async {
                    view.nickNameErrorLabelHeightAnchor.isActive = true
                    animator.startAnimation()
                }
                view.checkGroup.leave()
                print("닉네임 체크")
            }
        }
    }
    
    public func emailExistCheck(email: String, view: CreateUserViewController) {
        view.checkGroup.enter()
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) { [weak view] in
            view?.view.layoutIfNeeded()
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        guard emailPred.evaluate(with: email) else {
            view.isEmailUsable = false
            DispatchQueue.main.async {
                view.emailErrorLabel.text = "정확한 메일을 입력해주세요."
                view.emailErrorLabelHeightAnchor.isActive = false
                animator.startAnimation()
            }
            view.checkGroup.leave()
            return
        }
        
        FirestoreManager.shared.checkEmailExist(email: email) { isChecked in
            switch isChecked {
            case true:
                view.isEmailUsable = false
                DispatchQueue.main.async {
                    view.emailErrorLabel.text = "이미 존재하는 이메일입니다."
                    view.emailErrorLabelHeightAnchor.isActive = false
                    animator.startAnimation()
                }
                view.checkGroup.leave()
            case false:
                view.isEmailUsable = true
                DispatchQueue.main.async {
                    view.emailErrorLabelHeightAnchor.isActive = true
                    animator.startAnimation()
                }
                view.checkGroup.leave()
            }
        }
    }
    
    public func checkEmailNicknameAlert(view: CreateUserViewController) {
        if !view.isEmailUsable || !view.isNickNameUsable {
            let alert = UIAlertController(title: "닉네임 또는 이메일을 다시 작성해주세요.", message: "사용이 불가능하거나 이미 사용중입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
        else if !view.isPasswordUsable {
            let alert = UIAlertController(title: "비밀번호를 다시 작성해주세요.", message: "비밀번호는 8자 이상으로 만들어주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    public func passwordCheck(password: String, view: CreateUserViewController) {
        view.checkGroup.enter()
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) { [weak view] in
            view?.view.layoutIfNeeded()
        }
        guard password.count >= 8 else {
            view.isPasswordUsable = false
            DispatchQueue.main.async {
                view.passwordErrorLabel.text = "8자 이상으로 만들어주세요."
                view.passwordErrorLabelHeightAnchor.isActive = false
                animator.startAnimation()
            }
            view.checkGroup.leave()
            return
        }
        
        guard password.count != 0 else {
            view.isPasswordUsable = false
            DispatchQueue.main.async {
                view.passwordErrorLabelHeightAnchor.isActive = true
                animator.startAnimation()
            }
            view.checkGroup.leave()
            return
        }
        
        view.isPasswordUsable = true
        DispatchQueue.main.async {
            view.passwordErrorLabelHeightAnchor.isActive = true
            animator.startAnimation()
        }
        view.checkGroup.leave()
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
        uploadModalSubject.onNext([SectionOfWordsCell(idx: 0, items: cells)])
    }
    
    public func handleAnimation(height: CGFloat, view: UploadModalViewController) {
        view.handleViewHeightConstraint.constant = height
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) { [weak view] in
            view?.view.layoutIfNeeded()
        }
        if height ==  0.0 {
            view.presenting?.tabBarController?.tabBar.isHidden.toggle()
            animator.addCompletion { [weak view] _ in
                view?.dismiss(animated: false) {
                    NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
                }
            }
        }
        animator.startAnimation()
    }
    
        
    public func grabHandle(recognizer: UIPanGestureRecognizer, view: UploadModalViewController) {        
        switch recognizer.state {
        case .began:
            view.startY = view.handleViewHeightConstraint.constant
        case .changed:
            var y = view.startY - recognizer.translation(in: view.handleArea).y
            if y >= view.maxHeight {
                y = view.maxHeight
            }
            else if y <= view.minHeight {
                y = view.minHeight
            }
            view.handleViewHeightConstraint.constant = y
        case .ended:
            if recognizer.velocity(in: view.handleView).y >= 1550 {
                handleAnimation(height: 0.0, view: view)
            }
        default:
            break
        }
    }
    
    public func uploadVocas(fileIndex: Int, view: UploadModalViewController) {
        let fileName = VocaManager.shared.fileNames[fileIndex]
        VocaManager.shared.loadVocasLocal(fileName: fileName)
        
        // 단어 10개 이상 단어장만 업로드 가능하게 제한
        guard VocaManager.shared.vocas.count >= 10 else {
            let lackVocaAlert = UIAlertController(title: "단어장의 단어수가 부족합니다.", message: "10개 이상의 단어가 있어야합니다.", preferredStyle: .alert)
            lackVocaAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            view.present(lackVocaAlert, animated: true, completion: nil)
            return
        }
        
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
    
    // MARK : - For Profile

    public func didTapLogout(view: WebViewController) {
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
            AuthManager.shared.logoutUser()
            NotificationCenter.default.post(name: NSNotification.Name("StateObserver"), object: nil)
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - For UserWebVocaViewController
    
    public func makeUserUploadSubject() {
        guard let nickName = UserDefaults.standard.value(forKey: "nickname") as? String else {
            return
        }
        getUserLikes { result in
            switch result {
            case .success(let likes):
                FirestoreManager.shared.getWebVocaByWriter(nickName: nickName) {
                    let cells = $0.map {
                        WebCell(date: $0.date, title: $0.title, description: $0.description, writer: $0.writer, like: $0.like, download: $0.download, vocas: $0.vocas, liked: likes.contains(UserDefaults.standard.value(forKey: "email") as! String + " - " + $0.title), email: $0.email)
                    }
                    userUploadVocaSubject.onNext(cells)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func getWebVocasToUserWebView(email: String, title: String, isLiked: Bool, vocas: [Voca], view: UserWebVocaViewController) {
        // 닉네임으로 이메일을 가져와야함.
        VocaManager.shared.vocas = vocas
        VocaManager.shared.examResults = []
        let vc = WebVocaViewController()
        vc.webVocaName = email + " - " + title
        vc.isLiked = isLiked        
        view.navigationController?.pushViewController(vc, animated: true)
    }
}


