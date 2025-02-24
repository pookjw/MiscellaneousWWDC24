//
//  ObjCUIKitViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 11/2/24.
//

#import "ObjCUIKitViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <ImagePlayground/ImagePlayground.h>

@interface ObjCUIKitViewController ()
@end

@implementation ObjCUIKitViewController

//+ (void)load {
//    // GPImageEditionViewControllerDelegate
//    Protocol *ImageGenerationViewControllerDelegate = NSProtocolFromString(@"ImageGenerationViewControllerDelegate");
//    
//    // nil 확인을 반드시 해야 한다. https://x.com/_silgen_name/status/1838782441827504251
//    if (ImageGenerationViewControllerDelegate) {
//        assert(class_addProtocol(self, ImageGenerationViewControllerDelegate));
//    }
//}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"Present";
    
    __weak ObjCUIKitViewController *weakSelf = self;
    
    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        ObjCUIKitViewController *unretained = weakSelf;
        if (unretained == nil) return;
        
        __kindof UIViewController *viewController = [objc_lookUpClass("GPImageEditionViewController") new];
        
        if (@available(iOS 18.4, *)) {
            __kindof UIViewController *generationViewController = ((id (*)(id, SEL))objc_msgSend)(viewController, sel_registerName("generationViewController"));
            ((void (*)(id, SEL))objc_msgSend)(generationViewController, sel_registerName("_viewControllerPresentationDidInitiate"));
        }
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        viewController.popoverPresentationController.sourceView = action.sender;
        
        ((void (*)(id, SEL, id))objc_msgSend)(viewController, sel_registerName("setDelegate:"), unretained);
        ((void (*)(id, SEL, id))objc_msgSend)(viewController, sel_registerName("setSourceImage:"), [UIImage imageNamed:@"image"]);
        
        id catPrompt = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("GPPromptElement") alloc], sel_registerName("initWithText:"), @"Cat");
        
        id extractedPrompt = ((id (*)(id, SEL, id, id, BOOL, BOOL, BOOL, BOOL, id, CGImageRef))objc_msgSend)([objc_lookUpClass("GPPromptElement") alloc], sel_registerName("initWithText:title:isPersonHandle:isSuggestableText:needsConceptsExtraction:needsSuggestableConceptsExtraction:drawing:image:"), @"In a deep and mystical forest, a magical deer stands by a small lake shrouded in a soft, blue mist. The deer has shimmering silver fur and majestic golden antlers that emit a gentle light, illuminating the surroundings. Around the deer, small glowing butterflies gather, creating an enchanting scene. The night sky is filled with twinkling stars, and the moonlight bathes the forest, adding to the air of mystery and wonder.", @"Magical Deer in the Forest", NO, NO, YES, NO, nil, nil);
        
        id recipe = ((id (*)(id, SEL, id, id, id))objc_msgSend)([objc_lookUpClass("GPRecipe") alloc], sel_registerName("initWithEncodedRecipe:prompts:contextElements:"), nil, nil, @[catPrompt, extractedPrompt]);
        [catPrompt release];
        [extractedPrompt release];
        
        ((void (*)(id, SEL, id))objc_msgSend)(viewController, sel_registerName("setRecipe:"), recipe);
        [recipe release];
        
        [unretained presentViewController:viewController animated:YES completion:nil];
        [viewController release];
    }];
    
    UIButton *button = [UIButton buttonWithConfiguration:configuration primaryAction:action];
    button.enabled = ((BOOL (*)(Class, SEL))objc_msgSend)(objc_lookUpClass("GPImageEditionViewController"), sel_registerName("isAvailable"));
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)imageEditionViewControllerDidFinishEditing:(__kindof UIViewController *)viewController error:(NSError * _Nullable)error {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    NSArray *generatedAssets = ((id (*)(id, SEL))objc_msgSend)(viewController, sel_registerName("generatedAssets"));
    id asset = generatedAssets.firstObject;
    
    if (asset == nil) return;
    
    id imageURLWrapper = ((id (*)(id, SEL))objc_msgSend)(asset, sel_registerName("imageURLWrapper"));
    NSURL *url = ((id (*)(id, SEL))objc_msgSend)(imageURLWrapper, sel_registerName("url"));
    
    UIButtonConfiguration *configuration = [((UIButton *)self.view).configuration copy];
    [url startAccessingSecurityScopedResource];
    configuration.background.image = [UIImage imageWithContentsOfFile:url.relativePath];
    [url stopAccessingSecurityScopedResource];
    ((UIButton *)self.view).configuration = configuration;
    [configuration release];
}

- (void)imageEditionViewControllerDidCancel:(__kindof UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditionViewControllerDidCancel:(__kindof UIViewController *)viewController requiresShowingGrid:(BOOL)requiresShowingGrid {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
