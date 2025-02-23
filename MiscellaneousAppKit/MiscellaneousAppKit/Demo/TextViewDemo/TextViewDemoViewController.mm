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
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <CoreFoundation/CoreFoundation.h>

@interface ComposeTextView : NSTextView
@end

@implementation ComposeTextView

- (NSTextInputContext *)inputContext {
    NSTextInputContext *result = [super inputContext];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(result, sel_registerName("setInputContextHistory:"), [self _makeMailContextHistory]);
    return result;
}

- (id)_makeMailContextHistory {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"mail_conversatoins" withExtension:UTTypeJSON.preferredFilenameExtension];
    assert(url != nil);
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    assert(data != nil);
    NSError * error = nil;
    NSArray<NSDictionary<NSString *, NSString *> *> *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingJSON5Allowed error:&error];
    [data release];
    assert(error == nil);
    
    NSMutableSet<NSString *> *addresses = [NSMutableSet new];
    for (NSDictionary<NSString *, NSString *> *content in json) {
        [addresses addObject:content[@"address"]];
    }
    NSString *selfAddress = addresses.allObjects.firstObject;
    
    NSMutableSet<NSString *> *addressesWithoutSelfAddress = [addresses mutableCopy];
    [addressesWithoutSelfAddress removeObject:selfAddress];
    
    // NSInputContextHistory
    // TIInputContextEntry
    
    NSString *threadIdentifier = [NSUUID UUID].UUIDString;
    
    NSMutableArray *entries = [NSMutableArray new];
    [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"address"] isEqualToString:selfAddress]) return;
        
        id entry = [objc_lookUpClass("TIMutableInputContextEntry") new];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setText:"), obj[@"body"]);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setSenderIdentifier:"), obj[@"address"]);
        
        NSDate *timestamp = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond
                                                                value:-(json.count - idx) * 10
                                                               toDate:[NSDate now]
                                                              options:NSCalendarMatchNextTime];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setTimestamp:"), timestamp);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setEntryIdentifier:"), [NSUUID UUID].UUIDString);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setPrimaryRecipientIdentifiers:"), [NSSet setWithObject:selfAddress]);
        
        NSMutableSet<NSString *> *responseSecondaryRecipientIdentifiers = [addresses mutableCopy];
        [responseSecondaryRecipientIdentifiers removeObject:obj[@"address"]];
        [responseSecondaryRecipientIdentifiers removeObject:selfAddress];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setSecondaryRecipientIdentifiers:"), responseSecondaryRecipientIdentifiers);
        [responseSecondaryRecipientIdentifiers release];
        
        /*
         entryType = 1 (Message)
         entryType = 2 (Mail)
         */
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(entry, sel_registerName("setEntryType:"), 2);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setThreadIdentifier:"), threadIdentifier);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(entry, sel_registerName("setIsFromMe:"), NO);
        
        [entries addObject:entry];
        [entry release];
    }];
    [addresses release];
    
    
    NSMutableDictionary<NSString *, NSPersonNameComponents *> *participantNameByIdentifier = [NSMutableDictionary new];
    for (NSDictionary<NSString *, NSString *> *content in json) {
        NSString *name = content[@"name"];
        NSString *address = content[@"address"];
        
        NSPersonNameComponents *components = [NSPersonNameComponents new];
        NSString *familyName = [name componentsSeparatedByString:@" "][0];
        components.familyName = familyName;
        NSString *givenName = [name componentsSeparatedByString:@" "][1];
        components.givenName = givenName;
        participantNameByIdentifier[address] = components;
        [components release];
    }
    
    id context = reinterpret_cast<id (*)(id, SEL, id, id, id, id, id, id)>(objc_msgSend)([objc_lookUpClass("NSInputContextHistory") alloc], sel_registerName("initWithThreadIdentifier:participantsIDtoNamesMap:firstPersonIDs:primaryRecipients:secondaryRecipients:infoDict:"), threadIdentifier, participantNameByIdentifier, [NSSet setWithObject:selfAddress], addressesWithoutSelfAddress, addressesWithoutSelfAddress, @{
        @"hasCustomSignature": @NO,
        @"showSmartReplySuggestions": @YES,
        @"subject": @"Replying to you"
    });
    [addressesWithoutSelfAddress release];
    [participantNameByIdentifier release];
    
    for (id entry in entries) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(context, sel_registerName("addEntry:"), entry);
    }
    [entries release];
    
    id rep = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(context, sel_registerName("tiInputContextHistory"));
    BOOL valid = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(rep, sel_registerName("validateForSmartReplyGeneration"));
    assert(valid);
    
    if (!valid) {
        NSString *invalidReasonsForSmartReplyGeneration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rep, sel_registerName("invalidReasonsForSmartReplyGeneration"));
        NSLog(@"%@", invalidReasonsForSmartReplyGeneration);
        abort();
    }
    
