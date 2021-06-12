//
//  WordsViewModelList.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift

class WordsViewModelList {
    
    var fileNameSubject = BehaviorSubject<[WordsViewModel]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        makeViewModels()
    }
    
    func makeViewModels() {
        VocaManager().fileLoad()
            .map {
                $0.map {
                    return WordsViewModel(fileName: $0)
                }
            }.subscribe(onNext: { [weak self] in
                self?.fileNameSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
}
