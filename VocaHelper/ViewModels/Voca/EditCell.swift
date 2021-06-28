//
//  VocaViewModelList.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/12.
//

import Foundation
import RxSwift
import RxDataSources

struct EditCell: Equatable, IdentifiableType{
    typealias Identity = Int
    var identity: Int
    
    var word: String
    var meaning: String
}

struct SectionOfEditCell {
    var idx: Int
    var items: [Item]
}

extension SectionOfEditCell: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item = EditCell
    
    var identity: Int {
        return idx
    }
    
    init(original: SectionOfEditCell, items: [EditCell]) {
        self = original
        self.items = items
    }
}
