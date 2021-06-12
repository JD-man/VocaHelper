//
//  VocaData.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import Foundation

struct VocaData: Codable {
    // 테스트
    var vocas: [Voca]
}

struct Voca: Codable {    
    var word: String
    var meaning: String
}

