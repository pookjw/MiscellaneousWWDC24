//
//  CarPlaySceneDelegate.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/28/24.
//

// SBStarkCapable로 CarPlay API 및 UIKit 써보기

#import "CarPlaySceneDelegate.h"
#include <ranges>
#import <objc/message.h>
#import <objc/runtime.h>

extern "C" BOOL CPCurrentProcessHasMapsEntitlement(void);

@interface CarPlaySceneDelegate () <CPSessionConfigurationDelegate, CPTabBarTemplateDelegate, CPNowPlayingTemplateObserver>
@property (retain, nonatomic, nullable) CPInterfaceController *_interfaceController;
@property (retain, nonatomic, nullable) CPSessionConfiguration *_configuration;
@property (retain, nonatomic, nullable) id _frameRateLimitInspector;
@end

@implementation CarPlaySceneDelegate

- (void)dealloc {
    [__interfaceController release];
    [__configuration release];
    [__frameRateLimitInspector release];
    [super dealloc];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController {
    self._interfaceController = interfaceController;
    
    [interfaceController setRootTemplate:[self _makeTabBarTemplate] animated:YES completion:^(BOOL success, NSError * _Nullable error) {
        assert(error == nil);
        assert(success);
    }];
    
    CPSessionConfiguration *configuration = [[CPSessionConfiguration alloc] initWithDelegate:self];
    self._configuration = configuration;
    [configuration release];
    
    // 다 안 됨
//    id frameRateLimitInspector = [objc_lookUpClass("CPUIFrameRateLimitDiffInspector") new];
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(frameRateLimitInspector, sel_registerName("observeFrameRateLimitWithBlock:"), ^{
//        abort();
//    });
//    
//    self._frameRateLimitInspector = frameRateLimitInspector;
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(templateApplicationScene, sel_registerName("setFrameRateLimitInspector:"), frameRateLimitInspector);
//    [frameRateLimitInspector release];
//    
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(templateApplicationScene, sel_registerName("setFrameRateLimit:"), @(10));
}

- (void)sessionConfiguration:(CPSessionConfiguration *)sessionConfiguration contentStyleChanged:(CPContentStyle)contentStyle {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)sessionConfiguration:(CPSessionConfiguration *)sessionConfiguration limitedUserInterfacesChanged:(CPLimitableUserInterface)limitedUserInterfaces {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)tabBarTemplate:(CPTabBarTemplate *)tabBarTemplate didSelectTemplate:(__kindof CPTemplate *)selectedTemplate {
    NSLog(@"%s: %@", sel_getName(_cmd), selectedTemplate);
}

- (void)nowPlayingTemplateUpNextButtonTapped:(CPNowPlayingTemplate *)nowPlayingTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)nowPlayingTemplateAlbumArtistButtonTapped:(CPNowPlayingTemplate *)nowPlayingTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (CPTabBarTemplate *)_makeTabBarTemplate {
    // https://x.com/_silgen_name/status/1873313556839661873
    NSMutableArray<__kindof CPTemplate *> *templates = [[NSMutableArray alloc] initWithCapacity:3];
    for (NSUInteger index : std::views::iota(0, 3)) {
        NSMutableArray<CPListSection *> *listItemSections = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSUInteger sectionIndex : std::views::iota(0, 10)) {
            NSMutableArray<CPListItem *> *items = [[NSMutableArray alloc] initWithCapacity:3];
            for (NSUInteger itemIndex : std::views::iota(0, 3)) {
                CPListItem *item = [[CPListItem alloc] initWithText:[NSString stringWithFormat:@"CPListItem %ld - %ld", sectionIndex, itemIndex]
                                                         detailText:@"Detail Text"
                                                              image:[UIImage systemImageNamed:@"car.side.rear.and.exclamationmark.and.car.side.front"]
                                                     accessoryImage:[UIImage systemImageNamed:@"bolt.car.circle.fill"]
                                                      accessoryType:CPListItemAccessoryTypeCloud];
                
                [items addObject:item];
                [item release];
            }
            
            CPListSection *section = [[CPListSection alloc] initWithItems:items
                                                                   header:[NSString stringWithFormat:@"Section %ld", sectionIndex]
                                                           headerSubtitle:@"Subtitle!"
                                                              headerImage:[UIImage systemImageNamed:@"car.rear.and.tire.marks"]
                                                             headerButton:nil
                                                        sectionIndexTitle:@(sectionIndex).stringValue];
            
            [listItemSections addObject:section];
            [section release];
        }
        
        CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:@(index).stringValue sections:listItemSections];
        [listItemSections release];
        listTemplate.tabTitle = @"Hello!";
        listTemplate.tabImage = [UIImage systemImageNamed:@"cloud.moon"];
        listTemplate.showsTabBadge = YES;
//        listTemplate.tabSystemItem = UITabBarSystemItemFavorites;
        [templates addObject:listTemplate];
        [listTemplate release];
    }
    
    [templates insertObject:[self _makeTemplatesTemplate] atIndex:0];
    
    CPTabBarTemplate *tabBarTemplate = [[CPTabBarTemplate alloc] initWithTemplates:templates];
    [templates release];
    
    tabBarTemplate.delegate = self;
    
    return [tabBarTemplate autorelease];
}

