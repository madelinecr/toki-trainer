//
//  FlashCardResultView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/7/21.
//

import SwiftUI

struct FlashCardResultsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity:FlashCardAnswer.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FlashCardAnswer.word, ascending: false)], predicate: NSPredicate(format: "word == %@", "a")) var flashCardAnswers: FetchedResults<FlashCardAnswer>

    @State private var statistics = 0.0
    
    func calculateStatistics() {
        print("count: \(flashCardAnswers.count)")
        for answer in flashCardAnswers {
            if answer.triesCount != 0 {
                print("word: \(answer.word)")
                print("tries: \(answer.triesCount)")
                print("correct: \(answer.correctCount)")
                self.statistics = Double(answer.correctCount) / Double(answer.triesCount)
            }
        }
    }
    
//    func calculateStatistics() {
//        var correctAnswers = 0
//        for answer in flashCardAnswers {
//            if answer.correct {
//                correctAnswers += 1
//            }
//            self.statistics = Double(correctAnswers) / Double(flashCardAnswers.count)
//        }
//    }
    
    var body: some View {
        Text("Percentage: \(statistics)")
            .onAppear {
                calculateStatistics()
            }
    }
}

struct FlashCardResultView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardResultsView()
    }
}
