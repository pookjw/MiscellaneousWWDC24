//
//  CalendarViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import "CalendarViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface CustomCalendarView : UICalendarView
@end
@implementation CustomCalendarView

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths point:(CGPoint)point {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        NSMutableArray<UIMenuElement *> *children = [suggestedActions mutableCopy];
        
        [children addObject:[UIAction actionWithTitle:@"Test" image:[UIImage systemImageNamed:@"heart.circle.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }]];
        
        UIMenu *menu = [UIMenu menuWithChildren:children];
        [children release];
        
        return menu;
    }];
}

@end

@class CustomCalendarSelection;
@protocol CustomCalendarSelectionDelegate <NSObject>
@end

// TODO: didChangeCalendar:, didChangeAvailableDateRange:, so on...
@interface CustomCalendarSelection : UICalendarSelection
@property (weak, readonly, nonatomic) id<CustomCalendarSelectionDelegate> delegate;
@end

@implementation CustomCalendarSelection

- (UICalendarView *)view {
    objc_super superInfo = { self, [self class] };
    return ((id (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
}

- (instancetype)initWithDelegate:(id<CustomCalendarSelectionDelegate>)delegate {
    objc_super superInfo = { self, [self class] };
    self = ((id (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, sel_registerName("_init"));
    
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

- (BOOL)highlightsToday {
    return YES;
}

- (BOOL)renderOverhangDays {
    return YES; // 이번/다음 달 날짜도 보여줄지
}

- (BOOL)canSelectDate:(NSDateComponents *)date {
    return YES;
}

- (BOOL)shouldDeselectDate:(NSDateComponents *)date {
    return NO;
}

- (void)didSelectDate:(NSDateComponents *)dateComponents {
    UICalendarView *calendarView = [self view];
    UICollectionView *collectionView = ((id (*)(id, SEL))objc_msgSend)(calendarView, sel_registerName("collectionView"));
    
    NSArray<NSIndexPath *> *indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems;
    if (indexPathsForSelectedItems.count > 0) {
        UICollectionViewDiffableDataSource *_dataSource;
        object_getInstanceVariable(calendarView, "_dataSource", (void **)&_dataSource);
        
        NSMutableArray<NSDateComponents *> *selectedDateComponentsArray = [[NSMutableArray alloc] initWithCapacity:indexPathsForSelectedItems.count];
        
        for (NSIndexPath *indexPath in indexPathsForSelectedItems) {
            /* _UIDatePickerCalendarDay */
            id itemIdentifier = [_dataSource itemIdentifierForIndexPath:indexPath];
            NSDateComponents *selectedDateComponents = ((id (*)(id, SEL))objc_msgSend)(itemIdentifier, sel_registerName("components"));
            [selectedDateComponentsArray addObject:selectedDateComponents];
        }
        
        ((void (*)(id, SEL, id, BOOL))objc_msgSend)(calendarView, sel_registerName("_deselectDates:animated:"), selectedDateComponentsArray, YES);
        [selectedDateComponentsArray release];
    }
    
    //
    
    NSCalendar *calendar = calendarView.calendar;
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    
    NSMutableArray<NSDateComponents *> *dateComponentsArray = [[NSMutableArray alloc] initWithCapacity:7];
    [dateComponentsArray addObject:dateComponents];
    
    for (NSInteger i = 1; i < 7; i++) {
        NSDate *addedDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:selectedDate options:0];
        NSDateComponents *addedDateComponents = [calendar components:0x10001e fromDate:addedDate];
        [dateComponentsArray addObject:addedDateComponents];
    }
    
    ((void (*)(id, SEL, id, BOOL))objc_msgSend)(self.view, sel_registerName("_selectDates:animated:"), dateComponentsArray, YES);
    [dateComponentsArray release];
}

- (void)didDeselectDate:(NSDateComponents *)date {
    
}

- (void)selectAllDatesAnimated:(BOOL)animated {
    
}

- (void)didMoveToCalendarView {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(self.view, sel_registerName("setAllowsMultipleSelection:"), YES);
}

@end

@interface CalendarViewController () <UICalendarSelectionSingleDateDelegate, UICalendarSelectionMultiDateDelegate, UICalendarSelectionWeekOfYearDelegate, CustomCalendarSelectionDelegate, UICalendarViewDelegate>
@property (readonly, nonatomic) UICalendarView *calendarView;
@end

@implementation CalendarViewController

- (void)loadView {
    CustomCalendarView *calendarView = [CustomCalendarView new];
    calendarView.delegate = self;
    
//    UICalendarSelectionSingleDate *selectionBehavior = [[UICalendarSelectionSingleDate alloc] initWithDelegate:self];
//    UICalendarSelectionMultiDate *selectionBehavior = [[UICalendarSelectionMultiDate alloc] initWithDelegate:self];
//    UICalendarSelectionWeekOfYear *selectionBehavior = [[UICalendarSelectionWeekOfYear alloc] initWithDelegate:self];
    CustomCalendarSelection *selectionBehavior = [[CustomCalendarSelection alloc] initWithDelegate:self];
    
    calendarView.selectionBehavior = selectionBehavior;
    [selectionBehavior release];
    
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

- (BOOL)dateSelection:(UICalendarSelectionSingleDate *)selection canSelectDate:(NSDateComponents *)dateComponents {
    return YES;
}

- (void)dateSelection:(UICalendarSelectionSingleDate *)selection didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"%@", dateComponents);
}

- (BOOL)multiDateSelection:(UICalendarSelectionMultiDate *)selection canSelectDate:(NSDateComponents *)dateComponents {
    return YES;
}

- (BOOL)multiDateSelection:(UICalendarSelectionMultiDate *)selection canDeselectDate:(NSDateComponents *)dateComponents {
    return YES;
}

- (void)multiDateSelection:(UICalendarSelectionMultiDate *)selection didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"%@", dateComponents);
}

- (void)multiDateSelection:(UICalendarSelectionMultiDate *)selection didDeselectDate:(NSDateComponents *)dateComponents {
    NSLog(@"%@", dateComponents);
}

- (void)weekOfYearSelection:(UICalendarSelectionWeekOfYear *)selection didSelectWeekOfYear:(NSDateComponents *)weekOfYearComponents {
    NSLog(@"%@", weekOfYearComponents);
}

- (UICalendarViewDecoration *)calendarView:(UICalendarView *)calendarView decorationForDateComponents:(NSDateComponents *)dateComponents {
    return [UICalendarViewDecoration decorationWithImage:[UIImage systemImageNamed:@"heart.fill"] color:UIColor.systemPinkColor size:UICalendarViewDecorationSizeLarge];
}

- (void)calendarView:(UICalendarView *)calendarView didChangeVisibleDateComponentsFrom:(NSDateComponents *)previousDateComponents {
    NSLog(@"%@", previousDateComponents);
}

@end
