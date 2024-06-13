//
//  CalendarViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()
@property (readonly, nonatomic) UICalendarView *calendarView;
@end

@implementation CalendarViewController

- (void)loadView {
    UICalendarView *calendarView = [UICalendarView new];
    self.view = calendarView;
    [calendarView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (UICalendarView *)calendarView {
    return (UICalendarView *)self.view;
}

@end
