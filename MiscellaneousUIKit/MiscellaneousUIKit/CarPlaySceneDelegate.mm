//
//  CarPlaySceneDelegate.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/28/24.
//

// SBStarkCapable로 CarPlay API 및 UIKit 써보기

#import "CarPlaySceneDelegate.h"

@interface CarPlaySceneDelegate ()
@property (retain, nonatomic, nullable) CPInterfaceController *_interfaceController;
@end

@implementation CarPlaySceneDelegate

- (void)dealloc {
    [__interfaceController release];
    [super dealloc];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController {
    self._interfaceController = interfaceController;
    
    [interfaceController setRootTemplate:[self _makeRootTemplate] animated:YES completion:^(BOOL success, NSError * _Nullable error) {
        assert(error == nil);
        assert(success);
    }];
}

- (CPListTemplate *)_makeRootTemplate {
    NSArray<NSString *> *titles = @[
        @"CPListTemplate"
    ];
    NSArray<__kindof CPTemplate *> *templates = @[
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
    NSMutableArray<CPListSection *> *sections = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSUInteger sectionIndex = 0; sectionIndex < 10; sectionIndex++) {
        NSMutableArray<id<CPListTemplateItem>> *items = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSUInteger itemIndex = 0; itemIndex < 3; itemIndex++) {
            CPListImageRowItem *item = [[CPListImageRowItem alloc] initWithText:@(itemIndex).stringValue
                                                                         images:@[
                [UIImage systemImageNamed:@"pencil.circle"],
                [UIImage systemImageNamed:@"folder.fill.badge.plus"]
            ]
                                                                    imageTitles:@[
                @"pencil.circle",
                @"folder.fill.badge.plus"
            ]];
            
            [items addObject:item];
            [item release];
        }
        
        CPListSection *section = [[CPListSection alloc] initWithItems:items header:@(sectionIndex).stringValue
                                                       headerSubtitle:@"Header"
                                                          headerImage:[UIImage systemImageNamed:@"richtext.page"]
                                                         headerButton:nil
                                                    sectionIndexTitle:@"😞"];
        
        [sections addObject:section];
        [section release];
    }
    
    //
    
    CPAssistantCellConfiguration *assistantCellConfiguration = [[CPAssistantCellConfiguration alloc] initWithPosition:CPAssistantCellPositionTop visibility:CPAssistantCellVisibilityAlways assistantAction:CPAssistantCellActionTypePlayMedia];
    
    //
    
    CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:@"Hello World!" sections:sections assistantCellConfiguration:assistantCellConfiguration];
    [sections release];
    [assistantCellConfiguration release];
    
    return [listTemplate autorelease];
}

@end
