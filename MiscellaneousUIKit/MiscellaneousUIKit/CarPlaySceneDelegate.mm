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

extern "C" BOOL CPCurrentProcessHasMapsEntitlement(void);

@interface CarPlaySceneDelegate () <CPSessionConfigurationDelegate, CPTabBarTemplateDelegate, CPNowPlayingTemplateObserver, CPMapTemplateDelegate>
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

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController toWindow:(nonnull CPWindow *)window {
    self._interfaceController = interfaceController;
    
    [interfaceController setRootTemplate:[self _makeTabBarTemplate] animated:YES completion:^(BOOL success, NSError * _Nullable error) {
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
    
    // CarPlayServices에서 사용 안하는 값
    navigationSession.currentRoadNameVariants = @[@"A"];
    
    self._navigationSession = navigationSession;
    
    for (CPBarButton *button in mapTemplate.trailingNavigationBarButtons) {
        if ([button.title isEqualToString:@"Cancel"]) {
            button.enabled = YES;
            break;
        }
    }
}

- (void)mapTemplateDidCancelNavigation:(CPMapTemplate *)mapTemplate {
    self._navigationSession = nil;
    
    for (CPBarButton *button in mapTemplate.trailingNavigationBarButtons) {
        if ([button.title isEqualToString:@"Cancel"]) {
            button.enabled = NO;
            break;
        }
    }
}

- (BOOL)mapTemplateShouldProvideNavigationMetadata:(CPMapTemplate *)mapTemplate {
    return YES;
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
        NSStringFromClass([CPMapTemplate class]),
        NSStringFromClass([CPNowPlayingTemplate class]),
        NSStringFromClass([CPMessageComposeBarButton class]),
        NSStringFromClass([CPGridTemplate class]),
        NSStringFromClass([CPListTemplate class])
    ];
    NSArray<__kindof CPTemplate *> *templates = @[
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
            
            trip.destinationNameVariants = @[@"Short", @"LongLongLongLong"];
            
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
            
            trip.destinationNameVariants = @[@"Short", @"LongLongLongLong"];
            
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
        
        CPLaneGuidance *laneGuidance = [CPLaneGuidance new];
        laneGuidance.instructionVariants = @[@"instructionVariant 1"];
        
        NSMeasurement *angle_1 = [[NSMeasurement alloc] initWithDoubleValue:30. unit:[NSUnitAngle degrees]];
        NSMeasurement *angle_2 = [[NSMeasurement alloc] initWithDoubleValue:40. unit:[NSUnitAngle degrees]];
        NSMeasurement *angle_3 = [[NSMeasurement alloc] initWithDoubleValue:90. unit:[NSUnitAngle degrees]];
        NSMeasurement *angle_4 = [[NSMeasurement alloc] initWithDoubleValue:120. unit:[NSUnitAngle degrees]];
        CPLane *lane_1 = [[CPLane alloc] initWithAngles:@[angle_1, angle_2, angle_3, angle_4]
                                       highlightedAngle:angle_3
                                            isPreferred:YES];
        [angle_1 release];
        [angle_2 release];
        [angle_3 release];
        [angle_4 release];
        
        laneGuidance.lanes = @[lane_1];
        [lane_1 release];
        
        [navigationSession addLaneGuidances:@[laneGuidance]];
        navigationSession.currentLaneGuidance = laneGuidance;
        [laneGuidance release];
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
        
        CPTravelEstimates *initialTravelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                                       distanceRemainingToDisplay:distanceRemaining
                                                                                    timeRemaining:200.];
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
            [navigationSession addManeuvers:@[maneuver]];
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
            
            navigationSession.upcomingManeuvers = @[maneuver_1, maneuver_2];
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
        [unretained._navigationSession cancelTrip];
    }];
    cancelNavigationButton.enabled = NO;
    
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
        
        CPTravelEstimates *travelEstimates = [[CPTravelEstimates alloc] initWithDistanceRemaining:distanceRemaining
                                                                       distanceRemainingToDisplay:distanceRemaining
                                                                                    timeRemaining:double_dist(gen)];
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
    }];
    
    CPBarButton *finishBarButton = [[CPBarButton alloc] initWithTitle:@"Finish" handler:^(CPBarButton * _Nonnull) {
        CPNavigationSession *navigationSession = unretained._navigationSession;
        if (navigationSession == nil) return;
        
        [navigationSession finishTrip];
    }];
    
    mapTemplate.leadingNavigationBarButtons = @[pauseOrResumeBarButton, finishBarButton];
    [pauseOrResumeBarButton release];
    [finishBarButton release];
    mapTemplate.trailingNavigationBarButtons = @[cancelNavigationButton, updateEstimatesButton];
    [cancelNavigationButton release];
    [updateEstimatesButton release];
    
    //
    
    return [mapTemplate autorelease];
}

@end