- (CPListTemplate *)_makeTemplatesTemplate {
    NSArray<NSString *> *titles = @[
        NSStringFromClass([CPNowPlayingTemplate class]),
        NSStringFromClass([CPMessageComposeBarButton class]),
        NSStringFromClass([CPGridTemplate class]),
        NSStringFromClass([CPListTemplate class])
    ];
    NSArray<__kindof CPTemplate *> *templates = @[
        [self _makeNowPlayingTemplate],
        [self _makeDemoMessageComposeBarButtonTemplate],
        [self _makeDemoGridTemplate],
        [self _makeDemoListTemplate]
    ];
    
    __block CPInterfaceController *interfaceController = self._interfaceController;
    
    NSMutableArray<CPListItem *> *items = [[NSMutableArray alloc] initWithCapacity:templates.count];
    [templates enumerateObjectsUsingBlock:^(__kindof CPTemplate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CPListItem *item = [[CPListItem alloc] initWithText:titles[idx] detailText:nil image:nil accessoryImage:nil accessoryType:CPListItemAccessoryTypeDisclosureIndicator];
        
        item.handler = ^(id<CPSelectableListItem> item, dispatch_block_t completionBlock) {
            [interfaceController pushTemplate:obj animated:YES completion:^(BOOL success, NSError * _Nullable error) {
                assert(error == nil);
                assert(success);
                completionBlock();
            }];
        };
        
        if ([obj isKindOfClass:[CPNowPlayingTemplate class]]) {
            if (CPCurrentProcessHasMapsEntitlement()) {
                // __CPAllowedTemplateClassesForCurrentEntitlement_block_invoke
                item.detailText = @"Not available when has Maps Entitlement";
            }
        }
        
        [items addObject:item];
        [item release];
    }];
    
    CPListSection *section = [[CPListSection alloc] initWithItems:items];
    [items release];
    
    CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:@"CarPlay" sections:@[section] assistantCellConfiguration:nil];
    [section release];
    
    return [listTemplate autorelease];
}

