//
//  TokiLesson.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/8/21.
//

import Foundation

struct TokiLesson: Decodable {
    var lesson: String
    var words: [TokiDictEntry]
}


