//
//  CursorViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/27/24.
//

#import "CursorViewController.h"
#import "NSMenuItem+MAPopUpButton.h"
#import "AnimatedCursor.h"
#include <vector>
#include <algorithm>
#import <objc/message.h>
#import <objc/runtime.h>

/*
 Push A -> Set B -> Set C -> Set D -> Pop하면 다 날라감
 Push A -> Push B -> Set C -> Pop하면 A로 돌아옴
 
 Push : Stack을 새로 만들고 Set을 함
 Set : 현재 Stack에 새로 추가함
 Pop : Stack 초기화
 */

@interface CursorViewController ()
@property (retain, readonly, nonatomic) NSStackView *stackView;
@property (retain, readonly, nonatomic) NSButton *hideCursorButton;
@property (retain, readonly, nonatomic) NSButton *unhideCursorButton;
@property (retain, readonly, nonatomic) NSButton *hideUntilMouseMovesButton;
@property (retain, readonly, nonatomic) NSButton *pushAnimatedCursorButton;
@end

@implementation CursorViewController
@synthesize stackView = _stackView;
@synthesize hideCursorButton = _hideCursorButton;
@synthesize unhideCursorButton = _unhideCursorButton;
@synthesize hideUntilMouseMovesButton = _hideUntilMouseMovesButton;
@synthesize pushAnimatedCursorButton = _pushAnimatedCursorButton;

- (void)dealloc {
    [_stackView release];
    [_hideCursorButton release];
    [_unhideCursorButton release];
    [_hideUntilMouseMovesButton release];
    [_pushAnimatedCursorButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCursorButtons];
    
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
    [stackView addArrangedSubview:self.hideUntilMouseMovesButton];
    [stackView addArrangedSubview:self.pushAnimatedCursorButton];
    
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

- (NSButton *)hideUntilMouseMovesButton {
    if (auto hideUntilMouseMovesButton = _hideUntilMouseMovesButton) return hideUntilMouseMovesButton;
    
    NSButton *hideUntilMouseMovesButton = [NSButton buttonWithTitle:@"Hide Until Mouse Moves" target:self action:@selector(hideUntilMouseMovesButtonDidTrigger:)];
    
    _hideUntilMouseMovesButton = [hideUntilMouseMovesButton retain];
    return hideUntilMouseMovesButton; 
}

- (NSButton *)pushAnimatedCursorButton {
    if (auto pushAnimatedCursorButton = _pushAnimatedCursorButton) return pushAnimatedCursorButton;
    
    NSButton *pushAnimatedCursorButton = [NSButton buttonWithTitle:@"Set White Cursor" image:[NSImage imageNamed:@"white_cursor"] target:self action:@selector(pushAnimatedCursorButtonDidTrigger:)];
    
    _pushAnimatedCursorButton = [pushAnimatedCursorButton retain];
    return pushAnimatedCursorButton;
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

- (void)hideUntilMouseMovesButtonDidTrigger:(NSButton *)sender {
    [NSCursor setHiddenUntilMouseMoves:YES];
}

- (void)pushAnimatedCursorButton:(NSButton *)sender {
    
}

- (void)addCursorButtons {
    std::vector<SEL> selectors {
        @selector(arrowCursor),
        @selector(contextualMenuCursor),
        @selector(closedHandCursor),
        @selector(crosshairCursor),
        @selector(disappearingItemCursor),
        @selector(dragCopyCursor),
        @selector(dragLinkCursor),
        @selector(IBeamCursor),
        @selector(openHandCursor),
        @selector(operationNotAllowedCursor),
        @selector(pointingHandCursor),
        @selector(IBeamCursorForVerticalLayout),
        @selector(columnResizeCursor),
        @selector(rowResizeCursor),
        @selector(zoomInCursor),
        @selector(zoomOutCursor),
        sel_registerName("_helpCursor")
    };
    
    std::for_each(selectors.cbegin(), selectors.cend(), [stackView = self.stackView, self](SEL aSelector) {
        NSCursor *cursor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSCursor.class, aSelector);
        
        NSStackView *horizontalStackView = [NSStackView new];
        horizontalStackView.alignment = NSLayoutAttributeCenterY;
        horizontalStackView.orientation = NSUserInterfaceLayoutOrientationHorizontal;
        
        //
        
        NSImage *image = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(cursor, sel_registerName("image"));
        
        NSButton *pushButton = [NSButton buttonWithTitle:[NSString stringWithFormat:@"%s (push)", sel_getName(aSelector)] image:image target:cursor action:@selector(push)];
        
        NSButton *setButton = [NSButton buttonWithTitle:[NSString stringWithFormat:@"%s (set)", sel_getName(aSelector)] image:image target:cursor action:@selector(set)];
        
        // +[NSCursor pop]와 -[NSCursor pop]은 같음
        NSButton *popButton = [NSButton buttonWithTitle:[NSString stringWithFormat:@"%s (pop)", sel_getName(aSelector)] image:image target:cursor action:@selector(pop)];
        
        [horizontalStackView addArrangedSubview:pushButton];
        [horizontalStackView addArrangedSubview:setButton];
        [horizontalStackView addArrangedSubview:popButton];
        
        //
        
        [stackView addArrangedSubview:horizontalStackView];
        [horizontalStackView release];
    });
}

- (NSCursor *)cursorFomMenuItem:(NSMenuItem *)menuItem {
    NSPopUpButton *popUpButton = [menuItem MA_popupButton];
    NSCursor *cursor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSCursor.class, NSSelectorFromString(popUpButton.title));
    
    return cursor;
}

- (void)pushAnimatedCursorButtonDidTrigger:(NSButton *)sender {
    AnimatedCursor *cursor = [AnimatedCursor new];
    [cursor push];
    [cursor release];
}

@end
