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
#import "CanvasCustomItemInteraction.h"
#import "MyCanvas-Swift.h"
#import "NSDictionary+MCCategory.h"

/*
 -[PKTiledCanvasView _drawingEnded:estimatesTimeout:completion:]
 -[PKTiledView canvasViewDidEndDrawing:]
 PKWelcomeController
 */

__attribute__((objc_direct_members))
@interface CanvasViewController () <PKCanvasViewDelegate, PKToolPickerDelegate, PKToolPickerObserver, CanvasCustomItemInteractionDelegate> {
    NSUndoManager *_undoManager;
}
@property (class, nonatomic, readonly, getter=_imageViewObjectIDKey) void *imageViewObjectIDKey;
@property (retain, nonatomic, readonly, getter=_canvas) MCCanvas *canvas;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_canvasView) PKCanvasView *canvasView;
@property (retain, nonatomic, readonly, getter=_customItemsContainerView) UIView *customItemsContainerView;
@property (retain, nonatomic, getter=_toolPicker, setter=_setToolPicker:) PKToolPicker *toolPicker;
@property (retain, nonatomic, getter=_customItemInteraction) CanvasCustomItemInteraction *customItemInteraction;
@property (retain, nonatomic, nullable, getter=_hoverImageView, setter=_sethoverImageView:) UIImageView *hoverImageView;
@property (retain, nonatomic, readonly, getter=_doneBarButtonItem) UIBarButtonItem *doneBarButtonItem;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_undoBarButtonItem) UIBarButtonItem *undoBarButtonItem;
@property (retain, nonatomic, readonly, getter=_redoBarButtonItem) UIBarButtonItem *redoBarButtonItem;
@property (retain, nonatomic, readonly, getter=_toolPickerAccessoryItem) UIBarButtonItem *toolPickerAccessoryItem;
@end

@implementation CanvasViewController
@synthesize imageView = _imageView;
@synthesize canvasView = _canvasView;
@synthesize customItemsContainerView = _customItemsContainerView;
@synthesize toolPicker = _toolPicker;
@synthesize customItemInteraction = _customItemInteraction;
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

+ (void *)_imageViewObjectIDKey {
    static void *key = &key;
    return key;
}

- (instancetype)initWithCanvas:(MCCanvas *)canvas {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _canvas = [canvas retain];
        
        PKToolPicker *toolPicker = [PKToolPicker new];
        
        NSMutableArray<PKToolPickerItem *> *toolItems = [toolPicker.toolItems mutableCopy];
        [toolPicker release];
        
        {
            PKToolPickerCustomItemConfiguration *configuration = [[PKToolPickerCustomItemConfiguration alloc] initWithIdentifier:[NSUUID UUID].UUIDString name:[NSUUID UUID].UUIDString];
            configuration.defaultColor = UIColor.systemCyanColor;
            configuration.allowsColorSelection = YES;
            configuration.widthVariants = @{
                @(10.0): [UIImage systemImageNamed:@"10.circle"],
                @(20.0): [UIImage systemImageNamed:@"20.circle"],
                @(30.0): [UIImage systemImageNamed:@"30.circle"],
                @(40.0): [UIImage systemImageNamed:@"40.circle"],
                @(50.0): [UIImage systemImageNamed:@"50.circle"]
            };
            configuration.imageProvider = ^UIImage * _Nonnull(PKToolPickerCustomItem * _Nonnull toolPickerItem) {
                return [UIImage systemImageNamed:@"apple.intelligence"];
            };
            configuration.viewControllerProvider = ^UIViewController * _Nonnull(PKToolPickerCustomItem * _Nonnull toolPickerItem) {
                UIViewController *viewController = [UIViewController new];
                UILabel *label = [UILabel new];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"Hello World";
                [label sizeToFit];
                viewController.view = label;
                [label release];
                return [viewController autorelease];
            };
            
            PKToolPickerCustomItem *customItem = [[PKToolPickerCustomItem alloc] initWithConfiguration:configuration];
            [configuration release];
            customItem.width = 30.;
            
            [toolItems addObject:customItem];
            [customItem release];
        }
        
        toolPicker = [[PKToolPicker alloc] initWithToolItems:toolItems];
        [toolItems release];
        toolPicker.selectedToolItem = toolPicker.toolItems.lastObject;
        
        self.toolPicker = toolPicker;
        [toolPicker release];
        
        _undoManager = [NSUndoManager new];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_canvas release];
    [_imageView release];
    [_canvasView release];
    [_customItemsContainerView release];
    [_toolPicker release];
    [_customItemInteraction release];
    [_hoverImageView release];
    [_doneBarButtonItem release];
    [_menuBarButtonItem release];
    [_undoBarButtonItem release];
    [_redoBarButtonItem release];
    [_toolPickerAccessoryItem release];
    [super dealloc];
}

