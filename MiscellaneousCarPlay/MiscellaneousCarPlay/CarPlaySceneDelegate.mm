//
//  CarPlaySceneDelegate.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/28/24.
//

// SBStarkCapable로 CarPlay API 및 UIKit 써보기

#import "CarPlaySceneDelegate.h"
#include <ranges>
#include <random>
#import <objc/message.h>
#import <objc/runtime.h>
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

extern "C" BOOL CPCurrentProcessHasMapsEntitlement(void);

@interface CarPlaySceneDelegate () <CPSessionConfigurationDelegate, CPTabBarTemplateDelegate, CPNowPlayingTemplateObserver, CPMapTemplateDelegate, CPSearchTemplateDelegate, CPPointOfInterestTemplateDelegate>
@property (retain, nonatomic, nullable) CPInterfaceController *_interfaceController;
@property (retain, nonatomic, nullable) CPSessionConfiguration *_configuration;
@property (retain, nonatomic, nullable) id _frameRateLimitInspector;
@property (retain, nonatomic, nullable) CPNavigationSession *_navigationSession;
@end

@implementation CarPlaySceneDelegate

- (void)dealloc {
    [__interfaceController release];
    [__configuration release];
    [__frameRateLimitInspector release];
    [__navigationSession release];
    [super dealloc];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController {
    [self templateApplicationScene:templateApplicationScene didConnectInterfaceController:interfaceController toWindow:nil];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController toWindow:(nonnull CPWindow *)window {
    self._interfaceController = interfaceController;
    
    [interfaceController setRootTemplate:[self _makeTabBarTemplate] animated:NO completion:^(BOOL success, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIWindow *window = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(UIApplication.sharedApplication, sel_registerName("_keyWindowForScreen:"), UIScreen.mainScreen);
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:error.description preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            
//            [alertController addAction:doneAction];
//            
//            [window.rootViewController presentViewController:alertController animated:YES completion:nil];
//        });
        
        assert(error == nil);
        assert(success);
    }];
    
    CPSessionConfiguration *configuration = [[CPSessionConfiguration alloc] initWithDelegate:self];
    self._configuration = configuration;
    [configuration release];
    
    //
    
    UIViewController *viewController = [UIViewController new];
    
    MKMapView *mapView = [MKMapView new];
    viewController.view = mapView;
    [mapView release];
    
//    WKWebView *webView = [WKWebView new];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com"]];
//    [webView loadRequest:request];
//    [request release];
//    viewController.view = webView;
//    [webView release];
    
    window.rootViewController = viewController;
    [viewController release];
    
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


#pragma mark - CPSessionConfigurationDelegate

- (void)sessionConfiguration:(CPSessionConfiguration *)sessionConfiguration contentStyleChanged:(CPContentStyle)contentStyle {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)sessionConfiguration:(CPSessionConfiguration *)sessionConfiguration limitedUserInterfacesChanged:(CPLimitableUserInterface)limitedUserInterfaces {
    NSLog(@"%s", sel_getName(_cmd));
}


#pragma mark - CPTabBarTemplateDelegate

- (void)tabBarTemplate:(CPTabBarTemplate *)tabBarTemplate didSelectTemplate:(__kindof CPTemplate *)selectedTemplate {
    NSLog(@"%s: %@", sel_getName(_cmd), selectedTemplate);
}


#pragma mark - CPNowPlayingTemplateObserver

- (void)nowPlayingTemplateUpNextButtonTapped:(CPNowPlayingTemplate *)nowPlayingTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)nowPlayingTemplateAlbumArtistButtonTapped:(CPNowPlayingTemplate *)nowPlayingTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}


#pragma mark - CPMapTemplateDelegate

- (void)mapTemplate:(CPMapTemplate *)mapTemplate selectedPreviewForTrip:(CPTrip *)trip usingRouteChoice:(CPRouteChoice *)routeChoice {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate startedTrip:(CPTrip *)trip usingRouteChoice:(CPRouteChoice *)routeChoice {
    NSLog(@"%s", sel_getName(_cmd));
    CPNavigationSession *navigationSession = [mapTemplate startNavigationSessionForTrip:trip];
    
    if (@available(iOS 17.4, *)) {
        // CarPlayServices에서 사용 안하는 값
        navigationSession.currentRoadNameVariants = @[@"A"];
    }
    
    self._navigationSession = navigationSession;
}

- (void)mapTemplateDidCancelNavigation:(CPMapTemplate *)mapTemplate {
    self._navigationSession = nil;
}

- (BOOL)mapTemplateShouldProvideNavigationMetadata:(CPMapTemplate *)mapTemplate {
    return YES;
}

- (BOOL)mapTemplate:(CPMapTemplate *)mapTemplate shouldShowNotificationForManeuver:(CPManeuver *)maneuver {
    NSLog(@"%s", sel_getName(_cmd));
    return YES;
}

- (BOOL)mapTemplate:(CPMapTemplate *)mapTemplate shouldUpdateNotificationForManeuver:(CPManeuver *)maneuver withTravelEstimates:(CPTravelEstimates *)travelEstimates {
    NSLog(@"%s", sel_getName(_cmd));
    return YES;
}

- (BOOL)mapTemplate:(CPMapTemplate *)mapTemplate shouldShowNotificationForNavigationAlert:(CPNavigationAlert *)navigationAlert {
    NSLog(@"%s", sel_getName(_cmd));
    return YES;
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate willShowNavigationAlert:(CPNavigationAlert *)navigationAlert {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate didShowNavigationAlert:(CPNavigationAlert *)navigationAlert {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate willDismissNavigationAlert:(CPNavigationAlert *)navigationAlert dismissalContext:(CPNavigationAlertDismissalContext)dismissalContext {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate didDismissNavigationAlert:(CPNavigationAlert *)navigationAlert dismissalContext:(CPNavigationAlertDismissalContext)dismissalContext {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplateDidShowPanningInterface:(CPMapTemplate *)mapTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplateWillDismissPanningInterface:(CPMapTemplate *)mapTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplateDidDismissPanningInterface:(CPMapTemplate *)mapTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplateDidBeginPanGesture:(CPMapTemplate *)mapTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate panBeganWithDirection:(CPPanDirection)direction {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate panWithDirection:(CPPanDirection)direction {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate panEndedWithDirection:(CPPanDirection)direction {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate didEndPanGestureWithVelocity:(CGPoint)velocity {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate didUpdatePanGestureWithTranslation:(CGPoint)translation velocity:(CGPoint)velocity {
    NSLog(@"%s", sel_getName(_cmd));
}


#pragma mark - CPSearchTemplateDelegate

- (void)searchTemplate:(CPSearchTemplate *)searchTemplate updatedSearchText:(NSString *)searchText completionHandler:(void (^)(NSArray<CPListItem *> * _Nonnull))completionHandler {
    NSArray<NSString *> *words = @[@"Apple", @"Bridge", @"Ocean", @"Whisper", @"Mountain", @"Lantern", @"Journey", @"Harmony", @"Eclipse", @"Meadow", @"Quantum", @"Velvet", @"Puzzle", @"Galaxy", @"Serenity", @"Mirage", @"Cascade", @"Twilight", @"Echo", @"Radiant", @"Falcon", @"Breeze", @"Infinity", @"Mosaic", @"Nectar", @"Prism", @"Ripple", @"Solstice", @"Tranquil", @"Umbrella", @"Vortex", @"Wander", @"Zephyr", @"Blossom", @"Cipher", @"Dusk", @"Ember", @"Frost", @"Glimmer", @"Haven", @"Illusion", @"Jigsaw", @"Kaleidoscope", @"Luminous", @"Mystic", @"Nexus", @"Oasis", @"Paradox", @"Quiver"];
    
    NSArray<NSString *> *filtered;
    if (searchText.length == 0) {
        filtered = words;
    } else {
        filtered = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@" argumentArray:@[searchText]]];
    }
    
    NSMutableArray<CPListItem *> *items = [[NSMutableArray alloc] initWithCapacity:filtered.count];
    for (NSString *word in filtered) {
        CPListItem *item = [[CPListItem alloc] initWithText:word detailText:@"Detail" image:[UIImage systemImageNamed:@"folder.circle.fill"] accessoryImage:[UIImage systemImageNamed:@"graduationcap"] accessoryType:CPListItemAccessoryTypeCloud];
        [items addObject:item];
        [item release];
    }
    
    completionHandler(items);
    [items release];
}

- (void)searchTemplate:(CPSearchTemplate *)searchTemplate selectedResult:(CPListItem *)item completionHandler:(void (^)())completionHandler {
    NSLog(@"%@", item.text);
    completionHandler();
}

- (void)searchTemplateSearchButtonPressed:(CPSearchTemplate *)searchTemplate {
    NSLog(@"%s", sel_getName(_cmd));
}


#pragma mark - CPPointOfInterestTemplateDelegate

- (void)pointOfInterestTemplate:(CPPointOfInterestTemplate *)pointOfInterestTemplate didChangeMapRegion:(MKCoordinateRegion)region {
    
}

- (void)pointOfInterestTemplate:(CPPointOfInterestTemplate *)pointOfInterestTemplate didSelectPointOfInterest:(CPPointOfInterest *)pointOfInterest {
    NSLog(@"%s %@", sel_getName(_cmd), pointOfInterest);
}


#pragma mark - Make Methods

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
        NSStringFromClass([CPSearchTemplate class]),
        NSStringFromClass([CPAlertTemplate class]),
        NSStringFromClass([CPContactTemplate class]),
        @"CPInformationTemplateLayoutTwoColumn",
        @"CPInformationTemplateLayoutLeading",
        NSStringFromClass([CPPointOfInterestTemplate class]),
        NSStringFromClass([CPVoiceControlTemplate class]),
        NSStringFromClass([CPMapTemplate class]),
        NSStringFromClass([CPNowPlayingTemplate class]),
        NSStringFromClass([CPMessageComposeBarButton class]),
        NSStringFromClass([CPGridTemplate class]),
        NSStringFromClass([CPListTemplate class])
    ];
    NSArray<__kindof CPTemplate *> *templates = @[
        [self _makeSearchTemplate],
        [self _makeActionSheetPresenterTemplate],
        [self _makeContactTemplate],
        [self _makeInformationTemplateWithLayout:CPInformationTemplateLayoutTwoColumn],
        [self _makeInformationTemplateWithLayout:CPInformationTemplateLayoutLeading],
        [self _makePointOfInterestTemplate],
        [self _makeVoiceControlPresenterTemplate],
        [self _makeMapTemplate],
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
            CPListImageRowItem *item;
            if (@available(iOS 17.4, *)) {
                item = [[CPListImageRowItem alloc] initWithText:@(itemIndex).stringValue
                                                         images:@[
                    [UIImage systemImageNamed:@"pencil.circle"],
                    [UIImage systemImageNamed:@"folder.fill.badge.plus"]
                ]
                                                    imageTitles:@[
                    @"pencil.circle",
                    @"folder.fill.badge.plus"
                ]];
            } else {
                item = [[CPListImageRowItem alloc] initWithText:@(itemIndex).stringValue
                                                         images:@[
                    [UIImage systemImageNamed:@"pencil.circle"],
                    [UIImage systemImageNamed:@"folder.fill.badge.plus"]
                ]];
            }
            
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

- (CPMapTemplate *)_makeMapTemplate {
    CPMapTemplate *mapTemplate = [CPMapTemplate new];
    
    mapTemplate.automaticallyHidesNavigationBar = YES;
    mapTemplate.hidesButtonsWithNavigationBar = YES;
    mapTemplate.mapDelegate = self;
//    mapTemplate.guidanceBackgroundColor = [UIColor systemPinkColor];
    
    //
    
    CPMapButton *mapButton_1 = [[CPMapButton alloc] initWithHandler:^(CPMapButton * _Nonnull mapButton) {
        CPMapTemplate *mapTemplate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mapButton, sel_registerName("controlDelegate"));
        NSArray<CPTrip *> *tripPreviews = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mapTemplate, sel_registerName("tripPreviews"));
        
        if (tripPreviews.count > 0) {
            [mapTemplate hideTripPreviews];
            return;
        }
        
        //
        
        NSMutableArray<CPTrip *> *trips = [NSMutableArray new];
        
        {
            MKPlacemark *originPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.571648599, 126.976372775)];
            assert(CLLocationCoordinate2DIsValid(originPlacemark.coordinate));
            MKMapItem *origin = [[MKMapItem alloc] initWithPlacemark:originPlacemark];
            [originPlacemark release];
            origin.name = @"Origin name";
            
            MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.572583105, 126.990414851)];
            assert(CLLocationCoordinate2DIsValid(destinationPlacemark.coordinate));
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
            [destinationPlacemark release];
            destination.name = @"Destination name";
            
            CPRouteChoice *routeChoice_1 = [[CPRouteChoice alloc] initWithSummaryVariants:@[@"1-0", @"1-1", @"1-2"]
                                                            additionalInformationVariants:@[@"2-0", @"2-1", @"2-2"]
                                                                 selectionSummaryVariants:@[@"3-0", @"3-1", @"3-2"]];
            
            CPRouteChoice *routeChoice_2 = [[CPRouteChoice alloc] initWithSummaryVariants:@[@"4-0", @"4-1", @"4-2"]
                                                            additionalInformationVariants:@[@"5-0", @"5-1", @"5-2"]
                                                                 selectionSummaryVariants:@[@"6-0", @"6-1", @"6-2"]];
            
            CPTrip *trip = [[CPTrip alloc] initWithOrigin:origin destination:destination routeChoices:@[routeChoice_1, routeChoice_2]];
            [origin release];
            [destination release];
            [routeChoice_1 release];
            [routeChoice_2 release];
            
            if (@available(iOS 17.4, *)) {
                trip.destinationNameVariants = @[@"Short", @"LongLongLongLong"];
            }
            
            [trips addObject:trip];
            [trip release];
        }
        
        {
            MKPlacemark *originPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.549681, 126.991911)];
            assert(CLLocationCoordinate2DIsValid(originPlacemark.coordinate));
            MKMapItem *origin = [[MKMapItem alloc] initWithPlacemark:originPlacemark];
            [originPlacemark release];
            origin.name = @"Origin name";
            
            MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.6608, 126.9933)];
            assert(CLLocationCoordinate2DIsValid(destinationPlacemark.coordinate));
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
            [destinationPlacemark release];
            destination.name = @"Destination name";
            
            CPRouteChoice *routeChoice_1 = [[CPRouteChoice alloc] initWithSummaryVariants:@[@"1-0", @"1-1", @"1-2"]
                                                            additionalInformationVariants:@[@"2-0", @"2-1", @"2-2"]
                                                                 selectionSummaryVariants:@[@"3-0", @"3-1", @"3-2"]];
            
            CPRouteChoice *routeChoice_2 = [[CPRouteChoice alloc] initWithSummaryVariants:@[@"4-0", @"4-1", @"4-2"]
                                                            additionalInformationVariants:@[@"5-0", @"5-1", @"5-2"]
                                                                 selectionSummaryVariants:@[@"6-0", @"6-1", @"6-2"]];
            
            CPTrip *trip = [[CPTrip alloc] initWithOrigin:origin destination:destination routeChoices:@[routeChoice_1, routeChoice_2]];
            [origin release];
            [destination release];
            [routeChoice_1 release];
            [routeChoice_2 release];
            
            if (@available(iOS 17.4, *)) {
                trip.destinationNameVariants = @[@"Short", @"LongLongLongLong"];
            }
            
            [trips addObject:trip];
            [trip release];
        }
        
        CPTripPreviewTextConfiguration *tripPreviewTextConfiguration = [[CPTripPreviewTextConfiguration alloc] initWithStartButtonTitle:@"Start Button Title" additionalRoutesButtonTitle:@"Additional Routes Button Title" overviewButtonTitle:@"Overview Button Title"];
        
        [mapTemplate showTripPreviews:trips selectedTrip:trips.lastObject textConfiguration:tripPreviewTextConfiguration];
        [trips release];
        [tripPreviewTextConfiguration release];
    }];
    mapButton_1.image = [UIImage systemImageNamed:@"1.circle"];
    mapButton_1.focusedImage = [UIImage systemImageNamed:@"1.square"];
    
    
    CPMapButton *mapButton_2 = [[CPMapButton alloc] initWithHandler:^(CPMapButton * _Nonnull mapButton) {
        CPMapTemplate *mapTemplate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mapButton, sel_registerName("controlDelegate"));
        NSArray<CPTrip *> *tripPreviews = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mapTemplate, sel_registerName("tripPreviews"));
        
        if (tripPreviews.count > 0) {
            [mapTemplate hideTripPreviews];
            return;
        }
        
        //
        
        MKPlacemark *originPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.571648599, 126.976372775)];
        assert(CLLocationCoordinate2DIsValid(originPlacemark.coordinate));
        MKMapItem *origin = [[MKMapItem alloc] initWithPlacemark:originPlacemark];
        [originPlacemark release];
        origin.name = @"Origin name";
        
        MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.572583105, 126.990414851)];
        assert(CLLocationCoordinate2DIsValid(destinationPlacemark.coordinate));
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
        [destinationPlacemark release];
        destination.name = @"Destination name";
        
        CPRouteChoice *routeChoice_1 = [[CPRouteChoice alloc] initWithSummaryVariants:@[@"1-0", @"1-1", @"1-2"]
                                                        additionalInformationVariants:@[@"2-0", @"2-1", @"2-2"]
                                                             selectionSummaryVariants:@[@"3-0", @"3-1", @"3-2"]];
        
        CPRouteChoice *routeChoice_2 = [[CPRouteChoice alloc] initWithSummaryVariants:@[@"4-0", @"4-1", @"4-2"]
                                                        additionalInformationVariants:@[@"5-0", @"5-1", @"5-2"]
                                                             selectionSummaryVariants:@[@"6-0", @"6-1", @"6-2"]];
        
        CPTrip *trip = [[CPTrip alloc] initWithOrigin:origin destination:destination routeChoices:@[routeChoice_1, routeChoice_2]];
        [origin release];
        [destination release];
        [routeChoice_1 release];
        [routeChoice_2 release];
        
        trip.destinationNameVariants = @[@"Short", @"LongLongLongLong"];
        
        CPTripPreviewTextConfiguration *tripPreviewTextConfiguration = [[CPTripPreviewTextConfiguration alloc] initWithStartButtonTitle:@"Start Button Title" additionalRoutesButtonTitle:@"Additional Routes Button Title" overviewButtonTitle:@"Overview Button Title"];
        
        [mapTemplate showRouteChoicesPreviewForTrip:trip textConfiguration:tripPreviewTextConfiguration];
        [trip release];
        [tripPreviewTextConfiguration release];
    }];
    mapButton_2.image = [UIImage systemImageNamed:@"2.circle"];
    mapButton_2.focusedImage = [UIImage systemImageNamed:@"2.square"];
    
    
    __block auto unretained = self;
    CPMapButton *mapButton_3 = [[CPMapButton alloc] initWithHandler:^(CPMapButton * _Nonnull mapButton) {
        CPNavigationSession *navigationSession = unretained._navigationSession;
        if (navigationSession == nil) return;
        
        if (@available(iOS 17.4, *)) {
            CPLaneGuidance *laneGuidance = [CPLaneGuidance new];
            laneGuidance.instructionVariants = @[@"instructionVariant 1"];
            
            NSMeasurement *angle_1 = [[NSMeasurement alloc] initWithDoubleValue:30. unit:[NSUnitAngle degrees]];
            NSMeasurement *angle_2 = [[NSMeasurement alloc] initWithDoubleValue:40. unit:[NSUnitAngle degrees]];
            NSMeasurement *angle_3 = [[NSMeasurement alloc] initWithDoubleValue:90. unit:[NSUnitAngle degrees]];
            NSMeasurement *angle_4 = [[NSMeasurement alloc] initWithDoubleValue:120. unit:[NSUnitAngle degrees]];
            
            CPLane *lane_1;
            
            if (@available(iOS 18.0, *)) {
                lane_1 = [[CPLane alloc] initWithAngles:@[angle_1, angle_2, angle_3, angle_4]
                                               highlightedAngle:angle_3
                                                    isPreferred:YES];
            } else {
                abort();
            }
            
            [angle_1 release];
            [angle_2 release];
            [angle_3 release];
            [angle_4 release];
            
            laneGuidance.lanes = @[lane_1];
            [lane_1 release];
            
            [navigationSession addLaneGuidances:@[laneGuidance]];
            navigationSession.currentLaneGuidance = laneGuidance;
            [laneGuidance release];
        }
    }];
    mapButton_3.image = [UIImage systemImageNamed:@"3.circle"];
    mapButton_3.focusedImage = [UIImage systemImageNamed:@"3.square"];
    
    
    CPMapButton *mapButton_4 = [[CPMapButton alloc] initWithHandler:^(CPMapButton * _Nonnull mapButton) {
        CPNavigationSession *navigationSession = unretained._navigationSession;
        if (navigationSession == nil) return;
        
        CPManeuver *maneuver = [CPManeuver new];
        maneuver.instructionVariants = @[@"Turn Left...?"];
        maneuver.symbolImage = [UIImage systemImageNamed:@"arrowshape.turn.up.right"];
        maneuver.junctionImage = [UIImage systemImageNamed:@"iphone.radiowaves.left.and.right"];
        maneuver.cardBackgroundColor = UIColor.orangeColor;
        NSMeasurement *distanceRemaining = [[NSMeasurement alloc] initWithDoubleValue:100. unit:[NSUnitLength kilometers]];
        
        CPTravelEstimates *initialTravelEstimates;
        if (@available(iOS 17.4, *)) {
            initialTravelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                                           distanceRemainingToDisplay:distanceRemaining
                                                                                        timeRemaining:200.];
        } else {
            initialTravelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                                                        timeRemaining:200.];
        }
        
        [distanceRemaining release];
        maneuver.initialTravelEstimates = initialTravelEstimates;
        navigationSession.upcomingManeuvers = @[maneuver];
        [maneuver release];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CPManeuver *maneuver = [CPManeuver new];
            maneuver.instructionVariants = @[@"Turn Right...?"];
            maneuver.symbolImage = [UIImage systemImageNamed:@"arrowshape.turn.up.left"];
            maneuver.junctionImage = [UIImage systemImageNamed:@"iphone.radiowaves.left.and.right"];
            maneuver.initialTravelEstimates = initialTravelEstimates;
            
            if (@available(iOS 17.4, *)) {
                [navigationSession addManeuvers:@[maneuver]];
            } else {
                navigationSession.upcomingManeuvers = @[maneuver];
            }
            
            [maneuver release];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CPManeuver *maneuver_1 = [CPManeuver new];
            maneuver_1.instructionVariants = @[@"Turn Right...?"];
            maneuver_1.symbolImage = [UIImage systemImageNamed:@"arrowshape.turn.up.left"];
            maneuver_1.junctionImage = [UIImage systemImageNamed:@"iphone.radiowaves.left.and.right"];
            maneuver_1.initialTravelEstimates = initialTravelEstimates;
            
            CPManeuver *maneuver_2 = [CPManeuver new];
            maneuver_2.instructionVariants = @[@"Turn Left...?"];
            maneuver_2.symbolImage = [UIImage systemImageNamed:@"arrowshape.turn.up.right"];
            maneuver_2.junctionImage = [UIImage systemImageNamed:@"iphone.radiowaves.left.and.right"];
            maneuver_2.initialTravelEstimates = initialTravelEstimates;
            
            
            if (@available(iOS 17.4, *)) {
                [navigationSession addManeuvers:@[maneuver_1, maneuver_2]];
            } else {
                navigationSession.upcomingManeuvers = @[maneuver_1, maneuver_2];
            }
            
            [maneuver_1 release];
            [maneuver_2 release];
        });
        
        [initialTravelEstimates release];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            navigationSession.upcomingManeuvers = @[];
        });
    }];
    mapButton_4.image = [UIImage systemImageNamed:@"4.circle"];
    mapButton_4.focusedImage = [UIImage systemImageNamed:@"4.square"];
    
    
    mapTemplate.mapButtons = @[mapButton_1, mapButton_2, mapButton_3, mapButton_4];
    [mapButton_1 release];
    [mapButton_2 release];
    [mapButton_3 release];
    [mapButton_4 release];
    
    //
    
    CPBarButton *cancelNavigationButton = [[CPBarButton alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] handler:^(CPBarButton * _Nonnull button) {
        // -finishTrip랑 똑같음
        [unretained._navigationSession cancelTrip];
    }];
    
    CPBarButton *updateEstimatesButton = [[CPBarButton alloc] initWithTitle:@"Esti." handler:^(CPBarButton * _Nonnull button) {
        CPNavigationSession *navigationSession = unretained._navigationSession;
        if (navigationSession == nil) return;
        
        CPTrip *trip = navigationSession.trip;
        
        CPMapTemplate *mapTemplate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("delegate"));
        
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_real_distribution<double> double_dist(5.0, 300.0);
        std::uniform_int_distribution<int> int_dist(0, 3);
        
        NSMeasurement *distanceRemaining = [[NSMeasurement alloc] initWithDoubleValue:double_dist(gen) unit:[NSUnitLength kilometers]];
        
        CPTravelEstimates *travelEstimates;
        if (@available(iOS 17.4, *)) {
            travelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                        distanceRemainingToDisplay:distanceRemaining
                                                                     timeRemaining:double_dist(gen)];
        } else {
            travelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                                     timeRemaining:double_dist(gen)];
        }
        
        [distanceRemaining release];
        
        [mapTemplate updateTravelEstimates:travelEstimates forTrip:trip withTimeRemainingColor:static_cast<CPTimeRemainingColor>(int_dist(gen))];
        [travelEstimates release];
    }];
    
    CPBarButton *pauseOrResumeBarButton = [[CPBarButton alloc] initWithImage:[UIImage systemImageNamed:@"playpause.fill"] handler:^(CPBarButton * _Nonnull) {
        CPNavigationSession *navigationSession = unretained._navigationSession;
        if (navigationSession == nil) return;
        
        CPTripPauseReason pauseReason = reinterpret_cast<CPTripPauseReason (*)(id, SEL)>(objc_msgSend)(navigationSession, sel_registerName("pauseReason"));
        
        if (pauseReason == 0) {
            std::random_device rd;
            std::mt19937 gen(rd());
            std::uniform_int_distribution<int> dist(1, 5);
            
            [navigationSession pauseTripForReason:CPTripPauseReasonArrived
                                      description:@"Pause Description"
                                    turnCardColor:UIColor.systemPinkColor];
        } else {
            if (@available(iOS 17.4, *)) {
                CPLaneGuidance *laneGuidance = [CPLaneGuidance new];
                NSMeasurement *distanceRemaining = [[NSMeasurement alloc] initWithDoubleValue:100. unit:[NSUnitLength kilometers]];
                CPTravelEstimates *tripTravelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                                                   distanceRemainingToDisplay:distanceRemaining
                                                                                                timeRemaining:200.];
                [distanceRemaining release];
                
                CPRouteInformation *routeInformation = [[CPRouteInformation alloc] initWithManeuvers:@[]
                                                                                       laneGuidances:@[]
                                                                                    currentManeuvers:@[]
                                                                                 currentLaneGuidance:laneGuidance
                                                                                 tripTravelEstimates:tripTravelEstimates
                                                                             maneuverTravelEstimates:tripTravelEstimates];
                [laneGuidance release];
                [tripTravelEstimates release];
                
                [navigationSession resumeTripWithUpdatedRouteInformation:routeInformation];
                [routeInformation release];
            }
        }
    }];
    
    CPBarButton *alertBarButton = [[CPBarButton alloc] initWithTitle:@"Alert" handler:^(CPBarButton * _Nonnull button) {
        CPMapTemplate *mapTemplate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("delegate"));
        
        CPAlertAction *panAction = [[CPAlertAction alloc] initWithTitle:@"Pan" style:CPAlertActionStyleDefault handler:^(CPAlertAction * _Nonnull) {
            if (mapTemplate.isPanningInterfaceVisible) {
                [mapTemplate dismissPanningInterfaceAnimated:YES];
            } else {
                [mapTemplate showPanningInterfaceAnimated:YES];
            }
        }];
        CPAlertAction *greenAction = [[CPAlertAction alloc] initWithTitle:@"Green" color:UIColor.greenColor handler:^(CPAlertAction * _Nonnull) {
            
        }];
        
        CPNavigationAlert *alert = [[CPNavigationAlert alloc] initWithTitleVariants:@[@"Title"]
                                                                   subtitleVariants:@[@"Subtitle"]
                                                                              image:[UIImage systemImageNamed:@"macwindow"]
                                                                      primaryAction:panAction
                                                                    secondaryAction:greenAction
                                                                           duration:300.];
        [panAction release];
        [greenAction release];
        
        [mapTemplate presentNavigationAlert:alert animated:YES];
        [alert release];
    }];
    
    mapTemplate.leadingNavigationBarButtons = @[pauseOrResumeBarButton, alertBarButton];
    [pauseOrResumeBarButton release];
    [alertBarButton release];
    mapTemplate.trailingNavigationBarButtons = @[cancelNavigationButton, updateEstimatesButton];
    [cancelNavigationButton release];
    [updateEstimatesButton release];
    
    //
    
    return [mapTemplate autorelease];
}

