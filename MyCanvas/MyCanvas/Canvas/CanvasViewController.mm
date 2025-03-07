//
//  CanvasViewController.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "CanvasViewController.h"
#import <PencilKit/PencilKit.h>
#import "NSStringFromPKCanvasViewDrawingPolicy.h"
#include <ranges>
#include <vector>
#import "NSStringFromPKContentVersion.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#import "NSStringFromUIUserInterfaceStyle.h"
#import <TargetConditionals.h>
#import "ToolItemsConfigurationViewController.h"

/*
 -[PKTiledCanvasView _drawingEnded:estimatesTimeout:completion:]
 -[PKTiledView canvasViewDidEndDrawing:]
 PKWelcomeController
 */

__attribute__((objc_direct_members))
@interface CanvasViewController () <PKCanvasViewDelegate, PKToolPickerDelegate, PKToolPickerObserver, ToolItemsConfigurationViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_canvas) MCCanvas *canvas;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_canvasView) PKCanvasView *canvasView;
@property (retain, nonatomic, getter=_toolPicker, setter=_setToolPicker:) PKToolPicker *toolPicker;
@property (retain, nonatomic, readonly, getter=_doneBarButtonItem) UIBarButtonItem *doneBarButtonItem;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_undoBarButtonItem) UIBarButtonItem *undoBarButtonItem;
@property (retain, nonatomic, readonly, getter=_redoBarButtonItem) UIBarButtonItem *redoBarButtonItem;
@property (retain, nonatomic, readonly, getter=_toolPickerAccessoryItem) UIBarButtonItem *toolPickerAccessoryItem;
@end

@implementation CanvasViewController
@synthesize imageView = _imageView;
@synthesize canvasView = _canvasView;
@synthesize toolPicker = _toolPicker;
@synthesize doneBarButtonItem = _doneBarButtonItem;
@synthesize menuBarButtonItem = _menuBarButtonItem;
@synthesize undoBarButtonItem = _undoBarButtonItem;
@synthesize redoBarButtonItem = _redoBarButtonItem;
@synthesize toolPickerAccessoryItem = _toolPickerAccessoryItem;

+ (void)load {
    dlopen("/System/Library/PrivateFrameworks/PencilPairingUI.framework/PencilPairingUI", RTLD_NOW);
    
    if (Protocol *PNPWelcomeControllerDelegate = NSProtocolFromString(@"PNPWelcomeControllerDelegate")) {
        assert(class_addProtocol(self, PNPWelcomeControllerDelegate));
    }
}

- (instancetype)initWithCanvas:(MCCanvas *)canvas {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _canvas = [canvas retain];
        
        PKToolPicker *toolPicker = [PKToolPicker new];
        self.toolPicker = toolPicker;
        [toolPicker release];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_canvas release];
    [_imageView release];
    [_canvasView release];
    [_toolPicker release];
    [_doneBarButtonItem release];
    [_menuBarButtonItem release];
    [_undoBarButtonItem release];
    [_redoBarButtonItem release];
    [_toolPickerAccessoryItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.imageView);
    
    [self.view addSubview:self.canvasView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.canvasView);
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.trailingItemGroups = @[
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil
                                                         items:@[
            self.undoBarButtonItem,
            self.redoBarButtonItem
        ]],
        
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[
            self.menuBarButtonItem,
            self.doneBarButtonItem
        ]]
    ];
    
    navigationItem.style = UINavigationItemStyleEditor;
    
    [self.canvas.managedObjectContext performBlock:^{
        PKDrawing *drawing = self.canvas.drawing;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.canvasView.drawing = drawing;
        });
    }];
    
    [self.canvasView becomeFirstResponder];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didReceiveUndoManagerCheckpointNotification:) name:NSUndoManagerCheckpointNotification object:nil];
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"image" withExtension:@"jpeg"];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    _imageView = imageView;
    return imageView;
}

- (PKCanvasView *)_canvasView {
    if (auto canvasView = _canvasView) return canvasView;
    
    PKCanvasView *canvasView = [PKCanvasView new];
    canvasView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    canvasView.delegate = self;
    canvasView.maximumZoomScale = 10.;
    
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(canvasView, sel_registerName("setSupportsCopyAsText:"), YES);
    
    _canvasView = canvasView;
    return canvasView;
}