- (NSUndoManager *)undoManager {
    return _undoManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addInteraction:self.customItemInteraction];
    
    [self.view addSubview:self.imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.imageView);
    
    [self.view addSubview:self.canvasView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.canvasView);
    
    [self.view addSubview:self.customItemsContainerView];
    [self _updateCustomItemsContainerView];
    
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
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didReceiveUndoManagerCheckpointNotification:) name:NSUndoManagerCheckpointNotification object:nil];
    [self _reloadCanvas];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.canvasView becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self _updateCustomItemsContainerView];
}

- (void)_reloadCanvas __attribute__((objc_direct)) {
    for (UIView *subview in self.customItemsContainerView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.canvas.managedObjectContext performBlock:^{
        PKDrawing *drawing = self.canvas.drawing;
        
        NSOrderedSet<MCCustomItem *> *customItems = self.canvas.customItems;
        NSMutableArray<NSDictionary *> *faultedCustomItems = [NSMutableArray new];
        for (MCCustomItem *customItem in customItems) {
            NSString *systemImageName = customItem.systemImageName;
            if (systemImageName == nil) continue;
            
            CGRect frame = customItem.cgFrame;
            if (CGRectIsNull(frame)) continue;
            
            CGColorRef tintColor = [customItem cgTintColor];
            if (tintColor == NULL) continue;
            
            NSDictionary *result = @{
                @"systemImageName": systemImageName,
                @"frame": @(frame),
                @"tintColor": [UIColor colorWithCGColor:tintColor],
                @"transform": [NSValue valueWithCGAffineTransform:customItem.cgAffineTransform],
                @"objectID": customItem.objectID
            };
            
            CGColorRelease(tintColor);
            
            [faultedCustomItems addObject:result];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *customItem in faultedCustomItems) {
                UIImage *image = [UIImage systemImageNamed:customItem[@"systemImageName"]];
                CGRect frame = static_cast<NSNumber *>(customItem[@"frame"]).CGRectValue;
                UIColor *tintColor = customItem[@"tintColor"];
                CGAffineTransform transform = static_cast<NSValue *>(customItem[@"transform"]).CGAffineTransformValue;
                NSManagedObjectID *objectID = customItem[@"objectID"];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                imageView.image = image;
                imageView.tintColor = tintColor;
                imageView.transform = transform;
                objc_setAssociatedObject(imageView, CanvasViewController.imageViewObjectIDKey, objectID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                [self.customItemsContainerView addSubview:imageView];
                [imageView release];
            }
            
            self.canvasView.drawing = drawing;
        });
        
        [faultedCustomItems release];
    }];
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
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(canvasView, sel_registerName("setPreservesCenterDuringRotation:"), YES);
    
    _canvasView = canvasView;
    
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(canvasView, sel_registerName("setSupportsCopyAsText:"), YES);
    
    return canvasView;
}

- (UIView *)_customItemsContainerView {
    if (auto customItemsContainerView = _customItemsContainerView) return customItemsContainerView;
    
    UIView *customItemsContainerView = [UIView new];
    customItemsContainerView.userInteractionEnabled = NO;
//    customItemsContainerView.backgroundColor = [UIColor.systemPinkColor colorWithAlphaComponent:0.3];
    
    _customItemsContainerView = customItemsContainerView;
    return customItemsContainerView;
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

- (void)_resetStateAutosave __attribute__((objc_direct)) {
    PKToolPicker *toolPicker = [[PKToolPicker alloc] initWithToolItems:@[]];
    toolPicker.stateAutosaveName = self.canvas.objectID.URIRepresentation.path;
    NSString *key = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(toolPicker, sel_registerName("_paletteViewStateRestorationDefaultsKey"));
    [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
    [toolPicker release];
}

- (UIImage *)_customItemsImage {
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat formatForTraitCollection:self.customItemsContainerView.traitCollection];
    
    CGRect bounds = self.canvasView.drawing.bounds;
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) format:format];
    
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextSaveGState(rendererContext.CGContext);
        CGContextTranslateCTM(rendererContext.CGContext, -CGRectGetMinX(bounds), -CGRectGetMinY(bounds));
        assert([self.customItemsContainerView drawViewHierarchyInRect:self.customItemsContainerView.bounds afterScreenUpdates:YES]);
        CGContextRestoreGState(rendererContext.CGContext);
    }];
    [renderer release];
    
    return image;
}

