//
//  WordsViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

class WordsViewModel {
    var fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func changeToRealName(fileName: String) -> String {
        return String(fileName[fileName.index(fileName.startIndex, offsetBy: 25) ..< fileName.endIndex])
    }
    
    
    // 단어장 터치시 동작
    func didTapWordButton() {
        print("word button")
    }
    
    // 추가버튼 터치시 동작
    func didTapAddButton() {
        print("add button")
    }
}

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
