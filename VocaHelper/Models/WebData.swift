//
//  WebData.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/09.
//

import Foundation

struct WebData: Codable {
    let date: String
    let title: String
    let description: String
    let writer: String
    let like: String
    let download: String
    let vocas: [Voca]
    
    enum CodingKeys: String, CodingKey {
        case date
        case title
        case description
        case writer
        case like
        case download
        case vocas
    }
}