- (void)_contextQueue_updateThumbnailImageWithDrawing:(PKDrawing *)drawing traitCollection:(UITraitCollection *)traitCollection __attribute__((objc_direct)) {
    UIImage *image = [drawing imageFromRect:drawing.bounds scale:traitCollection.displayScale];
    MCCanvas *canvas = self.canvas;
    canvas.canvasImageData = UIImagePNGRepresentation(image);
}

- (CanvasCustomItemInteraction *)_customItemInteraction {
    if (auto customItemInteraction = _customItemInteraction) return customItemInteraction;
    
    CanvasCustomItemInteraction *customItemInteraction = [CanvasCustomItemInteraction new];
    customItemInteraction.delegate = self;
    
    _customItemInteraction = customItemInteraction;
    return customItemInteraction;
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

- (UIMenu *)_makeMenu __attribute__((objc_direct)) {
    PKCanvasView *canvasView = self.canvasView;
    
    __kindof UIView *_tiledView;
    assert(object_getInstanceVariable(canvasView, "_tiledView", reinterpret_cast<void **>(&_tiledView)) != NULL);
    
    __block auto unretainedSelf = self;
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit"];
    
    UIBarButtonItem *toolPickerAccessoryItem = self.toolPickerAccessoryItem;
    MCCanvas *canvas = self.canvas;
    
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
                __kindof UIViewController *viewController = makeToolItemsConfigurationHostingController(toolPicker.toolItems, ^(NSArray<PKToolPickerItem *> *toolItems) {
                    [unretainedSelf _resetStateAutosave];
                    PKToolPicker *toolPicker = [[PKToolPicker alloc] initWithToolItems:toolItems];
                    unretainedSelf.toolPicker = toolPicker;
                    [toolPicker release];
                    [unretainedSelf.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                });
                
                [unretainedSelf presentViewController:viewController animated:YES completion:nil];
            }];
            
            [rootChildren addObject:action];
        }
        
        {
            UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
                NSManagedObjectContext *context = canvas.managedObjectContext;
                [context performBlock:^{
                    NSPersistentHistoryChangeRequest *request = [NSPersistentHistoryChangeRequest fetchHistoryAfterDate:[NSDate dateWithTimeIntervalSince1970:0.]];
                    request.resultType = NSPersistentHistoryResultTypeTransactionsAndChanges;
                    
                    NSError * _Nullable error = nil;
                    NSPersistentHistoryResult *result = [context executeRequest:request error:&error];
                    NSArray<NSPersistentHistoryTransaction *> *transactions = result.result;
                    assert(error == nil);
                    
                    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:transactions.count];
                    for (NSPersistentHistoryTransaction *transaction in [transactions reverseObjectEnumerator]) {
                        UIAction *action = [UIAction actionWithTitle:@(transaction.transactionNumber).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [unretainedSelf _restoreWithTransaction:transaction];
                        }];
                        
                        [actions addObject:action];
                    }
                    
                    UIMenu *menu = [UIMenu menuWithTitle:@"Histories" children:actions];
                    [actions release];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(@[menu]);
                    });
                }];
            }];
            
            [rootChildren addObject:element];
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
    UITraitCollection *traitCollection = self.traitCollection;
    UIImage *customItemsImage = [self _customItemsImage];
    
    [managedObjectContext performBlock:^{
        canvas.lastEditedDate = [NSDate now];
        canvas.drawing = drawing;
        canvas.customItemsImageData = UIImagePNGRepresentation(customItemsImage);
        [self _contextQueue_updateThumbnailImageWithDrawing:drawing traitCollection:traitCollection];
        
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

- (void)_updateCustomItemsContainerView __attribute__((objc_direct)) {
    CGFloat zoomScale = self.canvasView.zoomScale;
    UIView *contentView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.canvasView, sel_registerName("contentView"));
    CGRect rect = [contentView convertRect:contentView.bounds toView:self.view];
    self.customItemsContainerView.frame = rect;
    self.customItemsContainerView.transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.canvasView]) {
        [self _updateCustomItemsContainerView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.canvasView]) {
        [self _updateCustomItemsContainerView];
    }
}

