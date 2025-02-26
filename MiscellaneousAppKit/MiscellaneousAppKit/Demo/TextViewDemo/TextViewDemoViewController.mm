//
//  TextViewDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import "TextViewDemoViewController.h"
#import "ConfigurationView.h"
#import "NSStringFromNSWritingToolsBehavior.h"
#include <ranges>
#include <vector>
#import <objc/message.h>
#import <objc/runtime.h>
#import <CoreFoundation/CoreFoundation.h>
#import "TextView.h"

@interface TextViewDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_textView) TextView *textView;
@end

@implementation TextViewDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_scrollView release];
    [_textView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
    
//    [NSUserDefaults.standardUserDefaults setObject:@YES forKey:@"NSSmartReplyEnabled"];
    
//    Boolean boolValue = CFPreferencesAppValueIsForced(CFSTR("allowMailSmartReplies"), CFSTR("com.apple.applicationaccess"));
//    if (!boolValue) {
//        Boolean keyExistsAndHasValidFormat;
//        boolValue = CFPreferencesGetAppBooleanValue(CFSTR("allowMailSmartReplies"), CFSTR("com.apple.applicationaccess"), &keyExistsAndHasValidFormat);
//        assert(!keyExistsAndHasValidFormat || boolValue);
//    }
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    splitView.vertical = YES;
    splitView.dividerStyle = NSSplitViewDividerStyleThick;
    
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.scrollView];
    
    _splitView = splitView;
    return splitView;
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.textView;
    
    _scrollView = scrollView;
    return scrollView;
}

- (TextView *)_textView {
    if (auto textView = _textView) return textView;
    
    TextView *textView = [TextView new];
    textView.autoresizingMask = NSViewWidthSizable;
    textView.usesFindBar = YES;
    textView.incrementalSearchingEnabled = YES;
    textView.automaticSpellingCorrectionEnabled = YES;
    textView.enabledTextCheckingTypes = NSTextCheckingAllTypes;
    textView.automaticTextCompletionEnabled = YES;
    textView.automaticTextReplacementEnabled = YES;
    textView.writingToolsBehavior = NSWritingToolsBehaviorComplete;
    textView.smartReplyEnabled = YES;
    
    _textView = textView;
    return textView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeSmartReplyItemModel],
        [self _makeWritingToolsBehaviorItemModel],
        [self _makeAllowsWritingToolsAffordanceItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:NO];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeAllowsWritingToolsAffordanceItemModel {
    NSTextView *textView = self.textView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Allows Writing Tools Affordance"
                                            userInfo:nil
                                               label:@"Allows Writing Tools Affordance"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(textView.allowsWritingToolsAffordance);
    }];
}

- (ConfigurationItemModel *)_makeWritingToolsBehaviorItemModel {
    TextView *textView = self.textView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Writing Tools Behavior"
                                            userInfo:nil
                                               label:@"Writing Tools Behavior"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSWritingToolsBehavior *allBehaviors = allNSWritingToolsBehaviors(&count);
        
        auto titlesVector = std::views::iota(allBehaviors, allBehaviors + count)
        | std::views::transform([](const NSWritingToolsBehavior *ptr) {
            return NSStringFromNSWritingToolsBehavior(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSString *selectedTitle = NSStringFromNSWritingToolsBehavior(textView.writingToolsBehavior);
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[selectedTitle]
                                                     selectedDisplayTitle:selectedTitle];
    }];
}

- (ConfigurationItemModel *)_makeSmartReplyItemModel {
    TextView *textView = self.textView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Smart Reply"
                                            userInfo:nil
                                               label:@"Smart Reply"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(textView.smartInsertDeleteEnabled);
    }];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    NSTextView *textView = self.textView;
    
    if ([identifier isEqualToString:@"Allows Writing Tools Affordance"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        textView.allowsWritingToolsAffordance = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Writing Tools Behavior"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSWritingToolsBehavior behavior = NSWritingToolsBehaviorFromString(title);
        textView.writingToolsBehavior = behavior;
        return NO;
    } else if ([identifier isEqualToString:@"Smart Reply"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        textView.smartInsertDeleteEnabled = boolValue;
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