- (void)_setToolPicker:(PKToolPicker *)toolPicker {
    if (PKToolPicker *oldToolPicker = _toolPicker) {
        oldToolPicker.delegate = nil;
        [oldToolPicker removeObserver:self];
        [oldToolPicker setVisible:NO forFirstResponder:self.canvasView];
        [oldToolPicker release];
    }
    
    _toolPicker = [toolPicker retain];
    
    toolPicker.delegate = self;
    [toolPicker addObserver:self];
    
    toolPicker.stateAutosaveName = self.canvas.objectID.URIRepresentation.path;
    [toolPicker setVisible:YES forFirstResponder:self.canvasView];
    
    MCCanvas *canvas = self.canvas;
    [canvas.managedObjectContext performBlock:^{
        NSDictionary * _Nullable toolPickerState = canvas.toolPickerState;
        if (toolPickerState == nil) return;
        NSArray * _Nullable tools = toolPickerState[@"PKPaletteTools"];
        if (tools == nil) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *key = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(toolPicker, sel_registerName("_paletteViewStateRestorationDefaultsKey"));
            [NSUserDefaults.standardUserDefaults setObject:toolPickerState forKey:key];
            reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(toolPicker, sel_registerName("_restoreToolPickerStateFromRepresentation:notify:"), tools, YES);
        });
    }];
}

- (UIBarButtonItem *)_doneBarButtonItem {
    if (auto doneBarButtonItem = _doneBarButtonItem) return doneBarButtonItem;
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_didTriggerDoneBarButtonItem:)];
    
    _doneBarButtonItem = doneBarButtonItem;
    return doneBarButtonItem;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"] menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIBarButtonItem *)_undoBarButtonItem {
    if (auto undoBarButtonItem = _undoBarButtonItem) return undoBarButtonItem;
    
    UIBarButtonItem *undoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.uturn.backward"] style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerUndoBarButtonItem:)];
    
    _undoBarButtonItem = undoBarButtonItem;
    return undoBarButtonItem;
}

- (UIBarButtonItem *)_redoBarButtonItem {
    if (auto redoBarButtonItem = _redoBarButtonItem) return redoBarButtonItem;
    
    UIBarButtonItem *redoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.uturn.forward"] style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerRedoBarButtonItem:)];
    
    _redoBarButtonItem = redoBarButtonItem;
    return redoBarButtonItem;
}

- (UIBarButtonItem *)_toolPickerAccessoryItem {
    if (auto toolPickerAccessoryItem = _toolPickerAccessoryItem) return toolPickerAccessoryItem;
    
    UIBarButtonItem *toolPickerAccessoryItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"opticaldisc.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerToolPickerAccessoryItem:)];
    
    _toolPickerAccessoryItem = toolPickerAccessoryItem;
    return toolPickerAccessoryItem;
}