//    id history = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_NSTextSmartReplyCompactContextHistory") alloc], sel_registerName("initWithContextHistory:"), context);
//    [context release];
    
    return [context autorelease];
}

@end

@interface TextViewDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_textView) NSTextView *textView;
@end

@implementation TextViewDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
    
    [NSUserDefaults.standardUserDefaults setObject:@YES forKey:@"NSSmartReplyEnabled"];
    
//    Boolean f;
//    Boolean boolValue = CFPreferencesGetAppBooleanValue(CFSTR("allowMailSmartReplies"), CFSTR("com.apple.applicationaccess"), &f);
//    if (!boolValue) {
//        boolValue = CFPreferencesAppValueIsForced(CFSTR("allowMailSmartReplies"), CFSTR("com.apple.applicationaccess"));
//    }
//    assert(boolValue);
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

- (NSTextView *)_textView {
    if (auto textView = _textView) return textView;
    
    NSTextView *textView = [ComposeTextView new];
    textView.autoresizingMask = NSViewWidthSizable;
    textView.usesFindBar = YES;
    textView.incrementalSearchingEnabled = YES;
    textView.automaticSpellingCorrectionEnabled = YES;
    textView.enabledTextCheckingTypes = NSTextCheckingAllTypes;
    textView.automaticTextCompletionEnabled = YES;
    textView.automaticTextReplacementEnabled = YES;
    textView.writingToolsBehavior = NSWritingToolsBehaviorComplete;
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textView.inputContext, sel_registerName("setInputContextHistory:"), [self _makeMailContextHistory]);
    
    _textView = textView;
    return textView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeMailContextHistoryItemModel],
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
    NSTextView *textView = self.textView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Writing Tools Behavior"
                                            userInfo:nil
                                               label:@"Writing Tools Behavior"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWritingToolsBehavior *allBehaviors = allNSWritingToolsBehaviors(&count);
        
        auto titlesVector = std::views::iota(allBehaviors, allBehaviors + count)
        | std::views::transform([](NSWritingToolsBehavior *ptr) {
            return NSStringFromNSWritingToolsBehavior(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSString *selectedTitle = NSStringFromNSWritingToolsBehavior(textView.writingToolsBehavior);
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[selectedTitle]
                                                     selectedDisplayTitle:selectedTitle];
    }];
}

- (ConfigurationItemModel *)_makeMailContextHistoryItemModel {
    NSTextView *textView = self.textView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Mail Context History"
                                            userInfo:nil
                                               label:@"Mail Context History"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        id inputContextHistory = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textView.inputContext, sel_registerName("inputContextHistory"));
        return @(inputContextHistory != nil);
    }];
}

