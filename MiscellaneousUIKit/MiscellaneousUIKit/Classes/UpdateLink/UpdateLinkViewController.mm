//
//  UpdateLinkViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "UpdateLinkViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowTrackableInteraction : NSObject <UIInteraction>

@property (nonatomic, nullable, weak, readonly) __kindof UIView *view;
@end
@implementation WindowTrackableInteraction

- (void)didMoveToView:(nullable UIView *)view { 
    
}

- (void)willMoveToView:(nullable UIView *)view { 
    
}

- (void)_willMoveFromWindow:(UIWindow * _Nullable)fromWindow toWindow:(UIWindow * _Nullable)toWindow {
    
}

@end

@interface UpdateLinkViewController ()
@property (retain, readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIUpdateLink *updateLink;
@property (retain, nonatomic) UIWindow *window;;
@end

@implementation UpdateLinkViewController

- (void)dealloc {
    [_textView release];
    [_updateLink release];
    [_window release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    UIBarButtonItem *windowBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Window" style:UIBarButtonItemStylePlain target:self action:@selector(windowBarButtonItemDidTrigger:)];
    navigationItem.rightBarButtonItem = windowBarButtonItem;
    [windowBarButtonItem release];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing:animated];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    WindowTrackableInteraction *myInteraction = [WindowTrackableInteraction new];
    [textView addInteraction:myInteraction];
    [myInteraction release];
    
    textView.backgroundColor = UIColor.systemPinkColor;
    [self.view addSubview:textView];
    
//    UIUpdateLink *updateLink = [UIUpdateLink updateLinkForView:orangeView actionHandler:^(UIUpdateLink * _Nonnull updateLink, UIUpdateInfo * _Nonnull updateInfo) {
//        NSLog(@"%@", updateInfo);
//    }];
    UIUpdateLink *updateLink = [UIUpdateLink updateLinkForView:textView actionTarget:self selector:@selector(updateLinkDidTrigger:)];
//    UIUpdateLink *updateLink = [UIUpdateLink updateLinkForWindowScene:self.view.window.windowScene actionTarget:self selector:@selector(updateLinkDidTrigger:)];
    
    _updateLink = [updateLink retain];
    
//    updateLink.requiresContinuousUpdates = YES;
    updateLink.enabled = YES;
    
    _textView = [textView retain];
    [textView release];
}

- (void)updateLinkDidTrigger:(UIUpdateLink *)sender {
    if ([sender isKindOfClass:objc_lookUpClass("_UIUpdateLinkTrackingView")]) {
        id<UIInteraction> _interaction;
        object_getInstanceVariable(sender, "_interaction", (void **)&_interaction);
        
        NSLog(@"%@", _interaction.view);
    }
    
    UIUpdateInfo *updateInfo = sender.currentUpdateInfo;
    NSLog(@"%@", updateInfo);
}

- (void)windowBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    // TEST: -[_UIUpdateLinkViewInteraction _willMoveFromWindow:toWindow:]
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:self.view.window.windowScene];
    
    [_textView removeFromSuperview];
    [window addSubview:_textView];
    [window makeKeyAndVisible];
    
    self.window = window;
    [window release];
    
    // TEST: -[_UIUpdateLinkTrackingWindow _windowSceneWillChange:], _UIWindowWillMoveToSceneNotification, _UIWindowDidMoveToSceneNotification
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSArray<__kindof UIWindowScene *> *connectedScenes = ((id (*)(Class, SEL, BOOL))objc_msgSend)(UIScene.class, sel_registerName("_scenesIncludingInternal:"), YES);
//        
//        [connectedScenes enumerateObjectsUsingBlock:^(__kindof UIWindowScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![obj isEqual:window.windowScene]) {
//                window.windowScene = (UIWindowScene *)obj;
//                *stop = YES;
//            }
//        }];
//    });
    
    // TEST: -[_UIUpdateLinkTrackingWindow _windowVisibilityChanged:], UIWindowDidBecomeVisibleNotification
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [window resignKeyWindow];
    });
}

@end