- (UIMenu *)_makeMenu {
    PKCanvasView *canvasView = self.canvasView;
    
    __kindof UIView *_tiledView;
    assert(object_getInstanceVariable(canvasView, "_tiledView", reinterpret_cast<void **>(&_tiledView)) != NULL);
    
    __block auto unretainedSelf = self;
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit"];
    
    UIBarButtonItem *toolPickerAccessoryItem = self.toolPickerAccessoryItem;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        PKToolPicker *toolPicker = unretainedSelf.toolPicker;
        NSMutableArray<__kindof UIMenuElement *> *rootChildren = [NSMutableArray new];
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            {
                NSUInteger count;
                const PKCanvasViewDrawingPolicy *allPolicies = allPKCanvasViewDrawingPolicies(&count);
                
                auto actionsVector = std::views::iota(allPolicies, allPolicies + count)
                | std::views::transform([canvasView](const PKCanvasViewDrawingPolicy *ptr) {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromPKCanvasViewDrawingPolicy(*ptr)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        canvasView.drawingPolicy = *ptr;
                    }];
                    
                    action.state = (canvasView.drawingPolicy == *ptr) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Drawing Policy" children:actions];
                [actions release];
                
                menu.subtitle = NSStringFromPKCanvasViewDrawingPolicy(canvasView.drawingPolicy);
                
                [children addObject:menu];
            }
            
            {
                BOOL rulerActive = canvasView.rulerActive;
                UIAction *action = [UIAction actionWithTitle:@"Ruler Active" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    canvasView.rulerActive = !rulerActive;
                }];
                
                action.state = rulerActive ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
            {
                NSUInteger count;
                const PKContentVersion *allVersions = allPKContentVersions(&count);
                
                auto actionsVector = std::views::iota(allVersions, allVersions + count)
                | std::views::transform([canvasView](const PKContentVersion *ptr) {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromPKContentVersion(*ptr)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        canvasView.maximumSupportedContentVersion = *ptr;
                    }];
                    
                    action.state = (canvasView.maximumSupportedContentVersion == *ptr) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Maximum Supported Content Version" children:actions];
                [actions release];
                
                menu.subtitle = NSStringFromPKContentVersion(canvasView.maximumSupportedContentVersion);
                
                [children addObject:menu];
            }
            
            {
                BOOL drawingEnabled = canvasView.drawingEnabled;
                
                UIAction *action = [UIAction actionWithTitle:@"Drawing Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    canvasView.drawingEnabled = !drawingEnabled;
                }];
                
                action.state = drawingEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            {
                BOOL opaque = canvasView.opaque;
                
                UIAction *action = [UIAction actionWithTitle:@"Opaque" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    canvasView.opaque = !opaque;
                }];
                
                action.state = opaque ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            {
                BOOL showDebugOutlines = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(_tiledView, sel_registerName("showDebugOutlines"));
                
                UIAction *action = [UIAction actionWithTitle:@"Show Debug Outlines" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_tiledView, sel_registerName("setShowDebugOutlines:"), !showDebugOutlines);
                }];
                
                action.state = showDebugOutlines ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
            {
                id linedPaper = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_tiledView, sel_registerName("linedPaper"));
                
                UIAction *action = [UIAction actionWithTitle:@"Lined Papper" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    if (linedPaper == nil) {
                        id linedPaper = reinterpret_cast<id (*)(id, SEL, CGPoint, CGFloat)>(objc_msgSend)([objc_lookUpClass("PKLinedPaper") alloc], sel_registerName("initWithLineSpacing:horizontalInset:"), CGPointMake(50., 50.), 50.);
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_tiledView, sel_registerName("setLinedPaper:"), linedPaper);
                        [linedPaper release];
                    } else {
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_tiledView, sel_registerName("setLinedPaper:"), nil);
                    }
                }];
                
                action.state = (linedPaper != nil) ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
            UIMenu *canvasMenu = [UIMenu menuWithTitle:@"Canvas View" children:children];
            [children release];
            [rootChildren addObject:canvasMenu];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            {
                NSUInteger count;
                const PKContentVersion *allVersions = allPKContentVersions(&count);
                
                auto actionsVector = std::views::iota(allVersions, allVersions + count)
                | std::views::transform([toolPicker](const PKContentVersion *ptr) {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromPKContentVersion(*ptr)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        toolPicker.maximumSupportedContentVersion = *ptr;
                    }];
                    
                    action.state = (toolPicker.maximumSupportedContentVersion == *ptr) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Maximum Supported Content Version" children:actions];
                [actions release];
                
                menu.subtitle = NSStringFromPKContentVersion(toolPicker.maximumSupportedContentVersion);
                [children addObject:menu];
            }
            
            {
                CGRect frameObscuredInView = [toolPicker frameObscuredInView:canvasView];
                UIAction *action = [UIAction actionWithTitle:@"Frame Obscured In View (with canvasView)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    
                }];
                
                action.attributes = UIMenuElementAttributesDisabled;
                action.subtitle = NSStringFromCGRect(frameObscuredInView);
                
                [children addObject:action];
            }
            
            {
                NSArray<PKToolPickerItem *> * toolItems = toolPicker.toolItems;
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:toolItems.count];
                
                for (PKToolPickerItem *toolItem in toolItems) {
                    UIAction *action = [UIAction actionWithTitle:toolItem.identifier image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        toolPicker.selectedToolItem = toolItem;
                    }];
                    
                    action.state = ([toolItem isEqual:toolPicker.selectedToolItem]) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [actions addObject:action];
                }
                
                UIMenu *memu = [UIMenu menuWithTitle:@"Tool Items" children:actions];
                [actions release];
                memu.subtitle = toolPicker.selectedToolItem.identifier;
                [children addObject:memu];
            }
            
            {
                NSUInteger count;
                const UIUserInterfaceStyle *allStyles = allUIUserInterfaceStyles(&count);
                
                auto actionsVector = std::views::iota(allStyles, allStyles + count)
                | std::views::transform([toolPicker](const UIUserInterfaceStyle *ptr) {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromUIUserInterfaceStyle(*ptr)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        toolPicker.colorUserInterfaceStyle = *ptr;
                    }];
                    
                    action.state = (toolPicker.colorUserInterfaceStyle == *ptr) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Color User Interface Style" children:actions];
                [actions release];
                menu.subtitle = NSStringFromUIUserInterfaceStyle(toolPicker.colorUserInterfaceStyle);
                
                [children addObject:menu];
            }
            
            {
                NSUInteger count;
                const UIUserInterfaceStyle *allStyles = allUIUserInterfaceStyles(&count);
                
                auto actionsVector = std::views::iota(allStyles, allStyles + count)
                | std::views::transform([toolPicker](const UIUserInterfaceStyle *ptr) {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromUIUserInterfaceStyle(*ptr)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        toolPicker.overrideUserInterfaceStyle = *ptr;
                    }];
                    
                    action.state = (toolPicker.overrideUserInterfaceStyle == *ptr) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Override User Interface Style" children:actions];
                [actions release];
                menu.subtitle = NSStringFromUIUserInterfaceStyle(toolPicker.overrideUserInterfaceStyle);
                
                [children addObject:menu];
            }
            
            {
                BOOL showsDrawingPolicyControls = toolPicker.showsDrawingPolicyControls;
                
                UIAction *action = [UIAction actionWithTitle:@"Shows Drawing Policy Controls" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    toolPicker.showsDrawingPolicyControls = !showsDrawingPolicyControls;
                }];
                
                action.state = showsDrawingPolicyControls ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
            {
                UIBarButtonItem *accessoryItem = toolPicker.accessoryItem;
                
                UIAction *action = [UIAction actionWithTitle:@"Accessory Item" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    if (accessoryItem == nil) {
                        toolPicker.accessoryItem = toolPickerAccessoryItem;
                    } else {
                        toolPicker.accessoryItem = nil;
                    }
                }];
                
                action.state = (accessoryItem != nil) ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