- (CPSearchTemplate *)_makeSearchTemplate {
    CPSearchTemplate *searchTemplate = [CPSearchTemplate new];
    searchTemplate.delegate = self;
    
    return [searchTemplate autorelease];
}

- (CPInformationTemplate *)_makeVoiceControlPresenterTemplate {
    __block CPInterfaceController *interfaceController = self._interfaceController;
    
    CPTextButton *button = [[CPTextButton alloc] initWithTitle:@"Present" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        CPVoiceControlState *state_1 = [[CPVoiceControlState alloc] initWithIdentifier:[NSUUID UUID].UUIDString
                                                                         titleVariants:@[@"Title 1"]
                                                                                 image:[UIImage systemImageNamed:@"studentdesk"]
                                                                               repeats:YES];
        CPVoiceControlState *state_2 = [[CPVoiceControlState alloc] initWithIdentifier:[NSUUID UUID].UUIDString
                                                                         titleVariants:@[@"Title 2"]
                                                                                 image:[UIImage systemImageNamed:@"microbe"]
                                                                               repeats:YES];
        
        CPVoiceControlTemplate *voiceControlTemplate = [[CPVoiceControlTemplate alloc] initWithVoiceControlStates:@[state_1, state_2]];
        
        [interfaceController presentTemplate:voiceControlTemplate animated:YES completion:^(BOOL success, NSError * _Nullable error) {
            assert(error == nil);
            assert(success);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [voiceControlTemplate activateVoiceControlStateWithIdentifier:state_2.identifier];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [voiceControlTemplate activateVoiceControlStateWithIdentifier:state_1.identifier];
                });
            });
        }];
        
        [state_1 release];
        [state_2 release];
        
        [voiceControlTemplate release];
    }];
    
    CPInformationTemplate *informationTemplate = [[CPInformationTemplate alloc] initWithTitle:NSStringFromClass([CPVoiceControlTemplate class])
                                                                                       layout:CPInformationTemplateLayoutTwoColumn
                                                                                        items:@[]
                                                                                      actions:@[button]];
    [button release];
    
    return [informationTemplate autorelease];
}

