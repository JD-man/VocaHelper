//
//  VocaViewModelList.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift

class EditCell {    
    var word: String
    var meaning: String
    
    init (word: String, meaning: String) {
        self.word = word
        self.meaning = meaning
    }
}