- (CPListTemplate *)_makeDemoListTemplate {
    NSMutableArray<CPListSection *> *listItemSections = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger sectionIndex : std::views::iota(0, 10)) {
        NSMutableArray<CPListItem *> *items = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSUInteger itemIndex : std::views::iota(0, 3)) {
            CPListItem *item = [[CPListItem alloc] initWithText:[NSString stringWithFormat:@"CPListItem %ld - %ld", sectionIndex, itemIndex]
                                                     detailText:@"Detail Text"
                                                          image:[UIImage systemImageNamed:@"car.side.rear.and.exclamationmark.and.car.side.front"]
                                                 accessoryImage:[UIImage systemImageNamed:@"bolt.car.circle.fill"]
                                                  accessoryType:CPListItemAccessoryTypeCloud];
            
            item.explicitContent = YES;
            item.playing = YES;
            item.playingIndicatorLocation = (itemIndex % 2 == 0) ? CPListItemPlayingIndicatorLocationLeading : CPListItemPlayingIndicatorLocationTrailing;
            item.playbackProgress = 0.5;
            item.handler = ^ (id<CPSelectableListItem> item, dispatch_block_t completionBlock) {
                NSLog(@"Triggered Item!");
                completionBlock();
            };
            
            [items addObject:item];
            [item release];
        }
        
        __block CPListSection *unretained;
        CPButton *headerButton = [[CPButton alloc] initWithImage:[UIImage systemImageNamed:@"figure.handball"] handler:^(__kindof CPButton * _Nonnull button) {
            NSLog(@"Triggered Header Button!");
            CPListItem *item = [[CPListItem alloc] initWithText:@"Replaced!"
                                                     detailText:nil
                                                          image:nil
                                                 accessoryImage:nil
                                                  accessoryType:CPListItemAccessoryTypeNone];
            reinterpret_cast<void (*)(id, SEL, NSUInteger, id)>(objc_msgSend)(unretained, sel_registerName("replaceItemAtIndex:withItem:"), 0, item);
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(unretained, sel_registerName("replaceItems:"), @[item]);
            [item release];
            
            CPListTemplate *listTemplate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretained, sel_registerName("listTemplate"));
            id templateProviderFuture = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(listTemplate, sel_registerName("templateProviderFuture"));
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(templateProviderFuture, sel_registerName("addSuccessBlock:"), ^(id result) {
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(result, sel_registerName("reloadTemplate:"), listTemplate);
            });
        }];
        
        CPListSection *section = [[CPListSection alloc] initWithItems:items
                                                               header:[NSString stringWithFormat:@"Section %ld", sectionIndex]
                                                       headerSubtitle:@"Subtitle!"
                                                          headerImage:[UIImage systemImageNamed:@"car.rear.and.tire.marks"]
                                                         headerButton:headerButton
                                                    sectionIndexTitle:@(sectionIndex).stringValue];
        unretained = section;
        [items release];
        [headerButton release];
        
        [listItemSections addObject:section];
        [section release];
    }
    
    //
    
    NSMutableArray<CPListSection *> *listImageRowSections = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger sectionIndex : std::views::iota(0, 10)) {
        NSMutableArray<CPListImageRowItem *> *items = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSUInteger itemIndex : std::views::iota(0, 3)) {
            CPListImageRowItem *item = [[CPListImageRowItem alloc] initWithText:@(itemIndex).stringValue
                                                                         images:@[
                [UIImage systemImageNamed:@"pencil.circle"],
                [UIImage systemImageNamed:@"folder.fill.badge.plus"]
            ]
                                                                    imageTitles:@[
                @"pencil.circle",
                @"folder.fill.badge.plus"
            ]];
            
            item.handler = ^ (id<CPSelectableListItem> item, dispatch_block_t completionBlock) {
                NSLog(@"Triggered Item!");
                completionBlock();
            };
            
            [items addObject:item];
            [item release];
        }
        
        CPButton *headerButton = [[CPButton alloc] initWithImage:[UIImage systemImageNamed:@"figure.handball"] handler:^(__kindof CPButton * _Nonnull button) {
            NSLog(@"Triggered Header Button!");
        }];
        
        CPListSection *section = [[CPListSection alloc] initWithItems:items
                                                               header:[NSString stringWithFormat:@"Section %ld", sectionIndex]
                                                       headerSubtitle:@"Subtitle!"
                                                          headerImage:[UIImage systemImageNamed:@"richtext.page"]
                                                         headerButton:headerButton
                                                    sectionIndexTitle:@(sectionIndex).stringValue];
        [items release];
        [headerButton release];
        
        [listImageRowSections addObject:section];
        [section release];
    }
    
    //
    
    NSMutableArray<CPListSection *> *messageListSection = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger sectionIndex : std::views::iota(0, 10)) {
        NSMutableArray<CPMessageListItem *> *items = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSUInteger itemIndex : std::views::iota(0, 3)) {
            CPMessageListItemLeadingConfiguration *leadingConfiguration = [[CPMessageListItemLeadingConfiguration alloc] initWithLeadingItem:CPMessageLeadingItemPin
                                                                                                                                leadingImage:[UIImage systemImageNamed:@"wave.3.down.car.side"]
                                                                                                                                      unread:YES];
            
            CPMessageListItemTrailingConfiguration *trailingConfiguration = [[CPMessageListItemTrailingConfiguration alloc] initWithTrailingItem:CPMessageTrailingItemMute
                                                                                                                                   trailingImage:[UIImage systemImageNamed:@"graduationcap.fill"]];
            
            CPMessageListItem *item = [[CPMessageListItem alloc] initWithFullName:[NSString stringWithFormat:@"Full name %ld - %ld", sectionIndex, itemIndex]
                                                              phoneOrEmailAddress:@"bee@potato.com"
                                                             leadingConfiguration:leadingConfiguration
                                                            trailingConfiguration:trailingConfiguration
                                                                       detailText:@"Detail"
                                                                     trailingText:@"Trailing"];
            
            [leadingConfiguration release];
            [trailingConfiguration release];
            
            [items addObject:item];
            [item release];
        }
        
        CPButton *headerButton = [[CPButton alloc] initWithImage:[UIImage systemImageNamed:@"figure.handball"] handler:^(__kindof CPButton * _Nonnull button) {
            NSLog(@"Triggered Header Button!");
        }];
        
        CPListSection *section = [[CPListSection alloc] initWithItems:items
                                                               header:[NSString stringWithFormat:@"Section %ld", sectionIndex]
                                                       headerSubtitle:@"Subtitle!"
                                                          headerImage:[UIImage systemImageNamed:@"richtext.page"]
                                                         headerButton:headerButton
                                                    sectionIndexTitle:@(sectionIndex).stringValue];
        [items release];
        [headerButton release];
        
        [messageListSection addObject:section];
        [section release];
    }
    
    //
    
    NSMutableArray<CPListSection *> *messageListSection_2 = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger sectionIndex : std::views::iota(0, 10)) {
        NSMutableArray<CPMessageListItem *> *items = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSUInteger itemIndex : std::views::iota(0, 3)) {
            CPMessageListItemLeadingConfiguration *leadingConfiguration = [[CPMessageListItemLeadingConfiguration alloc] initWithLeadingItem:CPMessageLeadingItemPin
                                                                                                                                leadingImage:[UIImage systemImageNamed:@"wave.3.down.car.side"]
                                                                                                                                      unread:YES];
            
            CPMessageListItemTrailingConfiguration *trailingConfiguration = [[CPMessageListItemTrailingConfiguration alloc] initWithTrailingItem:CPMessageTrailingItemMute
                                                                                                                                   trailingImage:[UIImage systemImageNamed:@"graduationcap.fill"]];
            
            CPMessageListItem *item = [[CPMessageListItem alloc] initWithConversationIdentifier:@"Hello Conversation Identifier!"
                                                                                           text:[NSString stringWithFormat:@"CPMessageListItem %ld - %ld", sectionIndex, itemIndex]
                                                                           leadingConfiguration:leadingConfiguration
                                                                          trailingConfiguration:trailingConfiguration
                                                                                     detailText:@"Detail!"
                                                                                   trailingText:@"Trailing!"];
            
            [leadingConfiguration release];
            [trailingConfiguration release];
            
            [items addObject:item];
            [item release];
        }
        
        CPButton *headerButton = [[CPButton alloc] initWithImage:[UIImage systemImageNamed:@"figure.handball"] handler:^(__kindof CPButton * _Nonnull button) {
            NSLog(@"Triggered Header Button!");
        }];
        
        CPListSection *section = [[CPListSection alloc] initWithItems:items
                                                               header:[NSString stringWithFormat:@"Section %ld", sectionIndex]
                                                       headerSubtitle:@"Subtitle!"
                                                          headerImage:[UIImage systemImageNamed:@"richtext.page"]
                                                         headerButton:headerButton
                                                    sectionIndexTitle:@(sectionIndex).stringValue];
        [items release];
        [headerButton release];
        
        [messageListSection_2 addObject:section];
        [section release];
    }
    
    //
    
    CPAssistantCellConfiguration *assistantCellConfiguration = [[CPAssistantCellConfiguration alloc] initWithPosition:CPAssistantCellPositionTop visibility:CPAssistantCellVisibilityAlways assistantAction:CPAssistantCellActionTypePlayMedia];
    
    //
    
    CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:@"Hello World!" sections:listItemSections assistantCellConfiguration:assistantCellConfiguration];
    [assistantCellConfiguration release];
    listTemplate.userInfo = @{
        @"currentSectionType": @0
    };
    
    //
    
    __block CPListTemplate *unretained = listTemplate;
    
    CPBarButton *barButton = [[CPBarButton alloc] initWithTitle:@"Update" handler:^(CPBarButton * _Nonnull) {
        NSMutableDictionary *userInfo = [unretained.userInfo mutableCopy];
        assert(userInfo != nil);
        NSNumber *currentSectionType = static_cast<NSDictionary *>(unretained.userInfo)[@"currentSectionType"];
        assert(currentSectionType != nil);
        
        if ([currentSectionType isEqualToNumber:@(0)]) {
            [unretained updateSections:listImageRowSections];
            userInfo[@"currentSectionType"] = @(1);
        } else if ([currentSectionType isEqualToNumber:@(1)]) {
            [unretained updateSections:messageListSection];
            userInfo[@"currentSectionType"] = @(2);
        } else if ([currentSectionType isEqualToNumber:@(2)]) {
            [unretained updateSections:messageListSection_2];
            userInfo[@"currentSectionType"] = @(3);
        } else if ([currentSectionType isEqualToNumber:@(3)]) {
            [unretained updateSections:listItemSections];
            userInfo[@"currentSectionType"] = @(0);
        }
        
        unretained.userInfo = userInfo;
        [userInfo release];
    }];
    
    [listItemSections release];
    [listImageRowSections release];
    [messageListSection release];
    
    listTemplate.trailingNavigationBarButtons = @[
        barButton
    ];
    
    [barButton release];
    
    //
    
    return [listTemplate autorelease];
}