- (void)_didTriggerDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_didTriggerUndoBarButtonItem:(UIBarButtonItem *)sender {
    [self.undoManager undo];
}

- (void)_didTriggerRedoBarButtonItem:(UIBarButtonItem *)sender {
    [self.undoManager redo];
}

- (void)_didTriggerToolPickerAccessoryItem:(UIBarButtonItem *)sender {
    NSLog(@"Hello World!");
}

- (void)_didReceiveUndoManagerCheckpointNotification:(NSNotification *)notification {
    if (!NSThread.isMainThread) return;
    if (![self.undoManager isEqual:notification.object]) return;
    
    self.undoBarButtonItem.enabled = self.undoManager.canUndo;
    self.redoBarButtonItem.enabled = self.undoManager.canRedo;
}

- (void)toolPickerSelectedToolItemDidChange:(PKToolPicker *)toolPicker {
    if ([self.canvasView respondsToSelector:_cmd]) {
        [self.canvasView toolPickerSelectedToolItemDidChange:toolPicker];
    }
    
    __kindof PKToolPickerItem *selectedToolItem = toolPicker.selectedToolItem;
    
    if ([selectedToolItem isKindOfClass:[PKToolPickerCustomItem class]]) {
        self.customItemInteraction.enabled = YES;
    } else {
        self.customItemInteraction.enabled = NO;
    }
    
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
    if ([self.canvasView respondsToSelector:_cmd]) {
        [self.canvasView toolPickerIsRulerActiveDidChange:toolPicker];
    }
}

- (void)toolPickerVisibilityDidChange:(PKToolPicker *)toolPicker {
    if ([self.canvasView respondsToSelector:_cmd]) {
        [self.canvasView toolPickerVisibilityDidChange:toolPicker];
    }
    
    NSLog(@"%s", __func__);
}

- (void)toolPickerFramesObscuredDidChange:(PKToolPicker *)toolPicker {
    if ([self.canvasView respondsToSelector:_cmd]) {
        [self.canvasView toolPickerFramesObscuredDidChange:toolPicker];
    }
    
    NSLog(@"%s", __func__);
}

- (void)welcomeControllerButtonDidPress:(__kindof UIViewController *)welcomeController {
    NSLog(@"%s", __func__);
}

//- (void)toolItemsConfigurationViewController:(ToolItemsConfigurationViewController *)toolItemsConfigurationViewController didFinishWithToolItems:(NSArray<__kindof PKToolPickerItem *> *)toolItems {
//    PKToolPicker *toolPicker = [[PKToolPicker alloc] initWithToolItems:toolItems];
//    self.toolPicker = toolPicker;
//    [toolPicker release];
//}