#if TARGET_OS_VISION
            {
                BOOL prefersDismissControlVisible = toolPicker.prefersDismissControlVisible;
                
                UIAction *action = [UIAction actionWithTitle:@"Prefers Dismiss Control Visible" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    toolPicker.prefersDismissControlVisible = !prefersDismissControlVisible;
                }];
                
                action.state = prefersDismissControlVisible ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
#endif
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Tool Picker" children:children];
            [children release];
            [rootChildren addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Present Welcome Controller" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                __kindof UIViewController *viewController = reinterpret_cast<id (*)(Class, SEL, NSInteger, NSInteger, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("PNPWelcomeController"), sel_registerName("controllerWithType:buttonType:deviceType:delegate:"), 8, 0, 0, unretainedSelf);
                [unretainedSelf presentViewController:viewController animated:YES completion:nil];
            }];
            
            [rootChildren addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Open Pencil Preferences" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("PKSettingsDaemon"), sel_registerName("openPencilPreferences"));
                }];
                
                [children addObject:action];
            }
            
            {
                BOOL prefersPencilOnlyDrawing = [userDefaults boolForKey:@"UIPencilOnlyDrawWithPencilKey"];
                
                UIAction *action = [UIAction actionWithTitle:@"Prefers Pencil Only Drawing" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(Class, SEL, BOOL)>(objc_msgSend)(objc_lookUpClass("PKSettingsDaemon"), sel_registerName("setPrefersPencilOnlyDrawing:"), !prefersPencilOnlyDrawing);
                }];
                
                action.state = prefersPencilOnlyDrawing ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"PKSettingsDaemon" children:children];
            [children release];
            [rootChildren addObject:menu];
        }
        
        {
            NSArray<NSString *> *keys = @[
                @"UIPencilPreferredTapAction",
                @"UIPencilPreferredSqueezeAction",
                @"UIPencilOnlyDrawWithPencilKey",
                @"PKUIPencilHoverPreviewEnabledKey",
                @"PKHasEverShownEduUI",
                @"UIPencilHasUsedPassivePencilKey"
            ];
            
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:keys.count];
            
            for (NSString *key in keys) {
                UIAction *action = [UIAction actionWithTitle:key image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    
                }];
                action.attributes = UIMenuElementAttributesDisabled;
                action.subtitle = [[userDefaults objectForKey:key] description];
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"com.apple.UIKit" children:actions];
            [actions release];
            [rootChildren addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"ToolItemsConfigurationViewController" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                ToolItemsConfigurationViewController *viewController = [[ToolItemsConfigurationViewController alloc] initWithToolItems:toolPicker.toolItems];
                viewController.delegate = unretainedSelf;
                [unretainedSelf presentViewController:viewController animated:YES completion:nil];
                [viewController release];
            }];
            
            [rootChildren addObject:action];
        }
        
        completion(rootChildren);
        [rootChildren release];
    }];
    
    [userDefaults release];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)canvasViewDrawingDidChange:(PKCanvasView *)canvasView {
    PKDrawing *drawing = canvasView.drawing;
    
    MCCanvas *canvas = self.canvas;
    NSManagedObjectContext *managedObjectContext = canvas.managedObjectContext;
    
    [managedObjectContext performBlock:^{
        canvas.lastEditedDate = [NSDate now];
        canvas.drawing = drawing;
        NSError * _Nullable error = nil;
        [managedObjectContext save:&error];
        assert(error == nil);
    }];
}

