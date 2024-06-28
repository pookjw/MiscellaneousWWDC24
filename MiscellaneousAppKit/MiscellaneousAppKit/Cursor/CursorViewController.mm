//
//  CursorViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/27/24.
//

#import "CursorViewController.h"
#import "NSMenuItem+MAPopUpButton.h"
#include <vector>
#include <algorithm>
#import <objc/message.h>
#import <objc/runtime.h>

@interface CursorViewController ()
@property (retain, readonly, nonatomic) NSStackView *stackView;
@property (retain, readonly, nonatomic) NSButton *hideCursorButton;
@property (retain, readonly, nonatomic) NSButton *unhideCursorButton;
@end

@implementation CursorViewController
@synthesize stackView = _stackView;
@synthesize hideCursorButton = _hideCursorButton;
@synthesize unhideCursorButton = _unhideCursorButton;

- (void)dealloc {
    [_stackView release];
    [_hideCursorButton release];
    [_unhideCursorButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDefaultCursorPopUpButtons];
    
    //
    
    NSStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (NSStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    
    [stackView addArrangedSubview:self.hideCursorButton];
    [stackView addArrangedSubview:self.unhideCursorButton];
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (NSButton *)hideCursorButton {
    if (auto hideCursorButton = _hideCursorButton) return hideCursorButton;
    
    NSButton *hideCursorButton = [NSButton buttonWithTitle:@"Hide Cursor" target:self action:@selector(hideCursorButtonDidTrigger:)];
    
    _hideCursorButton = [hideCursorButton retain];
    return hideCursorButton;
}

- (NSButton *)unhideCursorButton {
    if (auto unhideCursorButton = _unhideCursorButton) return unhideCursorButton;
    
    NSButton *unhideCursorButton = [NSButton buttonWithTitle:@"Unhide Cursor" target:self action:@selector(unhideCursorButtonDidTrigger:)];
    
    _unhideCursorButton = [unhideCursorButton retain];
    return unhideCursorButton;
}

- (void)hideCursorButtonDidTrigger:(NSButton *)sender {
    [NSCursor hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSCursor unhide];
    });
}

- (void)unhideCursorButtonDidTrigger:(NSButton *)sender {
    [NSCursor unhide];
}

- (void)addDefaultCursorPopUpButtons {
    // Private Cursor들도 있음
    
    std::vector<SEL> selectors {
        @selector(arrowCursor),
        @selector(contextualMenuCursor),
        @selector(closedHandCursor),
        @selector(crosshairCursor),
        @selector(disappearingItemCursor),
        @selector(dragCopyCursor)
//        @selector(<#selector#>)
    };
    
    std::for_each(selectors.cbegin(), selectors.cend(), [stackView = self.stackView, self](SEL aSelector) {
        NSMenu *menu = [NSMenu new];
        
        //
        
        NSMenuItem *pushMenuItem = [[NSMenuItem alloc] initWithTitle:@"Push" action:@selector(defaultCursorPushMenuItemDidTrigger:) keyEquivalent:@""];
        pushMenuItem.target = self;
        [menu addItem:pushMenuItem];
        [pushMenuItem release];
        
        //
        
        NSMenuItem *setMenuItem = [[NSMenuItem alloc] initWithTitle:@"Set" action:@selector(defaultCursorSetMenuItemDidTrigger:) keyEquivalent:@""];
        setMenuItem.target = self;
        [menu addItem:setMenuItem];
        [setMenuItem release];
        
        //
        
        NSMenuItem *popMenuItem = [[NSMenuItem alloc] initWithTitle:@"Pop" action:@selector(defaultCursorPopMenuItemDidTrigger:) keyEquivalent:@""];
        popMenuItem.target = self;
        [menu addItem:popMenuItem];
        [popMenuItem release];
        
        //
        
        NSPopUpButton *defaultCursorPopUpButton = [NSPopUpButton pullDownButtonWithTitle:NSStringFromSelector(aSelector) menu:menu];
        [menu release];
        
        [stackView addArrangedSubview:defaultCursorPopUpButton];
    });
}

- (NSCursor *)cursorFomMenuItem:(NSMenuItem *)menuItem {
    NSPopUpButton *popUpButton = [menuItem MA_popupButton];
    NSCursor *cursor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSCursor.class, NSSelectorFromString(popUpButton.title));
    
    return cursor;
}

- (void)defaultCursorPushMenuItemDidTrigger:(NSMenuItem *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCursor *cursor = [self cursorFomMenuItem:sender];
        [cursor push];
    });
}

- (void)defaultCursorSetMenuItemDidTrigger:(NSMenuItem *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCursor *cursor = [self cursorFomMenuItem:sender];
        [cursor set];
    });
}

- (void)defaultCursorPopMenuItemDidTrigger:(NSMenuItem *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSCursor *cursor = [self cursorFomMenuItem:sender];
        [cursor pop];
    });
}

//- (void)defaultCursorPullDownButtonDidTrigger:(NSButton *)sender {
//    SEL aSelector = NSSelectorFromString(sender.title);
//    
//    NSCursor *cursor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSCursor.class, aSelector);
//    
////    [cursor push];
//    [cursor set];
//}

@end