- (id)_makeMailContextHistory {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"mail_conversatoins" withExtension:UTTypeJSON.preferredFilenameExtension];
    assert(url != nil);
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    assert(data != nil);
    NSError * error = nil;
    NSArray<NSDictionary<NSString *, NSString *> *> *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingJSON5Allowed error:&error];
    [data release];
    assert(error == nil);
    
    NSMutableSet<NSString *> *addresses = [NSMutableSet new];
    for (NSDictionary<NSString *, NSString *> *content in json) {
        [addresses addObject:content[@"address"]];
    }
    NSString *selfAddress = addresses.allObjects.firstObject;
    
    NSMutableSet<NSString *> *addressesWithoutSelfAddress = [addresses mutableCopy];
    [addressesWithoutSelfAddress removeObject:selfAddress];
    
    // NSInputContextHistory
    // TIInputContextEntry
    
    NSString *threadIdentifier = [NSUUID UUID].UUIDString;
    
    NSMutableArray *entries = [NSMutableArray new];
    [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"address"] isEqualToString:selfAddress]) return;
        
        id entry = [objc_lookUpClass("TIMutableInputContextEntry") new];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setText:"), obj[@"body"]);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setSenderIdentifier:"), obj[@"address"]);
        
        NSDate *timestamp = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond
                                                                value:-(json.count - idx) * 10
                                                               toDate:[NSDate now]
                                                              options:NSCalendarMatchNextTime];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setTimestamp:"), timestamp);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setEntryIdentifier:"), [NSUUID UUID].UUIDString);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setPrimaryRecipientIdentifiers:"), [NSSet setWithObject:selfAddress]);
        
        NSMutableSet<NSString *> *responseSecondaryRecipientIdentifiers = [addresses mutableCopy];
        [responseSecondaryRecipientIdentifiers removeObject:obj[@"address"]];
        [responseSecondaryRecipientIdentifiers removeObject:selfAddress];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setSecondaryRecipientIdentifiers:"), responseSecondaryRecipientIdentifiers);
        [responseSecondaryRecipientIdentifiers release];
        
        /*
         entryType = 1 (Message)
         entryType = 2 (Mail)
         */
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(entry, sel_registerName("setEntryType:"), 2);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setThreadIdentifier:"), threadIdentifier);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(entry, sel_registerName("setIsFromMe:"), NO);
        
        [entries addObject:entry];
        [entry release];
    }];
    [addresses release];
    
    
    NSMutableDictionary<NSString *, NSPersonNameComponents *> *participantNameByIdentifier = [NSMutableDictionary new];
    for (NSDictionary<NSString *, NSString *> *content in json) {
        NSString *name = content[@"name"];
        NSString *address = content[@"address"];
        
        NSPersonNameComponents *components = [NSPersonNameComponents new];
        NSString *familyName = [name componentsSeparatedByString:@" "][0];
        components.familyName = familyName;
        NSString *givenName = [name componentsSeparatedByString:@" "][1];
        components.givenName = givenName;
        participantNameByIdentifier[address] = components;
        [components release];
    }
    
    id context = reinterpret_cast<id (*)(id, SEL, id, id, id, id, id, id)>(objc_msgSend)([objc_lookUpClass("NSInputContextHistory") alloc], sel_registerName("initWithThreadIdentifier:participantsIDtoNamesMap:firstPersonIDs:primaryRecipients:secondaryRecipients:infoDict:"), threadIdentifier, participantNameByIdentifier, [NSSet setWithObject:selfAddress], addressesWithoutSelfAddress, addressesWithoutSelfAddress, @{
        @"hasCustomSignature": @NO,
        @"showSmartReplySuggestions": @YES,
        @"subject": @"Replying to you"
    });
    [addressesWithoutSelfAddress release];
    [participantNameByIdentifier release];
    
    for (id entry in entries) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(context, sel_registerName("addEntry:"), entry);
    }
    [entries release];
    
    id rep = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(context, sel_registerName("tiInputContextHistory"));
    BOOL valid = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(rep, sel_registerName("validateForSmartReplyGeneration"));
    assert(valid);
    
    if (!valid) {
        NSString *invalidReasonsForSmartReplyGeneration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rep, sel_registerName("invalidReasonsForSmartReplyGeneration"));
        NSLog(@"%@", invalidReasonsForSmartReplyGeneration);
        abort();
    }
    
//    id history = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_NSTextSmartReplyCompactContextHistory") alloc], sel_registerName("initWithContextHistory:"), context);
//    [context release];
    
    return [context autorelease];
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
    } else if ([identifier isEqualToString:@"Mail Context History"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            assert(reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textView.inputContext, sel_registerName("inputContextHistory")) == nil);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textView.inputContext, sel_registerName("setInputContextHistory:"), [self _makeMailContextHistory]);
        } else {
            assert(reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textView.inputContext, sel_registerName("inputContextHistory")) != nil);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textView.inputContext, sel_registerName("setInputContextHistory:"), nil);
        }
        
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
