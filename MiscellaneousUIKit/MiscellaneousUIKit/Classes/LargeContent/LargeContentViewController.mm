//
//  LargeContentViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "LargeContentViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

/*
 -[UIAccessibilityHUDGestureManager _didToggleLargeContentViewer:]
 UILargeContentViewerInteractionEnabledStatusDidChangeNotification
 */
namespace _UILargeContentViewerInteraction {
    namespace isEnabled {
        BOOL (*original)(Class, SEL);
        BOOL custom(Class self, SEL _cmd) {
            return YES;
        }
        void swizzle() {
            Method method = class_getClassMethod(UILargeContentViewerInteraction.class, @selector(isEnabled));
            original = (decltype(original))method_getImplementation(method);
            method_setImplementation(method, (IMP)custom);
        }
    }
}

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface GuidedSymbolImageView : UIImageView
@end

@implementation GuidedSymbolImageView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        self.showsLargeContentViewer = YES;
        
        // imageAsset
        id imageAsset = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(image, sel_registerName("imageAsset"));
        NSString *assetName = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageAsset, sel_registerName("assetName"));
        
        self.largeContentTitle = assetName;
        self.largeContentImage = image;
        self.scalesLargeContentImage = YES;
    }
    
    return self;
}

@end

@interface LargeContentViewController () <UILargeContentViewerInteractionDelegate>
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) GuidedSymbolImageView *lassoImageView;
@property (retain, readonly, nonatomic) GuidedSymbolImageView *folderImageView;
@property (retain, readonly, nonatomic) GuidedSymbolImageView *linkImageView;
@end

@implementation LargeContentViewController
@synthesize stackView = _stackView;
@synthesize lassoImageView = _lassoImageView;
@synthesize folderImageView = _folderImageView;
@synthesize linkImageView = _linkImageView;

+ (void)load {
    _UILargeContentViewerInteraction::isEnabled::swizzle();
}

- (void)dealloc {
    [_stackView release];
    [_lassoImageView release];
    [_folderImageView release];
    [_linkImageView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    //
    
    UILargeContentViewerInteraction *interaction = [[UILargeContentViewerInteraction alloc] initWithDelegate:self];
    [self.view addInteraction:interaction];
    [interaction release];
    
    //
    
    UIBarButtonItem *showHUDBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Show HUD" style:UIBarButtonItemStylePlain target:self action:@selector(showHUDBarButtonItemDidTrigger:)];
    
    self.navigationItem.rightBarButtonItems = @[
        showHUDBarButtonItem
    ];
    
    [showHUDBarButtonItem release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didToggleLargeContentViewer:) name:UILargeContentViewerInteractionEnabledStatusDidChangeNotification object:nil];
}

- (void)didToggleLargeContentViewer:(NSNotification *)notification {
    NSLog(@"%d", UILargeContentViewerInteraction.isEnabled);
}

- (void)showHUDBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    for (id<UIInteraction> interaction in self.view.interactions) {
        if (![interaction isKindOfClass:UILargeContentViewerInteraction.class]) continue;
        
        // UIAccessibilityHUDGestureManager
        id _largeContentViewerGestureManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.view, sel_registerName("_largeContentViewerGestureManager"));
        
        // UIAccessibilityHUDItem
