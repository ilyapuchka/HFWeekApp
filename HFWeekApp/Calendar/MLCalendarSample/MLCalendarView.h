//
//  MLCalendarPopup.h
//  ModernLookOSX
//
//  Created by András Gyetván on 2015. 03. 08..
//  Copyright (c) 2015. DroidZONE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MLCalendarViewDelegate <NSObject>
- (void) didSelectDate:(NSDate*)selectedDate;

- (void) didSelectCurrentWeek;
- (void) didSelectNextWeek:(NSString *)week;
- (void) didSelectPreviousWeek:(NSString *)week;

@end

@interface MLCalendarView : NSViewController
@property (nonatomic, copy) NSColor* backgroundColor;
@property (nonatomic, copy) NSColor* textColor;
@property (nonatomic, copy) NSColor* selectionColor;
@property (nonatomic, copy) NSColor* todayMarkerColor;
@property (nonatomic, copy) NSColor* dayMarkerColor;

@property (nonatomic,weak) id<MLCalendarViewDelegate> delegate;

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSDate* selectedDate;

+ (BOOL) isSameDate:(NSDate*)d1 date:(NSDate*)d2;

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (void)setWeek:(NSString *)week;


@end
