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
        let isDateSame = lhs.title == rhs.title
        let isDescriptionSame = lhs.description == rhs.description
        let isWriterSame = lhs.writer == rhs.writer
        let isDowloadSame = lhs.download == rhs.download
        let isLikeSame = lhs.like == rhs.like
        if isDateSame && isDescriptionSame && isWriterSame && isDowloadSame && isLikeSame
        {
            return true            
        }
        else {
            return false
        }
    }
    
    let date: String
    let title: String
    let description: String
    let writer: String
    let like: Int
    let download: Int
    let vocas: [Voca]
    let liked: Bool
    let email: String
}
