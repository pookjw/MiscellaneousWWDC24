//
//  OrnamentViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/8/25.
//

#import "OrnamentViewController.h"
#import "OrnamentChildViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "MRUISize3D.h"
#import "SPPoint3D.h"

/*
 mrui_nonOrnamentPresentingViewController
 mrui_ornamentsItem
 _setOrnamentsDepthDisplacement:
 _ornamentsDepthDisplacement
 */

@interface OrnamentViewController ()

@end

@implementation OrnamentViewController

- (void)loadView {
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    self.view = button;
    [button release];
    
    
    SPPoint3D point = SPPoint3DMake(200., 0., 0.);
    id position = reinterpret_cast<id (*)(id, SEL, SPPoint3D *)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnamentRelativePosition") alloc], sel_registerName("initWithAnchorPoint:"), &point);
    NSLog(@"%@", position);
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
    [archiver encodeObject:position forKey:@"position"];
    [archiver finishEncoding];
    NSData *data = [archiver encodedData];
    [archiver release];
    
    NSError * _Nullable error = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
    assert(error == nil);
    id position_2 = [unarchiver decodeObjectOfClass:objc_lookUpClass("MRUIPlatterOrnamentRelativePosition") forKey:@"position"];
    [unarchiver release];
    NSLog(@"%@", position_2);
    
    {
        SPPoint3D point_1 = SPPoint3DMake(100., 200., 300.);
        NSString *string_1 = _NSStringFromSPPoint3D(&point_1);
        NSLog(@"%@", string_1);
        SPPoint3D point_2 = _SPPoint3DFromString(string_1);
        NSString *string_2 = _NSStringFromSPPoint3D(&point_2);
        NSLog(@"%@", string_2);
    }
    
    [position release];
    
    //
    
    NSLog(@"%@", mui_NSStringFromMRUISize3D(MRUISize3DMake(100., 200., 300.)));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _presentMenu];
}

- (void)_presentMenu {
    UIButton *button = static_cast<UIButton *>(self.view);
    for (__kindof UIContextMenuInteraction *interaction in button.interactions) {
        if (![interaction isKindOfClass:[UIContextMenuInteraction class]]) continue;
        reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(interaction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
        break;
    }
}

- (UIMenu *)_makeMenu {
    // MRUIOrnamentsItem
    id mrui_ornamentsItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("mrui_ornamentsItem"));
    NSArray *_allOrnaments = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_allOrnaments"));
    NSMutableArray<UIAction *> *children = [NSMutableArray new];
    
    //
    
    {
        BOOL _ornamentsArePresented = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_ornamentsArePresented"));
        UIAction *action = [UIAction actionWithTitle:@"Ornaments Are Presented" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        
        action.attributes = UIMenuElementAttributesDisabled;
        action.state = _ornamentsArePresented ? UIMenuElementStateOn : UIMenuElementStateOff;
        
        [children addObject:action];
    }
    
    //
    
    {
        UIAction *action = [UIAction actionWithTitle:@"Add Ornament Item" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            OrnamentChildViewController *viewController = [OrnamentChildViewController new];
            
            id ornament = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnament") alloc], sel_registerName("initWithViewController:"), viewController);
            [viewController release];
            
            reinterpret_cast<void (*)(id, SEL, CGSize)>(objc_msgSend)(ornament, sel_registerName("setPreferredContentSize:"), CGSizeMake(400., 400.));
//            reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(ornament, sel_registerName("_setZOffset:"), 500.);
            id position = reinterpret_cast<id (*)(id, SEL, MRUISize3D)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnamentRelativePosition") alloc], sel_registerName("initWithAnchorPoint:"), MRUISize3DMake(0., 0., 400));
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(ornament, sel_registerName("setPosition:"), position);
            [position release];
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_setAllOrnaments:"), [_allOrnaments arrayByAddingObject:ornament]);
            [ornament release];
        }];
        
        [children addObject:action];
    }
    
    //
    
    UIMenu *menu = [UIMenu menuWithChildren:children];
    [children release];
    
    return menu;
}

@end