- (CPPointOfInterestTemplate *)_makePointOfInterestTemplate {
    MKPlacemark *placemark_1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.549681, 126.991911)];
    assert(CLLocationCoordinate2DIsValid(placemark_1.coordinate));
    MKMapItem *mapItem_1 = [[MKMapItem alloc] initWithPlacemark:placemark_1];
    [placemark_1 release];
    mapItem_1.name = @"Origin name 1";
    
    CPPointOfInterest *pointOfInterest_1 = [[CPPointOfInterest alloc] initWithLocation:mapItem_1
                                                                               title:@"Title 1"
                                                                            subtitle:@"Subtitle 1"
                                                                             summary:@"Summary 1"
                                                                         detailTitle:@"Detail Title 1"
                                                                      detailSubtitle:@"Detail Subtitle 1"
                                                                       detailSummary:@"Detail Summary 1"
                                                                            pinImage:[UIImage systemImageNamed:@"captions.bubble"]
                                                                    selectedPinImage:[UIImage systemImageNamed:@"mail.stack.fill"]];
    [mapItem_1 release];
    
    CPTextButton *primaryButton_1 = [[CPTextButton alloc] initWithTitle:@"Primary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    pointOfInterest_1.primaryButton = primaryButton_1;
    [primaryButton_1 release];
    
    CPTextButton *secondaryButton_1 = [[CPTextButton alloc] initWithTitle:@"Secondary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    pointOfInterest_1.secondaryButton = secondaryButton_1;
    [secondaryButton_1 release];
    
    //
    
    MKPlacemark *placemark_2 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.572583105, 126.990414851)];
    assert(CLLocationCoordinate2DIsValid(placemark_2.coordinate));
    MKMapItem *mapItem_2 = [[MKMapItem alloc] initWithPlacemark:placemark_2];
    [placemark_2 release];
    mapItem_2.name = @"Origin name 2";
    
    CPPointOfInterest *pointOfInterest_2 = [[CPPointOfInterest alloc] initWithLocation:mapItem_2
                                                                               title:@"Title 2"
                                                                            subtitle:@"Subtitle 2"
                                                                             summary:@"Summary 2"
                                                                         detailTitle:@"Detail Title 2"
                                                                      detailSubtitle:@"Detail Subtitle 2"
                                                                       detailSummary:@"Detail Summary 2"
                                                                            pinImage:[UIImage systemImageNamed:@"captions.bubble"]
                                                                    selectedPinImage:[UIImage systemImageNamed:@"mail.stack.fill"]];
    [mapItem_2 release];
    
    CPTextButton *primaryButton_2 = [[CPTextButton alloc] initWithTitle:@"Primary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    pointOfInterest_2.primaryButton = primaryButton_2;
    [primaryButton_2 release];
    
    CPTextButton *secondaryButton_2 = [[CPTextButton alloc] initWithTitle:@"Secondary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    pointOfInterest_2.secondaryButton = secondaryButton_2;
    [secondaryButton_2 release];
    
    //
    
    CPPointOfInterestTemplate *pointOfInterestTemplate = [[CPPointOfInterestTemplate alloc] initWithTitle:@"Title" pointsOfInterest:@[pointOfInterest_1, pointOfInterest_2] selectedIndex:1];
    [pointOfInterest_1 release];
    [pointOfInterest_2 release];
    
    pointOfInterestTemplate.pointOfInterestDelegate = self;
    
    //
    
    CPBarButton *updateBarButton = [[CPBarButton alloc] initWithTitle:@"Update" handler:^(CPBarButton * _Nonnull button) {
        CPPointOfInterestTemplate *_template = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("delegate"));
        
        //
        
        MKPlacemark *placemark_1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.571648599, 126.976372775)];
        assert(CLLocationCoordinate2DIsValid(placemark_1.coordinate));
        MKMapItem *mapItem_1 = [[MKMapItem alloc] initWithPlacemark:placemark_1];
        [placemark_1 release];
        mapItem_1.name = @"Origin name 1";
        
        CPPointOfInterest *pointOfInterest_1 = [[CPPointOfInterest alloc] initWithLocation:mapItem_1
                                                                                   title:@"Title 1"
                                                                                subtitle:@"Subtitle 1"
                                                                                 summary:@"Summary 1"
                                                                             detailTitle:@"Detail Title 1"
                                                                          detailSubtitle:@"Detail Subtitle 1"
                                                                           detailSummary:@"Detail Summary 1"
                                                                                pinImage:[UIImage systemImageNamed:@"captions.bubble"]
                                                                        selectedPinImage:[UIImage systemImageNamed:@"mail.stack.fill"]];
        [mapItem_1 release];
        
        CPTextButton *primaryButton_1 = [[CPTextButton alloc] initWithTitle:@"Primary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
            
        }];
        pointOfInterest_1.primaryButton = primaryButton_1;
        [primaryButton_1 release];
        
        CPTextButton *secondaryButton_1 = [[CPTextButton alloc] initWithTitle:@"Secondary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
            
        }];
        pointOfInterest_1.secondaryButton = secondaryButton_1;
        [secondaryButton_1 release];
        
        //
        
        MKPlacemark *placemark_2 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(37.6608, 126.9933)];
        assert(CLLocationCoordinate2DIsValid(placemark_2.coordinate));
        MKMapItem *mapItem_2 = [[MKMapItem alloc] initWithPlacemark:placemark_2];
        [placemark_2 release];
        mapItem_2.name = @"Origin name 2";
        
        CPPointOfInterest *pointOfInterest_2 = [[CPPointOfInterest alloc] initWithLocation:mapItem_2
                                                                                   title:@"Title 2"
                                                                                subtitle:@"Subtitle 2"
                                                                                 summary:@"Summary 2"
                                                                             detailTitle:@"Detail Title 2"
                                                                          detailSubtitle:@"Detail Subtitle 2"
                                                                           detailSummary:@"Detail Summary 2"
                                                                                pinImage:[UIImage systemImageNamed:@"captions.bubble"]
                                                                        selectedPinImage:[UIImage systemImageNamed:@"mail.stack.fill"]];
        [mapItem_2 release];
        
        CPTextButton *primaryButton_2 = [[CPTextButton alloc] initWithTitle:@"Primary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
            
        }];
        pointOfInterest_2.primaryButton = primaryButton_2;
        [primaryButton_2 release];
        
        CPTextButton *secondaryButton_2 = [[CPTextButton alloc] initWithTitle:@"Secondary" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
            
        }];
        pointOfInterest_2.secondaryButton = secondaryButton_2;
        [secondaryButton_2 release];
        
        //
        
        [_template setPointsOfInterest:@[pointOfInterest_1, pointOfInterest_2] selectedIndex:1];
        [pointOfInterest_1 release];
        [pointOfInterest_2 release];
    }];
    
    pointOfInterestTemplate.trailingNavigationBarButtons = @[updateBarButton];
    [updateBarButton release];
    
    //
    
    return [pointOfInterestTemplate autorelease];
}

