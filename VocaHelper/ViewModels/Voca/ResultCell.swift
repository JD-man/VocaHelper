//
//  ResultCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/14.
//

import Foundation

class ResultCell {
    let realAnswer: String
    let userAnswer: String
    let score: String
    
    init(realAnswer: String, userAnswer: String, score: String) {
        self.realAnswer = realAnswer
        self.userAnswer = userAnswer
        self.score = score
    }
}