- (void)canvasViewDidFinishRendering:(PKCanvasView *)canvasView {
    NSLog(@"%s", __func__);
}

- (void)canvasViewDidBeginUsingTool:(PKCanvasView *)canvasView {
    NSLog(@"%s", __func__);
}

- (void)canvasViewDidEndUsingTool:(PKCanvasView *)canvasView {
    NSLog(@"%s", __func__);
}

- (void)_didTriggerDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_didTriggerUndoBarButtonItem:(UIBarButtonItem *)sender {
    [self.canvasView.undoManager undo];
}

- (void)_didTriggerRedoBarButtonItem:(UIBarButtonItem *)sender {
    [self.canvasView.undoManager redo];
}

- (void)_didTriggerToolPickerAccessoryItem:(UIBarButtonItem *)sender {
    NSLog(@"Hello World!");
}

- (void)_didReceiveUndoManagerCheckpointNotification:(NSNotification *)notification {
    if (!NSThread.isMainThread) return;
    if (![self.canvasView.undoManager isEqual:notification.object]) return;
    
    self.undoBarButtonItem.enabled = self.canvasView.undoManager.canUndo;
    self.redoBarButtonItem.enabled = self.canvasView.undoManager.canRedo;
}

- (void)toolPickerSelectedToolItemDidChange:(PKToolPicker *)toolPicker {
    __kindof PKToolPickerItem *selectedToolItem = toolPicker.selectedToolItem;
    
    __kindof PKTool *tool;
    if ([selectedToolItem isKindOfClass:[PKToolPickerInkingItem class]]) {
        tool = static_cast<PKToolPickerInkingItem *>(selectedToolItem).inkingTool;
    } else if ([selectedToolItem isKindOfClass:[PKToolPickerEraserItem class]]) {
        tool = static_cast<PKToolPickerEraserItem *>(selectedToolItem).eraserTool;
    } else if ([selectedToolItem isKindOfClass:[PKToolPickerLassoItem class]]) {
        tool = static_cast<PKToolPickerLassoItem *>(selectedToolItem).lassoTool;
    } else {
        abort();
    }
    
    self.canvasView.tool = tool;
    
    //
    
    NSString *key = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(toolPicker, sel_registerName("_paletteViewStateRestorationDefaultsKey"));
    NSDictionary *toolPickerState = [NSUserDefaults.standardUserDefaults dictionaryForKey:key];
    
    MCCanvas *canvas = self.canvas;
    NSManagedObjectContext *context = canvas.managedObjectContext;
    [context performBlock:^{
        canvas.toolPickerState = toolPickerState;
        NSError * _Nullable error = nil;
        [context save:&error];
        assert(error == nil);
    }];
}

- (void)toolPickerIsRulerActiveDidChange:(PKToolPicker *)toolPicker {
    self.canvasView.rulerActive = toolPicker.rulerActive;
}

- (void)toolPickerVisibilityDidChange:(PKToolPicker *)toolPicker {
    NSLog(@"%s", __func__);
}

- (void)toolPickerFramesObscuredDidChange:(PKToolPicker *)toolPicker {
    NSLog(@"%s", __func__);
}

- (void)welcomeControllerButtonDidPress:(__kindof UIViewController *)welcomeController {
    NSLog(@"%s", __func__);
}

- (void)toolItemsConfigurationViewController:(ToolItemsConfigurationViewController *)toolItemsConfigurationViewController didFinishWithToolItems:(NSArray<__kindof PKToolPickerItem *> *)toolItems {
    PKToolPicker *toolPicker = [[PKToolPicker alloc] initWithToolItems:toolItems];
    self.toolPicker = toolPicker;
    [toolPicker release];
}

@end
