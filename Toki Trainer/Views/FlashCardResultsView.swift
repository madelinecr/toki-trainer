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
    
    @ObservedObject var tokiDictionaryViewModel = TokiDictionaryViewModel()

    @State private var wordStatistics: [String: Double] = [:]
    @State private var sortedWordStatistics: [(String, Double)] = []
    @State private var statistics = 0.0
    
    func calculateStatistics() {
        for answer in answers {
            if answer.triesCount > 0 {
                self.wordStatistics[answer.word!] = (Double(answer.correctCount) / Double(answer.triesCount)) * 100
            }
        }
        let sortedStatistics = wordStatistics.sorted {
            return $0.value > $1.value
        }
        self.sortedWordStatistics = sortedStatistics
    }
    
    func calculateBackgroundColor(_ percent: Double) -> Color {
        if percent >= 80 {
            return Color.green
        } else if percent >= 40 {
            return Color.yellow
        } else {
            return Color.red
        }
        
    }

    
    var body: some View {
        List(sortedWordStatistics, id: \.0) { entry in
            HStack {
                Text(entry.0)
                Spacer()
                Text("\(String(format: "%.2f", entry.1)) %")
            }
            .listRowBackground(calculateBackgroundColor(entry.1))
        }
        .onAppear {
            calculateStatistics()
        }
    }
}

extension Double {
    func formatAsPercent(places: Int) -> String {
        let formattedValue = String(format: "%.2f", self)
        return formattedValue
    }
}

struct FlashCardResultView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardResultsView()
    }
}
