//
//  WordsViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

class WordsViewModel {
    
    var fileNameSubject = BehaviorSubject<[SectionOfWordsCell]>(value: [])
    let disposeBag = DisposeBag()
    
    init() {
        makeViewModels()
    }
    
    func makeViewModels() {
        var idx: Int = -1
        VocaManager().loadFile()
            .map {
                $0.map {
                    idx += 1
                    return WordsCell(identity: idx, fileName: $0)
                }
            }.subscribe(onNext: { [weak self] in
                self?.fileNameSubject.onNext([SectionOfWordsCell.init(idx: 0, items: $0)])
            }).disposed(by: disposeBag)
    }
    
    // 추가버튼 터치시 동작
    func makeNewViewModels(isAddButton: Bool) {
        var idx: Int = -1
        if isAddButton {
            VocaManager.shared.makeFile()
        }
        
        let newWordCell = VocaManager.shared.fileNames
            .map { fileName -> WordsCell in
                idx += 1
                return WordsCell(identity: idx, fileName: fileName)
            }
        fileNameSubject.onNext([SectionOfWordsCell.init(idx: 0, items: newWordCell)])
    }
}