- (CPInformationTemplate *)_makeInformationTemplateWithLayout:(CPInformationTemplateLayout)layout {
    CPInformationItem *item_1 = [[CPInformationItem alloc] initWithTitle:@"Title 1" detail:@"Detail 1"];
    CPInformationItem *item_2 = [[CPInformationItem alloc] initWithTitle:@"Title 2" detail:@"Detail 2"];
    CPInformationRatingItem *ratingItem = [[CPInformationRatingItem alloc] initWithRating:@(3.4) maximumRating:@(6) title:@"Rating Title" detail:@"Rating Detail"];
    
    CPTextButton *action_1 = [[CPTextButton alloc] initWithTitle:@"CPTextButtonStyleCancel" textStyle:CPTextButtonStyleCancel handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    
    CPTextButton *action_2 = [[CPTextButton alloc] initWithTitle:@"CPTextButtonStyleNormal" textStyle:CPTextButtonStyleNormal handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    
    CPTextButton *action_3 = [[CPTextButton alloc] initWithTitle:@"CPTextButtonStyleConfirm" textStyle:CPTextButtonStyleConfirm handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        
    }];
    
    CPInformationTemplate *informationTemplate = [[CPInformationTemplate alloc] initWithTitle:@"Title"
                                                                                       layout:layout
                                                                                        items:@[item_1, item_2, ratingItem]
                                                                                      actions:@[action_1, action_2, action_3]];
    
    [item_1 release];
    [item_2 release];
    [ratingItem release];
    [action_1 release];
    [action_2 release];
    [action_3 release];
    
    return [informationTemplate autorelease];
}

- (CPContactTemplate *)_makeContactTemplate {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"image" withExtension:UTTypeHEIC.preferredFilenameExtension];
    CPContact *contact = [[CPContact alloc] initWithName:@"Name" image:[UIImage imageWithContentsOfFile:url.path]];
    contact.subtitle = @"Subtitle";
    contact.informativeText = @"informativeText";
    
    CPContactCallButton *callButton = [[CPContactCallButton alloc] initWithHandler:^(__kindof CPButton * _Nonnull contactButton) {
        NSLog(@"%@", NSStringFromClass([contactButton class]));
    }];
    CPContactDirectionsButton *directionsButton = [[CPContactDirectionsButton alloc] initWithHandler:^(__kindof CPButton * _Nonnull contactButton) {
        NSLog(@"%@", NSStringFromClass([contactButton class]));
    }];
    CPContactMessageButton *messageButton = [[CPContactMessageButton alloc] initWithPhoneOrEmail:@"potato@apple.com"];
    
    contact.actions = @[callButton, directionsButton, messageButton];
    [callButton release];
    [directionsButton release];
    [messageButton release];
    
    CPContactTemplate *contactTemplate = [[CPContactTemplate alloc] initWithContact:contact];
    [contact release];
    
    return [contactTemplate autorelease];
}

