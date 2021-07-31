//
//  ResultCell.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/06/14.
//

import Foundation

class ResultCell {
    let questionWord: String
    let realAnswer: String
    let userAnswer: String
    let score: String
    
    init(questionWord: String, realAnswer: String, userAnswer: String, score: String) {
        self.questionWord = questionWord
        self.realAnswer = realAnswer
        self.userAnswer = userAnswer
        self.score = score
    }
}
