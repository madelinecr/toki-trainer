//
//  Constants.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/2/21.
//

import Foundation
import UIKit
import CoreData

struct K {
    static let posColors = [
        "n": UIColor.systemGreen,
        "mod": UIColor.systemYellow,
        "sep": UIColor.systemPurple,
        "vt": UIColor.systemBlue,
        "vi": UIColor.systemCyan,
        "interj": UIColor.systemRed,
        "prep": UIColor.systemBrown,
        "conj": UIColor.systemBrown,
        "kama": UIColor.systemBrown,
        "cont": UIColor.systemBrown,
        "oth": UIColor.systemBrown,
        "extra": UIColor.systemBrown
    ]
    
    static var getFlashCardAnswersFetchRequest: NSFetchRequest<FlashCardAnswer> {
        let request: NSFetchRequest<FlashCardAnswer> = FlashCardAnswer.fetchRequest()
        request.sortDescriptors = []
        
        return request
    }
    
    static var getFlashCardAnswersWithPredicateFetchRequest: NSFetchRequest<FlashCardAnswer> {
        let request: NSFetchRequest<FlashCardAnswer> = FlashCardAnswer.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "word == %@", "a")
        
        return request
    }
}
