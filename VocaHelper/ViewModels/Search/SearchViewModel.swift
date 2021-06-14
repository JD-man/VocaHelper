//
//  SearchViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/14.
//

import Foundation
import RxSwift

class SearchViewModel {
    public var searchResultSubject = BehaviorSubject<[String]>(value: [])
    
    public func makeSearchResultSubject(word: String) {
        
        guard let allVocas = VocaManager.shared.allVocasForSearch else {
            return
        }
        
        let filteredResults: [[String]] = allVocas.map { vocadata in
            let vocas = vocadata.vocas
            let mapped = vocas.map { $0.word }.filter { $0.contains(word)}
            return mapped
        }
        
        let flatMapped = filteredResults.flatMap {$0}
        
        // 테스트용
        searchResultSubject.onNext(flatMapped)
    }
}
