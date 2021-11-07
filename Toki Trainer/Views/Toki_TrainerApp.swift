//
//  Toki_TrainerApp.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/2/21.
//

import SwiftUI

@main
struct Toki_TrainerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //FlashCardView()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
