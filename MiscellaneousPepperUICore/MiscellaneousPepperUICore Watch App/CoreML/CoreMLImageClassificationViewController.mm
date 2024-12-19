//
//  CoreMLImageClassificationViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 12/19/24.
//

#import "CoreMLImageClassificationViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>
#import <CoreML/CoreML.h>

CGImagePropertyOrientation CGImagePropertyOrientationForUIImageOrientation(UIImageOrientation uiOrientation) {
    switch (uiOrientation) {
        case UIImageOrientationUp: return kCGImagePropertyOrientationUp;
        case UIImageOrientationDown: return kCGImagePropertyOrientationDown;
        case UIImageOrientationLeft: return kCGImagePropertyOrientationLeft;
        case UIImageOrientationRight: return kCGImagePropertyOrientationRight;
        case UIImageOrientationUpMirrored: return kCGImagePropertyOrientationUpMirrored;
        case UIImageOrientationDownMirrored: return kCGImagePropertyOrientationDownMirrored;
        case UIImageOrientationLeftMirrored: return kCGImagePropertyOrientationLeftMirrored;
        case UIImageOrientationRightMirrored: return kCGImagePropertyOrientationRightMirrored;
    }
}
UIImageOrientation UIImageOrientationForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation) {
    switch (cgOrientation) {
        case kCGImagePropertyOrientationUp: return UIImageOrientationUp;
        case kCGImagePropertyOrientationDown: return UIImageOrientationDown;
        case kCGImagePropertyOrientationLeft: return UIImageOrientationLeft;
        case kCGImagePropertyOrientationRight: return UIImageOrientationRight;
        case kCGImagePropertyOrientationUpMirrored: return UIImageOrientationUpMirrored;
        case kCGImagePropertyOrientationDownMirrored: return UIImageOrientationDownMirrored;
        case kCGImagePropertyOrientationLeftMirrored: return UIImageOrientationLeftMirrored;
        case kCGImagePropertyOrientationRightMirrored: return UIImageOrientationRightMirrored;
    }
}

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation CoreMLImageClassificationViewController

+ (void)load {
    assert(dlopen("/System/Library/Frameworks/CoreImage.framework/CoreImage", RTLD_NOW) != NULL);
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPPUICPageViewController"), "_CoreMLImageClassificationViewController", 0);
        
        IMP initWithNibName_bundle = class_getMethodImplementation(self, @selector(initWithNibName:bundle:));
        assert(class_addMethod(_isa, @selector(initWithNibName:bundle:), initWithNibName_bundle, NULL));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP pageViewController_didChangeToIndex = class_getMethodImplementation(self, @selector(pageViewController:didChangeToIndex:));
        assert(class_addMethod(_isa, @selector(pageViewController:didChangeToIndex:), pageViewController_didChangeToIndex, NULL));
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    objc_super superInfo = { self, [self class] };
    
    // navigationOrientation
    //  - 0 : Horizontal
    //  - 1 : Vertical
    
    // pageTransform
    //  - 0 : Blur When Vertical
    //  - 1 : None
    self = reinterpret_cast<id (*)(objc_super *, SEL, NSUInteger, NSInteger, BOOL, NSInteger)>(objc_msgSendSuper2)(&superInfo, sel_registerName("initWithNavigationOrientation:titleBehavior:shouldPreloadChildViewControllers:pageTransform:"), 1, 0, NO, 0);
    
    if (self) {
        auto viewControllersVec = std::vector<NSString *> {@"cat1.heic", @"dog1.heic", @"cat2.jpg", @"dog2.jpeg", @"cat3.heic", @"dog3.heic"}
        | std::views::transform([](NSString *fileName) -> id {
            NSURL *url = [NSBundle.mainBundle URLForResource:fileName withExtension:nil];
            assert(url != nil);
            UIImage *image = [UIImage imageWithContentsOfFile:url.path];
            assert(image != nil);
            
            id imageView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), image);
            reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(imageView, sel_registerName("setContentMode:"), 2);
            
            id viewController = [objc_lookUpClass("UIViewController") new];
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setView:"), imageView);
            [imageView release];
            
            return [viewController autorelease];
        })
        | std::ranges::to<std::vector<id>>();
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:viewControllersVec.data() count:viewControllersVec.size()];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setViewControllers:"), viewControllers);
        [viewControllers release];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setDelegate:"), self);
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop


- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
}

- (void)pageViewController:(id)pageViewController didChangeToIndex:(NSInteger)index {
    NSArray *viewControllers = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(pageViewController, sel_registerName("viewControllers"));
    id viewController = viewControllers[index];
    id imageView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(viewController, sel_registerName("view"));
    UIImage *image = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageView, sel_registerName("image"));
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        CGImageRef cgImage = image.CGImage;
        if (cgImage == NULL) {
            id ciImage = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(image, sel_registerName("CIImage"));
            assert(ciImage != nil);
            
            CGRect extent = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(ciImage, sel_registerName("extent"));
            id context = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("CIContext") alloc], sel_registerName("initWithOptions:"), nil);
            cgImage = reinterpret_cast<CGImageRef (*)(id, SEL, id, CGRect)>(objc_msgSend)(context, sel_registerName("createCGImage:fromRect:"), ciImage, extent);
            assert(cgImage != NULL);
            CFAutorelease(cgImage);
        }
        
        NSURL *modelURL = [NSBundle.mainBundle URLForResource:@"Cat or Dog V2" withExtension:@"mlmodelc"];
        assert(modelURL != nil);
        
        NSError * _Nullable error = nil;
        MLModel *model = [MLModel modelWithContentsOfURL:modelURL error:&error];
        assert(error == nil);
        
        MLImageConstraint *constraint = model.modelDescription.inputDescriptionsByName[@"image"].imageConstraint;
        
        MLFeatureValue *featureValue = [MLFeatureValue featureValueWithCGImage:cgImage
                                                                   orientation:CGImagePropertyOrientationForUIImageOrientation(image.imageOrientation)
                                                                    constraint:constraint
                                                                       options:@{
            MLFeatureValueImageOptionCropAndScale: @(2) // VNImageCropAndScaleOptionScaleFill
        }
                                                                         error:&error];
        assert(error == nil);
        
        MLDictionaryFeatureProvider *inputProvider = [[MLDictionaryFeatureProvider alloc] initWithDictionary:@{@"image": featureValue} error:&error];
        assert(error == nil);
        
        id<MLFeatureProvider> outputProvider = [model predictionFromFeatures:inputProvider error:&error];
        assert(error == nil);
        
        NSString *target = [outputProvider featureValueForName:@"target"].stringValue;
        assert(target != nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger currentIndex = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(pageViewController, sel_registerName("currentIndex"));
            if (currentIndex != index) return;
            
            id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), target);
        });
    });
}

@end
