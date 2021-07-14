//
//  WebCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/14.
//

import Foundation

struct WebCell: Equatable {
    static func == (lhs: WebCell, rhs: WebCell) -> Bool {
        // 불러온 단어장들이 이전에 불러온 단어장과 다른지 확인하기 위해 추가된 Equatable 프로토콜
        // WebViewModel의 distinctUntilChanged를 사용하기 위해 추가됨.
        // 업로드된 단어장의 이름으로 같은 단어장인지 여부를 확인한다.
        let leftWebVocaName = lhs.writer + " - " + lhs.title
        let rightWebVocaName = rhs.writer + " - " + rhs.title
        if leftWebVocaName == rightWebVocaName { return true}
        else { return false }
    }
    
    let date: String
    let title: String
    let description: String
    let writer: String
    let like: Int
    let download: Int
    let vocas: [Voca]
    let liked: Bool
}
