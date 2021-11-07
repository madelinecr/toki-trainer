//
//  FlashCardResultView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/7/21.
//

import SwiftUI

struct FlashCardResultsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(fetchRequest: K.getFlashCardAnswersFetchRequest) var answers: FetchedResults<FlashCardAnswer>

    @State private var statistics = 0.0
    
    func calculateStatistics() {
        for answer in answers {
            if answer.triesCount != 0 {
                print("word: \(answer.word)")
                print("tries: \(answer.triesCount)")
                print("correct: \(answer.correctCount)")
                self.statistics = Double(answer.correctCount) / Double(answer.triesCount)
            }
        }
    }

    
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
