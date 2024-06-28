//
//  PopUpButtonsViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/27/24.
//

#import "PopUpButtonsViewController.h"
#import "NSMenuItem+MAPopUpButton.h"
#import <objc/message.h>
#import <objc/runtime.h>

// popUpButton의 경우 Menu Item이 선택되면 -[NSPopUpButtonCell setMenuItem:]이 호출되면서 Title이 바뀜
@interface PopUpButtonsViewController ()
@property (retain, readonly, nonatomic) NSStackView *stackView;
@property (retain, readonly, nonatomic) NSPopUpButton *popUpButton;
@property (retain, readonly, nonatomic) NSPopUpButton *popUpButton2;
@property (retain, readonly, nonatomic) NSPopUpButton *pullDownButton;
@property (retain, readonly, nonatomic) NSPopUpButton *pullDownButton2;
@end

@implementation PopUpButtonsViewController
@synthesize stackView = _stackView;
@synthesize popUpButton = _popUpButton;
@synthesize popUpButton2 = _popUpButton2;
@synthesize pullDownButton = _pullDownButton;
@synthesize pullDownButton2 = _pullDownButton2;

- (void)dealloc {
    [_stackView release];
    [_popUpButton release];
    [_popUpButton2 release];
    [_pullDownButton release];
    [_pullDownButton2 release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [stackView addArrangedSubview:self.popUpButton];
    [stackView addArrangedSubview:self.popUpButton2];
    [stackView addArrangedSubview:self.pullDownButton];
    [stackView addArrangedSubview:self.pullDownButton2];
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (NSPopUpButton *)popUpButton {
    if (auto popUpButton = _popUpButton) return popUpButton;
    
    NSMenu *menu = [self makeMenu];
    
    NSPopUpButton *popUpButton = [NSPopUpButton popUpButtonWithMenu:menu target:self action:@selector(popUpButtonDidTrigger:)];
    
    // -validateMenuItem:
    popUpButton.autoenablesItems = YES;
    
    popUpButton.altersStateOfSelectedItem = YES;
    popUpButton.usesItemFromMenu = NO;
    
    _popUpButton = [popUpButton retain];
    return popUpButton;
}

- (NSPopUpButton *)popUpButton2 {
    if (auto popUpButton2 = _popUpButton2) return popUpButton2;
    
    NSMenu *menu = [self makeMenu];
    
    NSPopUpButton *popUpButton2 = [NSPopUpButton popUpButtonWithMenu:menu target:self action:@selector(popUpButton2DidTrigger:)];
//    NSPopUpButton *popUpButton2 = [NSPopUpButton pullDownButtonWithTitle:@"Title" menu:menu];
    
    // -validateMenuItem:
    popUpButton2.autoenablesItems = YES;
    
    popUpButton2.altersStateOfSelectedItem = YES;
    popUpButton2.usesItemFromMenu = YES;
    
    _popUpButton2 = [popUpButton2 retain];
    return popUpButton2;
}

- (NSPopUpButton *)pullDownButton {
    if (auto pullDownButton = _pullDownButton) return pullDownButton;
    
    NSMenu *menu = [self makeMenu];
    
    NSPopUpButton *pullDownButton = [NSPopUpButton pullDownButtonWithTitle:@"PullDown" image:[NSImage imageWithSystemSymbolName:@"eraser" accessibilityDescription:nil] menu:menu];
    pullDownButton.altersStateOfSelectedItem = NO;
    pullDownButton.usesItemFromMenu = YES;
    
    pullDownButton.menu = menu;
//    [pullDownButton selectItem:nil];
    
    _pullDownButton = [pullDownButton retain];
    return pullDownButton;
}

- (NSPopUpButton *)pullDownButton2 {
    if (auto pullDownButton2 = _pullDownButton2) return pullDownButton2;
    
    NSMenu *menu = [self makeMenu];
    
    NSPopUpButton *pullDownButton2 = [NSPopUpButton pullDownButtonWithTitle:@"PullDown" image:[NSImage imageWithSystemSymbolName:@"eraser" accessibilityDescription:nil] menu:menu];
    pullDownButton2.altersStateOfSelectedItem = NO;
    pullDownButton2.usesItemFromMenu = NO;
//    [pullDownButton selectItem:nil];
    
    _pullDownButton2 = [pullDownButton2 retain];
    return pullDownButton2;
}

- (NSMenu *)makeMenu {
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Menu"];
    
    NSMenuItem *firstMenuItem = [[NSMenuItem alloc] initWithTitle:@"First" action:@selector(firstMenuItemDidTrigger:) keyEquivalent:@""];
    firstMenuItem.target = self;
    [menu addItem:firstMenuItem];
    [firstMenuItem release];
    
    NSMenuItem *secondMenuItem = [[NSMenuItem alloc] initWithTitle:@"Second" action:@selector(secondMenuItemDidTrigger:) keyEquivalent:@""];
    secondMenuItem.target = self;
    secondMenuItem.enabled = NO;
    [menu addItem:secondMenuItem];
    [secondMenuItem release];
    
    NSMenuItem *thirdMenuItem = [[NSMenuItem alloc] initWithTitle:@"Third" action:@selector(thirdMenuItemDidTrigger:) keyEquivalent:@""];
    thirdMenuItem.target = self;
    [menu addItem:thirdMenuItem];
    [thirdMenuItem release];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveMenuItemSelectedNotification:)
                                               name:@"NSMenuItemSelectedNotification"
                                             object:menu];
    
    return [menu autorelease];
}

- (void)popUpButtonDidTrigger:(NSPopUpButton *)sender {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)popUpButton2DidTrigger:(NSPopUpButton *)sender {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)firstMenuItemDidTrigger:(NSMenuItem *)sender {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)secondMenuItemDidTrigger:(NSMenuItem *)sender {
    NSLog(@"%s, %@", sel_getName(_cmd), self.popUpButton2.selectedItem);
}

- (void)thirdMenuItemDidTrigger:(NSMenuItem *)sender {
    NSLog(@"%s", sel_getName(_cmd));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[sender MA_popupButton] selectItem:sender.menu.itemArray.firstObject];
    });
}

- (void)didReceiveMenuItemSelectedNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.userInfo[@"MenuItem"]);
}

// autoenablesItems와 관련 있음 문서 참고
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    return YES;
}

@end
