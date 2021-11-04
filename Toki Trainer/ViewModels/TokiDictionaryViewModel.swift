//
//  TokiDictionaryViewModel.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/4/21.
//

import Foundation

class TokiDictionaryViewModel: ObservableObject
{
    let jsonLoader: TokiJSONLoader = TokiJSONLoader()
    
    @Published var dictionary: [TokiDictEntry] = []
    @Published var partsOfSpeech: [TokiPartOfSpeech] = []
    
    init() {
        if let safeDictionary = jsonLoader.loadDictionary() {
            dictionary = safeDictionary
        }
        if let safePartsOfSpeech = jsonLoader.loadPOS() {
            partsOfSpeech = safePartsOfSpeech
        }
    }
}
