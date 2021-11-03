//
//  TokiDictionary.swift
//  TokiDictionary
//
//  Created by Avery Ada Pace on 10/1/21.
//

import Foundation

struct TokiDictEntry: Decodable {
    var word: String
    var definitions: [TokiDictDefinition]
}

struct TokiDictDefinition: Decodable {
    var pos: String
    var definition: String
}

