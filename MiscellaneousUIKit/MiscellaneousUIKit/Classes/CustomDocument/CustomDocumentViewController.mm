//
//  CustomDocumentViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "CustomDocumentViewController.h"
#import "CustomDocument.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface _CustomDocumentForegroundView : UIView
@end

@implementation _CustomDocumentForegroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robot"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageView];
        
        [NSLayoutConstraint activateConstraints:@[
            [imageView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
            [imageView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
            [imageView.widthAnchor constraintEqualToConstant:100.],
            [imageView.heightAnchor constraintEqualToConstant:100.]
        ]];
        
        [imageView release];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    /* _UIDocumentUnavailableModernBrowserPresentingViewController */
//    UIViewController *viewController = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("_viewControllerForAncestor"));
//    
//    /* _UIDocumentUnavailableTitlePageView */
//    __kindof UIView *_titleView;
//    object_getInstanceVariable(viewController, "_titleView", (void **)&_titleView);
//    
//    NSLog(@"%lf", ((CGFloat (*)(id, SEL))objc_msgSend)(_titleView, sel_registerName("bottomInset")));
//    // _UIDocumentUnavailableTitlePageView
//    /* _UIDocumentUnavailableConfiguration */
//    id configuration = ((id (*)(id, SEL))objc_msgSend)(viewController, sel_registerName("configuration"));
//    
//    UIDocumentBrowserViewController *browserViewController = ((id (*)(id, SEL))objc_msgSend)(configuration, sel_registerName("browserViewController"));
//    
//    /* _UIDocumentUnavailableBrowserPresentationController */
//    __kindof UISheetPresentationController *observedUIPPresentationController = ((id (*)(id, SEL))objc_msgSend)(browserViewController, sel_registerName("observedUIPPresentationController"));
//    
//    /* _UIDocumentUnavailableBrowserContainerViewController */
//    __kindof UIViewController *containerViewController = observedUIPPresentationController.presentingViewController;
////    NSLog(@"%@", NSStringFromCGRect(rect));
//    NSLog(@"%@", observedUIPPresentationController);
//    browserViewController.view.hidden = YES;
//}

@end

@interface _CustomDocumentBackgroundView : UIView
@end

@implementation _CustomDocumentBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robot"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageView];
        
        [NSLayoutConstraint activateConstraints:@[
            [imageView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
            [imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [imageView.widthAnchor constraintEqualToConstant:100.],
            [imageView.heightAnchor constraintEqualToConstant:100.]
        ]];
        
        [imageView release];
    }
    return self;
}


@end

@interface CustomDocumentViewController () <UIDocumentBrowserViewControllerDelegate>
@property (retain, readonly, nonatomic) UIImageView *imageView;
@end

@implementation CustomDocumentViewController
@synthesize imageView = _imageView;

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = self.imageView;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    if (@available(iOS 18.0, *)) {
        UIDocumentViewControllerLaunchOptions *launchOptions = [UIDocumentViewControllerLaunchOptions new];
        
//        UIDocumentBrowserViewController *browserViewController = launchOptions.browserViewController;
//        
//        /* DOCConfiguration */
//        id configuration = ((id (*)(id, SEL, id))objc_msgSend)(browserViewController, sel_registerName("configurationForOpeningDocumentsWithContentTypes:"), @[UTTypePNG.identifier, UTTypePNG.identifier]);
//        ((void (*)(id, SEL, id))objc_msgSend)(browserViewController, sel_registerName("setConfiguration:"), configuration);
        
        UIDocumentBrowserViewController *browserViewController = [[UIDocumentBrowserViewController alloc] initForOpeningContentTypes:@[UTTypePNG]];
        launchOptions.browserViewController = browserViewController;
        
        browserViewController.delegate = self;
        [browserViewController release];
        
        //
        
        launchOptions.title = @"Hello!";
        
        UIBackgroundConfiguration *background = [UIBackgroundConfiguration clearConfiguration];
        background.backgroundColor = UIColor.systemGreenColor;
        launchOptions.background = background;
        
        UIView *greenView = [UIView new];
        greenView.backgroundColor = UIColor.systemGreenColor;
        background.customView = greenView;
        [greenView release];
        
        _CustomDocumentForegroundView *foregroundAccessoryView = [_CustomDocumentForegroundView new];
        launchOptions.foregroundAccessoryView = foregroundAccessoryView;
        [foregroundAccessoryView release];
        
        _CustomDocumentBackgroundView *backgroundAccessoryView = [_CustomDocumentBackgroundView new];
        launchOptions.backgroundAccessoryView = backgroundAccessoryView;
        [backgroundAccessoryView release];
        
        UIAction *primaryAction = [UIDocumentViewControllerLaunchOptions createDocumentActionWithIntent:@"Primary"];
        primaryAction.image = [UIImage systemImageNamed:@"pencil.and.outline"];
        primaryAction.title = @"Primary";
        launchOptions.primaryAction = primaryAction;
        
        UIAction *secondaryAction = [UIDocumentViewControllerLaunchOptions createDocumentActionWithIntent:@"Secondary"];
        secondaryAction.title = @"Secondary";
        secondaryAction.image = [UIImage systemImageNamed:@"pencil.and.outline"];
        launchOptions.secondaryAction = secondaryAction;
        
        //
        
        UIMenu *_secondaryMenu = [UIMenu menuWithChildren:@[
            [UIAction actionWithTitle:@"Hello, _secondaryMenu!" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }]
        ]];
        
        ((void (*)(id, SEL, id))objc_msgSend)(launchOptions, sel_registerName("_setSecondaryMenu:"), _secondaryMenu);
        
        //
        
        self.launchOptions = launchOptions;
        [launchOptions release];
    }
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    NSLog(@"%@", childController);
}

- (void)setBrowserPresentingViewController:(__kindof UIViewController *)browserPresentingViewController {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id))objc_msgSendSuper2)(&superInfo, _cmd, browserPresentingViewController);
    
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)documentURLs {
    CustomDocument *document = [[CustomDocument alloc] initWithFileURL:documentURLs.firstObject];
    self.document = document;;
    [document release];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didRequestDocumentCreationWithHandler:(void (^)(NSURL * _Nullable, UIDocumentBrowserImportMode))importHandler {
    if (@available(iOS 18.0, *)) {
        UIDocumentCreationIntent creationIntent = controller.activeDocumentCreationIntent;
        
        UIImage *robotImage = [UIImage imageNamed:@"robot"];
        NSData *data = UIImagePNGRepresentation(robotImage);
        
        NSURL *tmpURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"tmp" conformingToType:UTTypePNG];
        assert([data writeToURL:tmpURL atomically:NO]);
        
        importHandler(tmpURL, UIDocumentBrowserImportModeMove);
    } else {
        abort();
    }
}

- (void)documentDidOpen {
    [super documentDidOpen];
    
    self.imageView.image = [UIImage imageWithData:((CustomDocument *)self.document).data];
}

- (UIImageView *)imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _imageView = [imageView retain];
    return [imageView autorelease];
}

// DOCRemoteViewController이 dealloc 안 되는 문제 있음

@end
