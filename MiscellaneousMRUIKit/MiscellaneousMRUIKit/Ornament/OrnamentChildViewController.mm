//
//  OrnamentChildViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/8/25.
//

#import "OrnamentChildViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "SPGeometry.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface OrnamentChildViewController ()
@property (retain, nonatomic, readonly, getter=_ornamentStatusRegistration) id<UITraitChangeRegistration> ornamentStatusRegistration;
@end

@implementation OrnamentChildViewController

+ (UIMenu *)_point3DMenuWithTitle:(NSString *)title
                         subtitle:(NSString * _Nullable)subtitle
            minValuePointResolver:(SPPoint3D (^)())minValuePointResolver
            maxValuePointResolder:(SPPoint3D (^)())maxValuePointResolver
                    pointResolver:(SPPoint3D (^)(void))pointResolver
                 didUpdateHandler:(void (^)(SPPoint3D point))didUpdateHandler {
    NSMutableArray<UIMenu *> *menus = [NSMutableArray new];
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                __kindof UISlider *slider = [objc_lookUpClass("_UIPrototypingMenuSlider") new];
                slider.minimumValue = minValuePointResolver().x;
                slider.maximumValue = maxValuePointResolver().x;
                slider.value = pointResolver().x;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    SPPoint3D point = pointResolver();
                    point.x = slider.value;
                    didUpdateHandler(point);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"X" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                __kindof UISlider *slider = [objc_lookUpClass("_UIPrototypingMenuSlider") new];
                slider.minimumValue = minValuePointResolver().y;
                slider.maximumValue = maxValuePointResolver().y;
                slider.value = pointResolver().y;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    SPPoint3D point = pointResolver();
                    point.y = slider.value;
                    didUpdateHandler(point);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Y" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                __kindof UISlider *slider = [objc_lookUpClass("_UIPrototypingMenuSlider") new];
                slider.minimumValue = minValuePointResolver().z;
                slider.maximumValue = maxValuePointResolver().z;
                slider.value = pointResolver().z;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    SPPoint3D point = pointResolver();
                    point.z = slider.value;
                    didUpdateHandler(point);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Z" children:@[element]];
        [menus addObject:menu];
    }
    
    //
    
    UIMenu *menu = [UIMenu menuWithTitle:title children:menus];
    [menus release];
    menu.subtitle = subtitle;
    
    return menu;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _comonInit_OrnamentChildViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _comonInit_OrnamentChildViewController];
    }
    
    return self;
}

- (void)dealloc {
    [(NSObject *)_ornamentStatusRegistration release];
    [super dealloc];
}

- (void)_comonInit_OrnamentChildViewController {
    _ornamentStatusRegistration = [[self registerForTraitChanges:@[objc_lookUpClass("MRUITraitOrnamentStatus")] withHandler:^(__kindof id<UITraitEnvironment>  _Nonnull traitEnvironment, UITraitCollection * _Nonnull previousCollection) {
        NSInteger mrui_ornamentStatus = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(traitEnvironment.traitCollection, sel_registerName("mrui_ornamentStatus"));
        
        NSLog(@"mrui_ornamentStatus: %ld", mrui_ornamentStatus);
    }] retain];
    
    NSInteger mrui_ornamentStatus = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(self.traitCollection, sel_registerName("mrui_ornamentStatus"));
    NSLog(@"mrui_ornamentStatus: %ld", mrui_ornamentStatus);
}

