import Foundation

/// HelloFresh-calendar uses ISO8601 with Saturday as a first weekday.
/// The year of the week is the year of this week's Thursday.
class HFCalendar {
    
    private static let calendar: NSCalendar = {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        calendar.firstWeekday = 7 //Saturday
        return calendar
    }()
    
    /// Returns HelloFresh-week for specific date
    static func weekForDate(date: NSDate) -> HFWeek {
        let weekNumber = calendar.component(.WeekOfYear, fromDate: date)
        let yearNumber = calendar.component(.YearForWeekOfYear, fromDate: date)
        return HFWeek(year: yearNumber, week: weekNumber)
    }
    
    /// Returns start date for specific HelloFresh-week
    static func startDateForWeek(week: HFWeek) -> NSDate {
        let components = NSDateComponents()
        components.weekOfYear = week.weekNumber
        components.yearForWeekOfYear = week.year
        components.weekday = 7 //Saturday
        return calendar.dateFromComponents(components)!
    }
    
    static func endDateForWeek(week: HFWeek) -> NSDate {
        let components = NSDateComponents()
        components.weekOfYear = week.weekNumber
        components.weekday = 6 //Friday
        components.yearForWeekOfYear = week.year
        return calendar.dateFromComponents(components)!
    }
    
    /// Returns week after specific HelloFresh-week
    static func weekAfter(week: HFWeek) -> HFWeek {
        let date = startDateForWeek(week)
        let nextWeekDate = calendar.dateByAddingUnit(.WeekOfYear, value: 1, toDate: date, options: [])!
        return weekForDate(nextWeekDate)
    }
    
    /// Returns week before specific HelloFresh-week
    static func weekBefore(week: HFWeek) -> HFWeek {
        let date = startDateForWeek(week)
        let previousWeekDate = calendar.dateByAddingUnit(.WeekOfYear, value: -1, toDate: date, options: [])!
        return weekForDate(previousWeekDate)
    }
    
    static func currentWeek() -> HFWeek {
        return weekForDate(NSDate())
    }
    
    static func week(byAddingWeeks toAdd: Int, toWeek week: HFWeek) -> HFWeek {
        let date = startDateForWeek(week)
        let nextWeekDate = calendar.dateByAddingUnit(.WeekOfYear, value: toAdd, toDate: date, options: [])!
        return weekForDate(nextWeekDate)
    }
    
    static var timeZone: NSTimeZone {
        get {
            return calendar.timeZone
        }
        set {
            calendar.timeZone = newValue
        }
    }
    
}

/// Models HelloFresh week that contains of year and week number.
struct HFWeek {
    
    let year: Int
    let weekNumber: Int
    
    /// Creates week from string. String should be if format <year>-W<week>
    init?(string: String) {
        let components = string.componentsSeparatedByString("-W")
        guard components.count == 2 else { return nil }
        guard let year = Int(components[0]), week = Int(components[1]) else { return nil }
        
        self.init(year: year, week: week)
    }
    
    init(year: Int, week: Int) {
        self.year = max(year, 1)
        self.weekNumber = max(week, 1)
    }
    
    /// Returns week handle in format <year>-W<week>
    var handle: String {
        return String(format: "%04d-W%02d", year, weekNumber)
    }
    
    var nextWeek: HFWeek {
        return HFCalendar.weekAfter(self)
    }
    
    var previousWeek: HFWeek {
        return HFCalendar.weekBefore(self)
    }
    
}

extension HFWeek: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return handle
    }
    var debugDescription: String {
        return handle
    }
}

extension HFWeek: Equatable {}

func ==(lhs: HFWeek, rhs: HFWeek) -> Bool {
    return lhs.year == rhs.year && lhs.weekNumber == rhs.weekNumber
}

extension NSCalendar {
    
    func isDate(date1: NSDate, aDayAfter date2: NSDate) -> Bool {
        return compareDate(date1, toDate: date2, toUnitGranularity: .Day) == .OrderedDescending
    }
    
    func isDateTomorrowOrLater(date1: NSDate) -> Bool {
        return isDate(date1, aDayAfter: NSDate())
    }
    
    func isDate(date1: NSDate, aDayBefore date2: NSDate) -> Bool {
        return compareDate(date1, toDate: date2, toUnitGranularity: .Day) == .OrderedAscending
    }
    
    func isDateYesterdayOrBefore(date1: NSDate) -> Bool {
        return isDate(date1, aDayBefore: NSDate())
    }
    
}

extension NSDate: Comparable {}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}
