//
//  WordsViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

class WordsViewModel {
    
    var fileNameSubject = BehaviorSubject<[WordsCell]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        makeViewModels()
    }
    
    func makeViewModels() {
        VocaManager().loadFile()
            .map {
                $0.map {
                    return WordsCell(fileName: $0)
                }
            }.subscribe(onNext: { [weak self] in
                self?.fileNameSubject.onNext($0)
            }).disposed(by: disposeBag)
    }
    
    // 추가버튼 터치시 동작
    func makeNewViewModels(isAddButton: Bool) {
        if isAddButton {
            VocaManager.shared.makeFile()
        }        
        let newWordCell = VocaManager.shared.fileNames
            .map {
                return WordsCell(fileName: $0)
            }
        fileNameSubject.onNext(newWordCell)
    }
}


