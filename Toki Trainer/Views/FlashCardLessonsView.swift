//
//  FlashCardLessonsView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/8/21.
//

import SwiftUI

struct FlashCardLessonsView: View {
    @ObservedObject var flashCardLessonsVM = FlashCardLessonsViewModel()
    
    var body: some View {
        NavigationView {
            List(flashCardLessonsVM.lessons, id: \.lesson) { lesson in
                NavigationLink(destination: FlashCardView(lesson.words)) {
                    Text(lesson.lesson)
                        .bold()
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