- (void)_saveCustomItemWithImageView:(UIImageView *)imageView __attribute__((objc_direct)) {
    assert(imageView.superview != nil);
    
    MCCanvas *canvas = self.canvas;
    NSManagedObjectContext *context = canvas.managedObjectContext;
    CGRect frame = imageView.frame;
    UIColor *tintColor = imageView.tintColor;
    CGAffineTransform transform = imageView.transform;
    
    UIImage *image = imageView.image;
    id imageAsset = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(image, sel_registerName("imageAsset"));
    NSString *assetName = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageAsset, sel_registerName("assetName"));
    assert(assetName != nil);
    
    UIImage *customItemsImage = [self _customItemsImage];
    
    NSManagedObjectModel *managedObjectModel = context.persistentStoreCoordinator.managedObjectModel;
    NSEntityDescription *entity = managedObjectModel.entitiesByName[@"CustomItem"];
    assert(entity != nil);
    
    MCCustomItem *customItem = [[MCCustomItem alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    [context performBlock:^{
        [context insertObject:customItem];
        
        NSError * _Nullable error = nil;
        [context obtainPermanentIDsForObjects:@[customItem] error:&error];
        assert(error == nil);
        objc_setAssociatedObject(imageView, CanvasViewController.imageViewObjectIDKey, customItem.objectID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        customItem.cgFrame = frame;
        customItem.systemImageName = assetName;
        [customItem setCGTintColor:tintColor.CGColor];
        customItem.cgAffineTransform = transform;
        
        [canvas addCustomItemsObject:customItem];
        assert(customItem.canvas != nil);
        
        canvas.customItemsImageData = UIImagePNGRepresentation(customItemsImage);
        
        [context save:&error];
        assert(error == nil);
    }];
    
    [customItem release];
}

- (void)_removeCustomItemWithImageView:(UIImageView *)imageView __attribute__((objc_direct)) {
    UIImage *customItemsImage = [self _customItemsImage];
    MCCanvas *canvas = self.canvas;
    NSManagedObjectContext *context = canvas.managedObjectContext;
    [context performBlock:^{
        NSManagedObjectID *objectID = objc_getAssociatedObject(imageView, CanvasViewController.imageViewObjectIDKey);
        MCCustomItem *object = [context objectWithID:objectID];
//        assert(object != nil);
//        assert(object.canvas != nil);
//        [object.canvas removeCustomItemsObject:object];
        [context deleteObject:object];
        
        canvas.customItemsImageData = UIImagePNGRepresentation(customItemsImage);
        
        NSError * _Nullable error = nil;
        [context save:&error];
        assert(error == nil);
    }];
}

- (void)canvasCustomItemInteraction:(CanvasCustomItemInteraction *)canvasCustomItemInteraction didTriggerTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint location = [tapGestureRecognizer locationInView:self.customItemsContainerView];
    
    for (UIView *subview in self.customItemsContainerView.subviews) {
        if (![subview isKindOfClass:[UIImageView class]]) continue;
        if (!CGRectContainsPoint(subview.frame, location)) continue;
        NSManagedObjectID *objectID = objc_getAssociatedObject(subview, CanvasViewController.imageViewObjectIDKey);
        if (objectID == nil) continue;
        
        UIImageView *imageView = static_cast<UIImageView *>(subview);
        [imageView removeFromSuperview];
        [self _removeCustomItemWithImageView:imageView];
        return;
    }
    
    NSString *systemImageName = @"arrow.up";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:systemImageName]];
    auto customItem = static_cast<PKToolPickerCustomItem *>(self.toolPicker.selectedToolItem);
    
    CGRect frame;
    {
        CGFloat width = customItem.width;
        frame = CGRectMake(location.x - width * 0.5, location.y - width * 0.5, width, width);
    }
    
    imageView.frame = frame;
    
    NSSet<UITouch *> *touches = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(tapGestureRecognizer, sel_registerName("sbf_activeTouches"));
    if (UITouch *touch = touches.allObjects.firstObject) {
        CGFloat rotation = [touch azimuthAngleInView:self.customItemsContainerView] - touch.rollAngle;
        imageView.transform = CGAffineTransformMakeRotation(rotation);
    }
    
    UIColor *tintColor = customItem.color;
    imageView.tintColor = tintColor;
    [self.customItemsContainerView addSubview:imageView];
    
    [self.undoManager registerUndoWithTarget:self selector:@selector(_undoCustomItem:) object:imageView];
    [self _saveCustomItemWithImageView:imageView];
    [imageView release];
}

