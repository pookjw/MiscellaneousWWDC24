//
//  CarPlaySceneDelegate.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/28/24.
//

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
    
    CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:@"Hello World!" sections:sections assistantCellConfiguration:nil];
    [sections release];
    
    [interfaceController setRootTemplate:listTemplate animated:YES completion:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

@end
