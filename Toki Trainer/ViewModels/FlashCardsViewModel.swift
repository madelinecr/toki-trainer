//
//  FlashCardsViewModel.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/6/21.
//

import Foundation

class FlashCardsViewModel: ObservableObject {

    let jsonLoader = TokiJSONLoader()
    
    private var fullDictionary: [TokiDictEntry] = []
    @Published var randomDictionary: [TokiDictEntry] = []
    
    init() {
        if let safeDictionary = jsonLoader.loadDictionary() {
            fullDictionary = safeDictionary
            randomDictionary = safeDictionary
            //randomDictionary.shuffle()
        }
    }
    
}
