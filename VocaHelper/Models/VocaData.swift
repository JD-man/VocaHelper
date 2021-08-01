//
//  VocaData.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import Foundation

struct VocaData: Codable {    
    var fileName: String
    var vocas: [Voca]
    var examResults: [Int]
}

struct Voca: Codable {
    var idx: Int
    var word: String
    var meaning: String
}

