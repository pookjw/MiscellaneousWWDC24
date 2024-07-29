//
//  UserDefaults.swift
//  MyTimer
//
//  Created by Jinwoo Kim on 7/29/24.
//

import Foundation

extension UserDefaults {
    static var appGroup: UserDefaults {
        .init(suiteName: "group.com.pookjw.EmojiRangers")!
    }
    
    var timerStartDate: Date? {
        object(forKey: "timerStartDate") as? Date
    }
    
    var timerEndDate: Date? {
        object(forKey: "timerEndDate") as? Date
    }
}
