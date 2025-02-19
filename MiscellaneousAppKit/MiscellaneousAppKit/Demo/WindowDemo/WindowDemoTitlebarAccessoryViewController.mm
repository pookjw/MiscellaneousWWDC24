//
//  WindowDemoTitlebarAccessoryViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "WindowDemoTitlebarAccessoryViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "RectSlidersView.h"
#import "NSStringFromNSLayoutAttribute.h"
#include <ranges>

@interface WindowDemoTitlebarAccessoryViewController ()

@end

@implementation WindowDemoTitlebarAccessoryViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [super dealloc];
}

- (void)loadView {
    NSButton *button = [NSButton buttonWithTitle:@"Configure" target:self action:@selector(_didTriggerButton:)];
    button.menu = [self _makeMenu];
    self.view = button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeSliderValue:) name:RectSlidersViewDidChangeValueNotification object:nil];
}

- (void)_didTriggerButton:(NSButton *)sender {
    NSMenu *menu = sender.menu;
    assert(menu != nil);
    [NSMenu popUpContextMenu:menu withEvent:sender.window.currentEvent forView:sender];
}

- (void)_didChangeSliderValue:(NSNotification *)notification {
    RectSlidersConfiguration *configuration = notification.userInfo[RectSlidersConfigurationKey];
    
    NSValue *selfValue = configuration.userInfo[@"selfValue"];
    if (selfValue == nil) return;
    if (self != selfValue.pointerValue) return;
    
    self.fullScreenMinHeight = NSHeight(configuration.rect);
    
    BOOL isTracking = static_cast<NSNumber *>(notification.userInfo[RectSlidersIsTrackingKey]).boolValue;
    if (!isTracking) {
        [self _reloadMenu:nil];
    }
}

- (void)_didTriggerLayoutAttributeMenuItem:(NSMenuItem *)sender {
    NSLayoutAttribute layoutAttribute = NSLayoutAttributeFromString(sender.title);
    self.layoutAttribute = layoutAttribute;
    [self _reloadMenu:nil];
}

- (void)_didTriggerAutomaticallyAdjustsSizeMenuItem:(NSMenuItem *)sender {
    self.automaticallyAdjustsSize = !self.automaticallyAdjustsSize;
    [self _reloadMenu:nil];
}

- (void)_didTriggerHiddenMenuItem:(NSMenuItem *)sender {
    self.hidden = !self.hidden;
    [self _reloadMenu:nil];
    
    if (self.hidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden = NO;
            [self _reloadMenu:nil];
        });
    }
}

- (void)_didTriggerInFullScreenMenuItem:(NSMenuItem *)sender {
    BOOL inFullScreen = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("inFullScreen"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self, sel_registerName("setInFullScreen:"), !inFullScreen);
    [self _reloadMenu:nil];
}

- (void)_didTriggerAllowsAutomaticSeparatorMenuItem:(NSMenuItem *)sender {
    BOOL allowsAutomaticSeparator = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("allowsAutomaticSeparator"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self, sel_registerName("setAllowsAutomaticSeparator:"), !allowsAutomaticSeparator);
    [self _reloadMenu:nil];
}

- (void)_didTriggerPrefersDefaultSizeMenuItem:(NSMenuItem *)sender {
    BOOL prefersDefaultSize = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("prefersDefaultSize"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self, sel_registerName("setPrefersDefaultSize:"), !prefersDefaultSize);
    [self _reloadMenu:nil];
}

- (void)_reloadMenu:(id)sender {
    static_cast<NSButton *>(self.view).menu = [self _makeMenu];
}

- (NSMenu *)_makeMenu {
    NSMenu *menu = [NSMenu new];
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Full Screen Min Height";
        
        NSMenu *submenu = [NSMenu new];
        
        NSMenuItem *sliderItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 50.)];
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., 0., self.fullScreenMinHeight)
                                                                            minRect:NSZeroRect
                                                                            maxRect:NSMakeRect(0., 0., 0., 100.)
                                                                           keyPaths:[NSSet setWithObject:RectSlidersKeyPathHeight]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&self) withObjCType:@encode(uintptr_t)]
        }];
        sliderItem.view = slidersView;
        [slidersView release];
        
        [submenu addItem:sliderItem];
        [sliderItem release];
        
        item.submenu = submenu;
        [submenu release];
        [menu addItem:item];
        [item release];
    }
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Layout Attribute";
        
        NSMenu *submenu = [NSMenu new];
        
        NSUInteger count;
        NSLayoutAttribute *allAttributes = allNSLayoutAttributes(&count);
        for (NSLayoutAttribute *ptr : std::views::iota(allAttributes, allAttributes + count)) {
            NSLayoutAttribute layoutAttribute = *ptr;
            NSMenuItem *menuItem = [NSMenuItem new];
            menuItem.title = NSStringFromNSLayoutAttribute(layoutAttribute);
            menuItem.state = (self.layoutAttribute == layoutAttribute) ? NSControlStateValueOn : NSControlStateValueOff;
            menuItem.target = self;
            menuItem.action = @selector(_didTriggerLayoutAttributeMenuItem:);
            [submenu addItem:menuItem];
            [menuItem release];
        }
        
        item.submenu = submenu;
        [submenu release];
        
        [menu addItem:item];
        [item release];
    }
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Automatically Adjusts Size";
        item.state = self.automaticallyAdjustsSize ? NSControlStateValueOn : NSControlStateValueOff;
        item.target = self;
        item.action = @selector(_didTriggerAutomaticallyAdjustsSizeMenuItem:);
        [menu addItem:item];
        [item release];
    }
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Hidden (Show after 3 seconds)";
        item.state = self.hidden ? NSControlStateValueOn : NSControlStateValueOff;
        item.target = self;
        item.action = @selector(_didTriggerHiddenMenuItem:);
        [menu addItem:item];
        [item release];
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    {
        CGFloat visibleAmount = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("visibleAmount"));
        NSMenuItem *item = [NSMenuItem new];
        item.title = [NSString stringWithFormat:@"Visible Amount : %lf", visibleAmount];
        [menu addItem:item];
        [item release];
    }
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"In FullScreen";
        item.target = self;
        item.action = @selector(_didTriggerInFullScreenMenuItem:);
        
        BOOL inFullScreen = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("inFullScreen"));
        item.state = inFullScreen ? NSControlStateValueOn : NSControlStateValueOff;
        
        [menu addItem:item];
        [item release];
    }
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Allows Automatic Separator";
        item.target = self;
        item.action = @selector(_didTriggerAllowsAutomaticSeparatorMenuItem:);
        
        BOOL allowsAutomaticSeparator = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("allowsAutomaticSeparator"));
        item.state = allowsAutomaticSeparator ? NSControlStateValueOn : NSControlStateValueOff;
        
        [menu addItem:item];
        [item release];
    }
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Prefers Default Size";
        item.target = self;
        item.action = @selector(_didTriggerPrefersDefaultSizeMenuItem:);
        
        BOOL prefersDefaultSize = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("prefersDefaultSize"));
        item.state = prefersDefaultSize ? NSControlStateValueOn : NSControlStateValueOff;
        
        [menu addItem:item];
        [item release];
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    {
        NSMenuItem *item = [NSMenuItem new];
        item.title = @"Reload";
        item.target = self;
        item.action = @selector(_reloadMenu:);
        [menu addItem:item];
        [item release];
    }
    
    return [menu autorelease];
}

@end