- (void)loadView {
    UIButton *button = [UIButton new];
    
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    button.showsMenuAsPrimaryAction = YES;
    button.menu = [self _makeMenu];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("sws_enablePlatter"));
    
    self.view = button;
    [button release];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (window) {
        [self _presentMenu];
    }
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
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        __kindof UIViewController *parentViewController = weakSelf.parentViewController;
        assert([parentViewController isKindOfClass:objc_lookUpClass("_MRUIPlatterOrnamentRootViewController")]);
        id ornament = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(parentViewController, sel_registerName("ornament"));
        
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        //
        
        {
            UIMenu *menu = [OrnamentChildViewController _point3DMenuWithTitle:@"Relative Position"
                                                                     subtitle:@"Equal to CGPoint sceneAnchorPoint"
                                                        minValuePointResolver:^SPPoint3D{
                return SPPoint3DMake(0., 0., 0.);
            }
                                                        maxValuePointResolder:^SPPoint3D{
                return SPPoint3DMake(1., 1., 1.);
            }
                                                                pointResolver:^SPPoint3D{
                id position = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("position"));
                return reinterpret_cast<SPPoint3D (*)(id, SEL)>(objc_msgSend)(position, sel_registerName("anchorPoint"));
            }
                                                             didUpdateHandler:^(SPPoint3D point) {
                id position = reinterpret_cast<id (*)(id, SEL, SPPoint3D)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnamentRelativePosition") alloc], sel_registerName("initWithAnchorPoint:"), point);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(ornament, sel_registerName("setPosition:"), position);
                [position release];
            }];
            
            [children addObject:menu];
        }
        
        {
            UIMenu *menu = [OrnamentChildViewController _point3DMenuWithTitle:@"Anchor Position"
                                                                     subtitle:@"Equal to CAPoint3D anchorPoint"
                                                        minValuePointResolver:^SPPoint3D{
                CGRect frame = weakSelf.view.frame;
                return SPPoint3DMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 0.);
            }
                                                        maxValuePointResolder:^SPPoint3D{
                CGRect frame = weakSelf.view.frame;
                return SPPoint3DMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame), 0.);
            }
                                                                pointResolver:^SPPoint3D{
                return reinterpret_cast<SPPoint3D (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("anchorPosition"));
            }
                                                             didUpdateHandler:^(SPPoint3D point) {
                reinterpret_cast<void (*)(id, SEL, SPPoint3D)>(objc_msgSend)(ornament, sel_registerName("setAnchorPosition:"), point);
            }];
            
            [children addObject:menu];
        }
        
        {
            UIMenu *menu = [OrnamentChildViewController _point3DMenuWithTitle:@"Attachment Position"
                                                                     subtitle:@"Not Working. Equal to CAPoint3D attachmentPoint"
                                                        minValuePointResolver:^SPPoint3D{
                CGRect bounds = weakSelf.view.bounds;
                return SPPoint3DMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), 0.);
            }
                                                        maxValuePointResolder:^SPPoint3D{
                CGRect bounds = weakSelf.view.bounds;
                return SPPoint3DMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), 0.);
            }
                                                                pointResolver:^SPPoint3D{
                return reinterpret_cast<SPPoint3D (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("attachmentPosition"));
            }
                                                             didUpdateHandler:^(SPPoint3D point) {
                reinterpret_cast<void (*)(id, SEL, SPPoint3D)>(objc_msgSend)(ornament, sel_registerName("setAttachmentPosition:"), point);
//                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("_setNeedsUpdate"));
            }];
            
            [children addObject:menu];
        }
        
        {
            UIMenu *menu = [OrnamentChildViewController _point3DMenuWithTitle:@"Offset"
                                                                     subtitle:@"_setZOffset: is deprecated."
                                                        minValuePointResolver:^SPPoint3D{
                return SPPoint3DMake(-600., -600., -600.);
            }
                                                        maxValuePointResolder:^SPPoint3D{
                return SPPoint3DMake(600., 600., 600.);
            }
                                                                pointResolver:^SPPoint3D{
                return reinterpret_cast<SPPoint3D (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("offset"));
            }
                                                             didUpdateHandler:^(SPPoint3D point) {
                return reinterpret_cast<void (*)(id, SEL, SPPoint3D)>(objc_msgSend)(ornament, sel_registerName("setOffset:"), point);
            }];
            
            [children addObject:menu];
        }
        
        {
            UIMenu *menu = [OrnamentChildViewController _point3DMenuWithTitle:@"Preferred Content Size"
                                                                     subtitle:@"Z is not supported"
                                                        minValuePointResolver:^SPPoint3D{
                return SPPoint3DMake(0., 0., 0.);
            }
                                                        maxValuePointResolder:^SPPoint3D{
                return SPPoint3DMake(1000., 1000., 0.);
            }
                                                                pointResolver:^SPPoint3D{
                CGSize preferredContentSize = reinterpret_cast<CGSize (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("preferredContentSize"));
                return SPPoint3DMake(preferredContentSize.width, preferredContentSize.height, 0.);
            }
                                                             didUpdateHandler:^(SPPoint3D point) {
                CGSize preferredContentSize = CGSizeMake(point.x, point.y);
                reinterpret_cast<void (*)(id, SEL, CGSize)>(objc_msgSend)(ornament, sel_registerName("setPreferredContentSize:"), preferredContentSize);
            }];
            
            [children addObject:menu];
        }
        
        {
            BOOL canFollowUser = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("canFollowUser"));
            UIAction *action = [UIAction actionWithTitle:@"Can Follow User" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(ornament, sel_registerName("setCanFollowUser:"), !canFollowUser);
            }];
            action.state = canFollowUser ? UIMenuElementStateOn : UIMenuElementStateOff;
            
            [children addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Remove Ornament" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                id _ornamentManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(ornament, sel_registerName("_ornamentManager"));
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_ornamentManager, sel_registerName("removeOrnament:"), ornament);
            }];
            
            action.attributes = UIMenuElementAttributesDestructive;
            [children addObject:action];
        }
        
        //
        
        completion(children);
        [children release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
