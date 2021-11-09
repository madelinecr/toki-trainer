//
//  FlashCardLessonsView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/8/21.
//

import SwiftUI

struct FlashCardLessonsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(fetchRequest: K.getFlashCardAnswersFetchRequest) var answers: FetchedResults<FlashCardAnswer>
    @FetchRequest(fetchRequest: K.getLessonAnswersFetchRequest) var lessonAnswers: FetchedResults<LessonAnswer>
    
    @ObservedObject var flashCardLessonsVM = FlashCardLessonsViewModel()
    
    @State private var lessonStatistics: [String: Double] = [:]
    @State private var statisticsCalculated = false
    
    func calculateStatistics(_ lesson: TokiLesson) {
        for lessonAnswer in lessonAnswers {
            if lessonAnswer.lesson == lesson.lesson {
                self.lessonStatistics[lesson.lesson] = (Double(lessonAnswer.correctCount) / Double(lessonAnswer.triesCount) * 100)
            }
        }
        self.statisticsCalculated = true
    }
//    func calculateStatistics(_ lesson: TokiLesson) {
//        for answer in answers {
//            wordStatistics[answer.word!] = (Double(answer.correctCount) / Double(answer.triesCount)) * 100
//        }
//
//
//        for word in lesson.words {
//            buildLessonStatistics[lesson.lesson] = []
//            buildLessonStatistics[lesson.lesson]?.append(wordStatistics[word.word]!)
//        }
//
//        for (key, value) in buildLessonStatistics {
//            let sumArray = value.reduce(0, +)
//            let avgArrayValue = sumArray / Double(value.count)
//            lessonStatistics[key] = avgArrayValue
//        }
//
//
////        for word in lesson.words {
////            for answer in answers {
////                if answer.word == word.word {
////                    lessonStatistics[lesson.lesson] = (Double(answer.correctCount) / Double(answer.triesCount)) * 100
////                }
////            }
////        }
//        self.statisticsCalculated = true
//    }
    
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
        NavigationView {
            List(flashCardLessonsVM.lessons, id: \.lesson) { lesson in
                NavigationLink(destination: FlashCardView(lesson: lesson.lesson, passedDictionary: lesson.words)) {
                    Text(lesson.lesson)
                        .bold()
                        .onAppear {
                            calculateStatistics(lesson)
                        }
                    Spacer()
                    if statisticsCalculated && lessonStatistics[lesson.lesson] != nil {
                        Text("\(String(format: "%.0f", lessonStatistics[lesson.lesson]!)) %")
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .navigationBarTitle("Lessons")
        }
    }
}

struct FlashCardLessonsView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardLessonsView()
    }
}
