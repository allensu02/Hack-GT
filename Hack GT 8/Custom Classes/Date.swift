//
//  Date.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/23/21.
//

import Foundation

struct Date {
    var year: Int
    var month: Int
    var day: Int
    
    func toMonthDayString() -> String {
        return addZeros(num: month) + "/" + addZeros(num: day)
    }
    
    func toMDYString() -> String {
        return "\(addZeros(num: month))/\(addZeros(num: day))/\(year)"

    }
    
    func addZeros(num: Int) -> String{
        var ret = ""
        if (num < 10) {
            ret = "0\(num)"
        } else {
            ret = "\(num)"
        }
        return ret
    }
}
