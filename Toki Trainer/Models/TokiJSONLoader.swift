//
//  TokiJSONLoader.swift
//  TokiJSONLoader
//
//  Created by Avery Ada Pace on 10/1/21.
//

import Foundation

class TokiJSONLoader: ObservableObject {
    @Published var dictionary: [TokiDictEntry] = []
    @Published var partsOfSpeech: [TokiPartOfSpeech] = []
    
    func loadDictionary() {
        let jsonData = loadJSON("toki-dictionary")
        do {
            let decodedData = try JSONDecoder().decode([TokiDictEntry].self, from: jsonData!)
            dictionary = decodedData
        } catch {
            print("Decode error: \(error)")
            return
        }
    }
    
    func loadPOS() {
        let jsonData = loadJSON("toki-partsofspeech")
        do {
            let decodedData = try JSONDecoder().decode([TokiPartOfSpeech].self, from: jsonData!)
            partsOfSpeech = decodedData
        } catch {
            print("Decode error: \(error)")
            return
        }
    }
    
    func loadJSON(_ resource: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: resource, ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
}
