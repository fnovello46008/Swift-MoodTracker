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
    var moodNote: String?;
    var moodDate = Date()
    var time = TimeInterval()
    var isSelected: Bool = false
    
    struct CoordinateValues {
        var x:Double = 0.0
        var y:Double = 0.0
    }
    
    var coords = CoordinateValues(x: 0, y: 0)
    
    init(submitMoodWithValue moodValue: Double, moodDate:Date, coords:CoordinateValues) {
        Mood.moodId += 1
        self.moodValue      = moodValue
        self.moodDate       = moodDate
        self.coords         = coords
    }
    
    func getMood(AtCoordinate x: Double, y: Double) -> Mood?
    {
        
        if(coords.x == x && coords.y == y)
        {
            return self
        }
        
        return nil
    }
    func setMood(AtCoordinate x: Double, y: Double)
    {
        self.coords.x = x
        self.coords.y = y
    }
    
}
