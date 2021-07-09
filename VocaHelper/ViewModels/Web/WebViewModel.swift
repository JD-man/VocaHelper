//
//  WebViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/09.
//

import Foundation
import RxSwift

struct WebViewModel {
    
    public var webDataSubject = BehaviorSubject<[WebData]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        makeWebDataSubject()
    }
    
    private func makeWebDataSubject() {
        FirestoreManager.shared.getData {
            webDataSubject.onNext($0)
        }
    }
    
    public func getWebVocas(vocas: [Voca], view: WebViewController) {
        VocaManager.shared.vocas = vocas
        let vc = WebVocaViewController()
        view.navigationController?.pushViewController(vc, animated: true)
    }
}
