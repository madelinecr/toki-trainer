//
//  TokiDictionaryViewModel.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/4/21.
//

import Foundation

class TokiDictionaryViewModel: ObservableObject {
    
    let jsonLoader: TokiJSONLoader = TokiJSONLoader()
    
    private var fullDictionary: [TokiDictEntry] = []
    private var fullPartsOfSpeech: [TokiPartOfSpeech] = []
    
    @Published var dictionary: [TokiDictEntry] = []
    @Published var partsOfSpeech: [TokiPartOfSpeech] = []
    
    init() {
        if let safeDictionary = jsonLoader.loadDictionary() {
            dictionary = safeDictionary
            fullDictionary = safeDictionary
        }
        if let safePartsOfSpeech = jsonLoader.loadPOS() {
            partsOfSpeech = safePartsOfSpeech
            fullPartsOfSpeech = safePartsOfSpeech
        }
    }
    
    func filterDictionary(_ input: String) {
        dictionary = []
        if(input.isEmpty) {
            dictionary = fullDictionary
        } else {
            let capturePattern = #"(\w+)"#
            let captures = self.searchStringForRegex(string: input, regex: capturePattern)
            for capture in captures {
                print(capture)
                for value in fullDictionary {
                    if value.word == capture {
                        dictionary.append(value)
                    }
                }
            }
        }
    }
    
    func searchStringForRegex(string: String, regex: String) -> [String] {
        let lowerCaseString = string.lowercased()
        let strRange = NSRange(lowerCaseString.startIndex..<lowerCaseString.endIndex, in: lowerCaseString)
        let nameRegex = try! NSRegularExpression(pattern: regex, options: [])
        
        let results = nameRegex.matches(in: lowerCaseString, options: [], range: strRange)
        
        return results.map {
            String(lowerCaseString[Range($0.range, in: lowerCaseString)!])
        }
    }
}
