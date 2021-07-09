//
//  WordsViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/11.
//

import Foundation
import RxSwift

class WordsViewModel {
    
    public var fileNameSubject = BehaviorSubject<[SectionOfWordsCell]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        makeViewModels()
    }
    
    public func makeViewModels() {
        VocaManager().loadFile()
            .map {
                $0.map {
                    return WordsCell(identity: $0, fileName: $0)
                }
            }.subscribe(onNext: { [weak self] in
                self?.fileNameSubject.onNext([SectionOfWordsCell(idx: 0, items: $0)])
            }).disposed(by: disposeBag)
    }
    
    // 추가버튼 터치시 동작
    public func makeNewViewModels(isAddButton: Bool) {
        if isAddButton {
            VocaManager.shared.makeFile()
        }
        let newWordCell = VocaManager.shared.fileNames
            .map {
                return WordsCell(identity: $0, fileName: $0)
            }
        fileNameSubject.onNext([SectionOfWordsCell.init(idx: 0, items: newWordCell)])
    }
}


