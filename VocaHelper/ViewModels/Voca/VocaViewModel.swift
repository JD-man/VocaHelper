//
//  VocaViewModel.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift

class VocaViewModel {
    var id: Int
    var word: String
    var meaning: String
    
    init (id: Int, word: String, meaning: String) {
        self.id = id
        self.word = word
        self.meaning = meaning
    }
    
    func didTapCell() {
        
    }
}