- (CPInformationTemplate *)_makeActionSheetPresenterTemplate {
    __block CPInterfaceController *interfaceController = self._interfaceController;
    
    CPTextButton *action = [[CPTextButton alloc] initWithTitle:@"Present" textStyle:CPTextButtonStyleCancel handler:^(__kindof CPTextButton * _Nonnull contactButton) {
        CPAlertAction *action_1 = [[CPAlertAction alloc] initWithTitle:@"CPAlertActionStyleDefault" style:CPAlertActionStyleDefault handler:^(CPAlertAction * _Nonnull) {
            NSLog(@"CPAlertActionStyleDefault");
        }];
        CPAlertAction *action_2 = [[CPAlertAction alloc] initWithTitle:@"CPAlertActionStyleCancel" style:CPAlertActionStyleCancel handler:^(CPAlertAction * _Nonnull) {
            NSLog(@"CPAlertActionStyleCancel");
        }];
        CPAlertAction *action_3 = [[CPAlertAction alloc] initWithTitle:@"CPAlertActionStyleDestructive" style:CPAlertActionStyleDestructive handler:^(CPAlertAction * _Nonnull) {
            NSLog(@"CPAlertActionStyleDestructive");
        }];
        
        CPActionSheetTemplate *actionSheetTemplate = [[CPActionSheetTemplate alloc] initWithTitle:@"Title" message:@"Message" actions:@[action_1, action_2, action_3]];
        [action_1 release];
        [action_2 release];
        [action_3 release];
        
        [interfaceController presentTemplate:actionSheetTemplate animated:YES completion:^(BOOL success, NSError * _Nullable error) {
            assert(error == nil);
            assert(success);
        }];
        [actionSheetTemplate release];
    }];
    
    CPInformationTemplate *informationTemplate = [[CPInformationTemplate alloc] initWithTitle:@"Title"
                                                                                       layout:CPInformationTemplateLayoutTwoColumn
                                                                                        items:@[]
                                                                                      actions:@[action]];
    
    [action release];
    
    return [informationTemplate autorelease];
}

@end