- (void)canvasCustomItemInteraction:(CanvasCustomItemInteraction *)canvasCustomItemInteraction didTriggerHoverGestureRecognizer:(UIHoverGestureRecognizer *)hoverGestureRecognizer {
    switch (hoverGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            assert(self.hoverImageView == nil);
            UIImageView *hoverImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up"]];
            CGPoint location = [hoverGestureRecognizer locationInView:self.customItemsContainerView];
            auto customItem = static_cast<PKToolPickerCustomItem *>(self.toolPicker.selectedToolItem);
            CGFloat width = customItem.width;
            hoverImageView.frame = CGRectMake(location.x - width * 0.5, location.y - width * 0.5, width, width);
            hoverImageView.tintColor = customItem.color;
            hoverImageView.alpha = 0.5;
            
            CGFloat rotation = [hoverGestureRecognizer azimuthAngleInView:self.customItemsContainerView] - hoverGestureRecognizer.rollAngle;
            hoverImageView.transform = CGAffineTransformMakeRotation(rotation);
            
            [self.customItemsContainerView addSubview:hoverImageView];
            self.hoverImageView = hoverImageView;
            [hoverImageView release];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (UIImageView *hoverImageView = self.hoverImageView) {
                hoverImageView.transform = CGAffineTransformIdentity;
                
                CGPoint location = [hoverGestureRecognizer locationInView:self.customItemsContainerView];
                auto customItem = static_cast<PKToolPickerCustomItem *>(self.toolPicker.selectedToolItem);
                
                CGFloat width = customItem.width;
                hoverImageView.frame = CGRectMake(location.x - width * 0.5, location.y - width * 0.5, width, width);
                
                CGFloat rotation = [hoverGestureRecognizer azimuthAngleInView:self.customItemsContainerView] - hoverGestureRecognizer.rollAngle;
                hoverImageView.transform = CGAffineTransformMakeRotation(rotation);
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            UIImageView *hoverImageView = self.hoverImageView;
            assert(hoverImageView != nil);
            [hoverImageView removeFromSuperview];
            self.hoverImageView = nil;
            break;
        }
        default:
            break;
    }
}

- (void)_undoCustomItem:(UIImageView *)imageView {
    [imageView removeFromSuperview];
    [self.undoManager registerUndoWithTarget:self selector:@selector(_redoCustomItem:) object:imageView];
    [self _removeCustomItemWithImageView:imageView];
}

- (void)_redoCustomItem:(UIImageView *)imageView {
    [self.customItemsContainerView addSubview:imageView];
    [self.undoManager registerUndoWithTarget:self selector:@selector(_undoCustomItem:) object:imageView];
    [self _saveCustomItemWithImageView:imageView];
}

// Update는 복원이 안 되어서 중단
- (void)_restoreWithTransaction:(NSPersistentHistoryTransaction *)transaction __attribute__((objc_direct)) {
    MCCanvas *canvas = self.canvas;
    NSManagedObjectContext *context = canvas.managedObjectContext;
    
    [context performBlock:^{
        NSPersistentHistoryChangeRequest *request = [NSPersistentHistoryChangeRequest fetchHistoryAfterTransaction:transaction];
        request.resultType = NSPersistentHistoryResultTypeTransactionsAndChanges;
        
        NSError * _Nullable error = nil;
        NSPersistentHistoryResult *result = [context executeRequest:request error:&error];
        NSArray<NSPersistentHistoryTransaction *> *transactions = result.result;
        assert(error == nil);
        
        for (NSPersistentHistoryTransaction *transaction in [transactions reverseObjectEnumerator]) {
            NSArray<NSPersistentHistoryChange *> * changes = transaction.changes;
            NSMutableDictionary<NSNumber *, NSManagedObjectID *> *recoveredObjectIDsByChangeID = [NSMutableDictionary new];
            
            for (NSPersistentHistoryChange *change in [changes reverseObjectEnumerator]) {
                switch (change.changeType) {
                    case NSPersistentHistoryChangeTypeDelete: {
                        NSEntityDescription *entity = change.changedObjectID.entity;
                        NSManagedObject *recoveredObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                        [recoveredObject setValuesForKeysWithDictionary:change.tombstone.mc_nestedDictionary];
                        
                        NSError * _Nullable error = nil;
                        [context obtainPermanentIDsForObjects:@[recoveredObject] error:&error];
                        assert(error == nil);
                        
                        recoveredObjectIDsByChangeID[@(change.changeID)] = recoveredObject.objectID;
                        [recoveredObject release];
                        break;
                    }
                    case NSPersistentHistoryChangeTypeInsert: {
                        NSManagedObject *object = [context objectWithID:change.changedObjectID];
                        [context deleteObject:object];
                        break;
                    }
                    case NSPersistentHistoryChangeTypeUpdate: {
                        // TODO
                        abort();
                        break;
                    }
                    default:
                        abort();
                }
            }
            
            [recoveredObjectIDsByChangeID release];
        }
        
        [context save:&error];
        assert(error == nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _reloadCanvas];
        });
    }];
}

@end
