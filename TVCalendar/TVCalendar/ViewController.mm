//
//  ViewController.mm
//  TVCalendar
//
//  Created by Jinwoo Kim on 4/9/25.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <TargetConditionals.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

namespace tvc_NSCollectionLayoutItem {

namespace setContentInsets_ {
void (*original)(NSCollectionLayoutItem *self, SEL _cmd, NSDirectionalEdgeInsets contentInsets);
void custom(NSCollectionLayoutItem *self, SEL _cmd, NSDirectionalEdgeInsets contentInsets) {
    original(self, _cmd, NSDirectionalEdgeInsetsZero);
}
void swizzle() {
    Method method = class_getInstanceMethod([NSCollectionLayoutItem class], @selector(setContentInsets:));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

namespace tvc__UICalendarDateViewCell {

namespace initWithFrame_ {
__kindof UICollectionViewCell * (*original)(__kindof UICollectionViewCell *self, SEL _cmd, CGRect frame);
__kindof UICollectionViewCell * custom(__kindof UICollectionViewCell *self, SEL _cmd, CGRect frame) {
    self = original(self, _cmd, frame);
    
    if (self) {
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self, sel_registerName("_setFocusStyle:"), 1);
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_ensureFocusedFloatingContentView"));
    }
    
    return self;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_UICalendarDateViewCell"), @selector(initWithFrame:));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace canBecomeFocus {
BOOL custom(__kindof UICollectionViewCell *self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_UICalendarDateViewCell"), @selector(canBecomeFocused));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _configureFocusedFloatingContentView_ {
void custom(__kindof UICollectionViewCell *self, SEL _cmd, __kindof UIView *floatingContentView) {
    // nop
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_UICalendarDateViewCell"), sel_registerName("_configureFocusedFloatingContentView:"));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace didUpdateFocusInContext_withAnimationCoordinator_ {

void custom(__kindof UICollectionViewCell *self, SEL _cmd, UIFocusUpdateContext *context, UIFocusAnimationCoordinator *coordinator) {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, context, coordinator);
    
    UILabel *_dayLabel;
    assert(object_getInstanceVariable(self, "_dayLabel", reinterpret_cast<void **>(&_dayLabel)) != NULL);
    
    UIColor *textColor;
    if ([context.nextFocusedView isEqual:self]) {
        textColor = UIColor.blackColor;
    } else {
        textColor = UIColor.labelColor;
    }
    
    _dayLabel.textColor = textColor;
}
void swizzle() {
    assert(class_addMethod(objc_lookUpClass("_UICalendarDateViewCell"), @selector(didUpdateFocusInContext:withAnimationCoordinator:), reinterpret_cast<IMP>(custom), NULL));
}
}

}

namespace tvc_UICalendarView {

//namespace _configureMonthYearSelector {
//void custom(__kindof UIView *self, SEL _cmd) {
//    // nop
//}
//void swizzle() {
//    Method method = class_getInstanceMethod(objc_lookUpClass("UICalendarView"), sel_registerName("_configureMonthYearSelector"));
//    method_setImplementation(method, reinterpret_cast<IMP>(custom));
//}
//}

namespace _updateViewState_animated_ {
void (*original)(__kindof UIView *self, SEL _cmd, NSInteger viewState, BOOL animated);
void custom(__kindof UIView *self, SEL _cmd, NSInteger viewState, BOOL animated) {
    original(self, _cmd, 0, animated);
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("UICalendarView"), sel_registerName("_updateViewState:animated:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

@interface ViewController ()
@end

@implementation ViewController

+ (void)load {
    tvc_NSCollectionLayoutItem::setContentInsets_::swizzle();
    tvc__UICalendarDateViewCell::initWithFrame_::swizzle();
    tvc__UICalendarDateViewCell::canBecomeFocus::swizzle();
    tvc__UICalendarDateViewCell::_configureFocusedFloatingContentView_::swizzle();
    tvc__UICalendarDateViewCell::didUpdateFocusInContext_withAnimationCoordinator_::swizzle();
//    tvc_UICalendarView::_configureMonthYearSelector::swizzle();
    tvc_UICalendarView::_updateViewState_animated_::swizzle();
    
    if (Protocol *UICalendarSelectionSingleDateDelegate = NSProtocolFromString(@"UICalendarSelectionSingleDateDelegate")) {
        assert(class_addProtocol(self, UICalendarSelectionSingleDateDelegate));
    }
}

- (void)loadView {
    __kindof UIView *calendarView = [objc_lookUpClass("UICalendarView") new];
    calendarView.clipsToBounds = YES;
#if !TARGET_OS_TV
    calendarView.backgroundColor = UIColor.systemBackgroundColor;
#endif
    
    id selectionBehavior = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UICalendarSelectionSingleDate") alloc], sel_registerName("initWithDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(calendarView, sel_registerName("setSelectionBehavior:"), selectionBehavior);
    [selectionBehavior release];
    
    UICollectionView *collectionView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(calendarView, sel_registerName("collectionView"));
    assert(collectionView != nil);
    
    
    self.view = calendarView;
    [calendarView release];
}

- (BOOL)dateSelection:(id)selection canSelectDate:(NSDateComponents *)dateComponents {
    return YES;
}

- (void)dateSelection:(id)selection didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"%@", dateComponents);
}

@end