//        UILargeContentViewerInteraction *largeInteraction = interaction;
//        id HUDItem = reinterpret_cast<id (*)(id, SEL, id, CGPoint)>(objc_msgSend)(largeInteraction, sel_registerName("_accessibilityHUDGestureManager:HUDItemForPoint:"), _largeContentViewerGestureManager, self.lassoImageView.frame.origin);
        
        id HUDItem = reinterpret_cast<id (*)(id, SEL, id, id, UIEdgeInsets, BOOL)>(objc_msgSend)([objc_lookUpClass("UIAccessibilityHUDItem") alloc], sel_registerName("initWithTitle:image:imageInsets:scaleImage:"), @"Hello!", [UIImage systemImageNamed:@"ladybug.fill"], UIEdgeInsetsZero, YES);
        [HUDItem autorelease];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_largeContentViewerGestureManager, sel_registerName("_showAccessibilityHUDItem:"), HUDItem);
        
        //
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __kindof UIView *_accessibilityHUD;
            object_getInstanceVariable(self, "_accessibilityHUD", (void **)&_accessibilityHUD);
            
            id oldItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_accessibilityHUD, sel_registerName("item"));
            if (oldItem == nil) {
                return;
            }
            
            //
            
            id HUDItem = reinterpret_cast<id (*)(id, SEL, id, id, UIEdgeInsets, BOOL)>(objc_msgSend)([objc_lookUpClass("UIAccessibilityHUDItem") alloc], sel_registerName("initWithTitle:image:imageInsets:scaleImage:"), @"Ant!", [UIImage systemImageNamed:@"ant.fill"], UIEdgeInsetsZero, YES);
            
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_accessibilityHUD, sel_registerName("setItem:"), HUDItem);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_largeContentViewerGestureManager, sel_registerName("_showAccessibilityHUDItem:"), HUDItem);
            
            [HUDItem release];
        });
        
        //
        
        // UIAccessibilityHUDWindow
        __kindof UIWindow *HUDWindow = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIAccessibilityHUDWindow"), sel_registerName("sharedWindow"));
        
        UIView *dismissView = [[UIView alloc] initWithFrame:HUDWindow.rootViewController.view.bounds];
        dismissView.backgroundColor = UIColor.clearColor;
        dismissView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *tapGestureRecogninzer = [[UITapGestureRecognizer alloc] initWithTarget:_largeContentViewerGestureManager action:sel_registerName("_dismissAccessibilityHUD")];
        [dismissView addGestureRecognizer:tapGestureRecogninzer];
        [tapGestureRecogninzer release];
        
        [HUDWindow.rootViewController.view addSubview:dismissView];
        [dismissView release];
        
        break;
    }
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.lassoImageView,
        self.folderImageView,
        self.linkImageView
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (GuidedSymbolImageView *)lassoImageView {
    if (auto lassoImageView = _lassoImageView) return lassoImageView;
    
    GuidedSymbolImageView *lassoImageView = [[GuidedSymbolImageView alloc] initWithImage:[UIImage systemImageNamed:@"lasso"]];
    lassoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _lassoImageView = [lassoImageView retain];
    return [lassoImageView autorelease];
}

- (GuidedSymbolImageView *)folderImageView {
    if (auto folderImageView = _folderImageView) return folderImageView;
    
    GuidedSymbolImageView *folderImageView = [[GuidedSymbolImageView alloc] initWithImage:[UIImage systemImageNamed:@"folder"]];
    folderImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _folderImageView = [folderImageView retain];
    return [folderImageView autorelease];
}

- (GuidedSymbolImageView *)linkImageView {
    if (auto linkImageView = _linkImageView) return linkImageView;
    
    GuidedSymbolImageView *linkImageView = [[GuidedSymbolImageView alloc] initWithImage:[UIImage systemImageNamed:@"link"]];
    linkImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _linkImageView = [linkImageView retain];
    return [linkImageView autorelease];
}


#pragma mark - UILargeContentViewerInteractionDelegate

- (void)largeContentViewerInteraction:(UILargeContentViewerInteraction *)interaction didEndOnItem:(id<UILargeContentViewerItem>)item atPoint:(CGPoint)point {
    __kindof UIImageView *image = (id)item;
    
    [image addSymbolEffect:[[NSSymbolBounceEffect bounceUpEffect] effectWithByLayer]];
}

- (id<UILargeContentViewerItem>)largeContentViewerInteraction:(UILargeContentViewerInteraction *)interaction itemAtPoint:(CGPoint)point {
    return [self.view hitTest:point withEvent:nil];
}

- (UIViewController *)viewControllerForLargeContentViewerInteraction:(UILargeContentViewerInteraction *)interaction {
    return self;
}

@end
