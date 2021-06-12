//
//  VocaViewModelList.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift

class VocaViewModelList {
    var vocaSubject = BehaviorSubject<[VocaViewModel]>(value: [])
    let disposeBag = DisposeBag()
    
    init(fileName: String) {
        makeViewModels(fileName: fileName)
    }
    
    /// Load Voca ViewModel
    public func makeViewModels(fileName: String) {
        VocaManager.shared.loadVocas(fileName: fileName)
            .map {
                $0.map {
                    return VocaViewModel(word: $0.word, meaning: $0.meaning)
                }
            }.subscribe(onNext: { [weak self] in
                self?.vocaSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
    
    /// Load ViewModel From VocaData Vocas
    public func makeViewModelsFromVocas() {
        Observable<[Voca]>.just(VocaManager.shared.vocas)
            .map {
                $0.map {
                    return VocaViewModel(word: $0.word, meaning: $0.meaning)
                }
            }.subscribe(onNext: { [weak self] in
                self?.vocaSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
}
