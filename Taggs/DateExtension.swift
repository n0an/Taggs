//
//  DateExtension.swift
//  Taggs
//
//  Created by nag on 25/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation

extension Date {
    static func shortStringFromDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        return formatter.string(from: date)
    }
}