- (CPGridTemplate *)_makeDemoGridTemplate {
    // 개수 제한 없애기 https://x.com/_silgen_name/status/1873305895670886742
    NSMutableArray<CPGridButton *> *gridButtons = [[NSMutableArray alloc] initWithCapacity:100];
    for (NSUInteger index : std::views::iota(0, 100)) {
        CPGridButton *gridButton = [[CPGridButton alloc] initWithTitleVariants:@[@(index).stringValue]
                                                                         image:[UIImage systemImageNamed:(index % 2 == 0) ? @"wind.snow" : @"cloud.moon.bolt.fill"]
                                                                       handler:^(CPGridButton * _Nonnull barButton) {
            NSLog(@"Triggered!");
        }];
        
        [gridButtons addObject:gridButton];
        [gridButton release];
    }
    
    CPGridTemplate *gridTemplate = [[CPGridTemplate alloc] initWithTitle:@"Grid Template" gridButtons:gridButtons];
    [gridButtons release];
    
    return [gridTemplate autorelease];
}

- (CPListTemplate *)_makeDemoMessageComposeBarButtonTemplate {
    CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:nil sections:@[]];
    
    CPMessageComposeBarButton *messageComposeBarButton = [[CPMessageComposeBarButton alloc] initWithImage:[UIImage systemImageNamed:@"message.fill"]];
    listTemplate.trailingNavigationBarButtons = @[messageComposeBarButton];
    [messageComposeBarButton release];
    
    return [listTemplate autorelease];
}

- (CPNowPlayingTemplate *)_makeNowPlayingTemplate {
    CPNowPlayingTemplate *nowPlayingTemplate = [CPNowPlayingTemplate sharedTemplate];
    
    NSMutableArray<__kindof CPNowPlayingButton *> *buttons = [[NSMutableArray alloc] initWithCapacity:100];
    for (NSUInteger sectionIndex : std::views::iota(0, 100)) {
        CPNowPlayingImageButton *button = [[CPNowPlayingImageButton alloc] initWithImage:[UIImage systemImageNamed:@"aqi.medium"] handler:^(__kindof CPNowPlayingButton * _Nonnull) {
            
        }];
        
        [buttons addObject:button];
        [button release];
    }
    
    [nowPlayingTemplate updateNowPlayingButtons:buttons];
    [buttons release];
    
    nowPlayingTemplate.albumArtistButtonEnabled = YES;
    nowPlayingTemplate.upNextButtonEnabled = YES;
    nowPlayingTemplate.upNextTitle = @"Up Next Title";
    
    [nowPlayingTemplate addObserver:self];
    
    return nowPlayingTemplate;
}

@end
