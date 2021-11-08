//
//  FlashCardLessonsViewModel.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/8/21.
//

import Foundation

class FlashCardLessonsViewModel: ObservableObject {

    let jsonLoader: TokiJSONLoader = TokiJSONLoader()
    
    @Published var lessons: [TokiLesson] = []
    
    
    init() {
        if let safeLessons = jsonLoader.loadLessons() {
            lessons = safeLessons
        }
    }
}
