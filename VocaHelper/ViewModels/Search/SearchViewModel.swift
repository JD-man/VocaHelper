//
//  SearchViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/14.
//

import Foundation
import RxSwift

class SearchViewModel {
    public var searchResultSubject = BehaviorSubject<[Voca]>(value: [])
    
    public func makeSearchResultSubject(word: String) {
        
        guard let allVocas = VocaManager.shared.allVocasForSearch else {
            return
        }
        
        let filteredResults: [Voca] = allVocas.map { $0.vocas.filter { $0.word.contains(word) } }.flatMap {$0}
        
        // 테스트용
        searchResultSubject.onNext(filteredResults)
    }
}
