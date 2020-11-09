//
//  Mood.swift
//  MoodTracker
//
//  Created by Frank Novello on 11/8/20.
//

import Foundation

class Mood {
    static var moodId: Int = 0;
    var moodValue: Double = 0.0;
    var moodNote: String = "";
    var moodDate = Date()
    var time = TimeInterval()
    
    init(submitMoodWithValue moodValue: Double, moodNote: String, moodDate:Date) {
        Mood.moodId += 1
        self.moodValue      = moodValue
        self.moodNote       = moodNote
        self.moodDate       = moodDate
    }
    
    
}
