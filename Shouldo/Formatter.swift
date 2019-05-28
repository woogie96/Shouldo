//
//  Formatter.swift
//  Shouldo
//
//  Created by woogie on 24/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import Foundation

class Formatter {
    static let shared = Formatter()
    
    func dayOfTheWeek() -> String {
        let f = DateFormatter()
        let weekDay = f.weekdaySymbols[Calendar.current.dateComponents(in: TimeZone.autoupdatingCurrent, from: Date()).weekday! - 1]
        let dayOfTheWeek = weekDay[weekDay.startIndex ..< weekDay.index(weekDay.startIndex, offsetBy: 3)].lowercased()
        return dayOfTheWeek
    }
}
