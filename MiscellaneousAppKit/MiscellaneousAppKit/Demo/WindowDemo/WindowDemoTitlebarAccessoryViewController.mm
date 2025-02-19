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
        static_cast<NSButton *>(self.view).menu = [self _makeMenu];
    }
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
            // TODO
        }
    }
    
    return [menu autorelease];
}

@end
