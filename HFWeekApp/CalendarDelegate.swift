//
//  CalendarPresenter.swift
//  HFWeekApp
//
//  Created by Ilya Puchka on 08.09.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Foundation

class CalendarPresenter: NSObject, MLCalendarViewDelegate {
    
    lazy var calendar: MLCalendarView = {
        let calendar = MLCalendarView()
        calendar.selectionColor = .lightGrayColor()
        calendar.delegate = self
        return calendar
    }()
    
    func didSelectDate(selectedDate: NSDate!) {
        guard let selectedDate = selectedDate else { return }
        let week = HFCalendar.weekForDate(selectedDate)
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func didSelectCurrentWeek() {
        let week = HFCalendar.currentWeek()
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func didSelectNextWeek(week: String) {
        let currentWeek = HFWeek(string: week)!
        let week = currentWeek.nextWeek
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func didSelectPreviousWeek(week: String) {
        let currentWeek = HFWeek(string: week)!
        let week = currentWeek.previousWeek
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }
    
    func updateWeek() {
        let week = HFCalendar.currentWeek()
        calendar.setStartDate(HFCalendar.startDateForWeek(week), endDate: HFCalendar.endDateForWeek(week))
        calendar.setWeek(week.handle)
    }

}