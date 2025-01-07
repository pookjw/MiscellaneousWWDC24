//
//  GenerateImageSegmentationViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/6/25.
//

#import "GenerateImageSegmentationViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Vision/Vision.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <CoreImage/CIFilterBuiltins.h>
#import "GenerateImageSegmentationImageView.h"
#import "GenerateImageSegmentationDrawingView.h"
#include <algorithm>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface GenerateImageSegmentationViewController () <NSToolbarDelegate, PHPickerViewControllerDelegate, GenerateImageSegmentationDrawingViewDelegate>
@property (retain, readonly, nonatomic) NSToolbar *_toolbar;
@property (retain, readonly, nonatomic) NSToolbarItem *_photoPickerToolbarItem;
@property (retain, readonly, nonatomic) GenerateImageSegmentationImageView *_imageView;
@property (retain, readonly, nonatomic) GenerateImageSegmentationDrawingView *_drawingView;
@property (retain, readonly, nonatomic) __kindof VNImageBasedRequest *_request;
@end

@implementation GenerateImageSegmentationViewController
@synthesize _toolbar = __toolbar;
@synthesize _photoPickerToolbarItem = __photoPickerToolbarItem;
@synthesize _imageView = __imageView;
@synthesize _drawingView = __drawingView;
@synthesize _request = __request;

- (void)dealloc {
    [__toolbar release];
    [__photoPickerToolbarItem release];
    [__imageView release];
    __drawingView.delegate = nil;
    [__drawingView release];
    [__request cancel];
    [__request release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    assert(reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("VNImageSegmenter"), sel_registerName("supportsExecution")));
    
//    id interface = [objc_lookUpClass("VNModelCatalogBridgingInterface") new];
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(interface, sel_registerName("downloadForegroundBackgroundSegmentationModelBundleWithCompletionHandler:"), ^(NSError * _Nullable error, id foo) {
//        NSLog(@"");
//    });
    
    [self.view addSubview:self._imageView];
    self._imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [self.view addSubview:self._drawingView];
    self._drawingView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self._drawingView.topAnchor constraintEqualToAnchor:self._imageView.imageLayoutGuide.topAnchor],
        [self._drawingView.leadingAnchor constraintEqualToAnchor:self._imageView.imageLayoutGuide.leadingAnchor],
        [self._drawingView.trailingAnchor constraintEqualToAnchor:self._imageView.imageLayoutGuide.trailingAnchor],
        [self._drawingView.bottomAnchor constraintEqualToAnchor:self._imageView.imageLayoutGuide.bottomAnchor]
    ]];
    
    [self _request];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)toWindow fromWindow:(NSWindow * _Nullable)fromWindow {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id, id))objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    if ([fromWindow.toolbar isEqual:self._toolbar]) {
        fromWindow.toolbar = nil;
    }
    
    toWindow.toolbar = self._toolbar;
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = __toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"GenerateImageSegmentationToolbar"];
    toolbar.delegate = self;
    toolbar.displayMode = NSToolbarDisplayModeIconOnly;
    
    __toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSToolbarItem *)_photoPickerToolbarItem {
    if (auto photoPickerToolbarItem = __photoPickerToolbarItem) return photoPickerToolbarItem;
    
    NSToolbarItem *photoPickerToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"photoPickerToolbarItem"];
    photoPickerToolbarItem.label = @"Choose Photo";
    photoPickerToolbarItem.image = [NSImage imageWithSystemSymbolName:@"photo" accessibilityDescription:nil];
    photoPickerToolbarItem.target = self;
    photoPickerToolbarItem.action = @selector(_didTriggerPhotoPickerToolbarItem:);
    
    __photoPickerToolbarItem = [photoPickerToolbarItem retain];
    return [photoPickerToolbarItem autorelease];
}

- (GenerateImageSegmentationImageView *)_imageView {
    if (auto imageView = __imageView) return imageView;
    
    GenerateImageSegmentationImageView *imageView = [[GenerateImageSegmentationImageView alloc] initWithFrame:self.view.bounds];
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpg"];
    assert(url != nil);
    NSImage *image = [[NSImage alloc] initByReferencingURL:url];
    assert(image != nil);
    
    imageView.image = image;
    [image release];
    
    __imageView = [imageView retain];
    return [imageView autorelease];
}

- (GenerateImageSegmentationDrawingView *)_drawingView {
    if (auto drawingView = __drawingView) return drawingView;
    
    GenerateImageSegmentationDrawingView *drawingView = [GenerateImageSegmentationDrawingView new];
    drawingView.delegate = self;
    
    __drawingView = [drawingView retain];
    return [drawingView autorelease];
}

- (__kindof VNImageBasedRequest *)_request {
    if (auto request = __request) return request;
    
    __kindof VNImageBasedRequest *request = [[objc_lookUpClass("VNGenerateImageSegmentationRequest") alloc] initWithCompletionHandler:^ (VNRequest *request, NSError * _Nullable error) {
        assert(error == nil);
    }];
    
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(request, sel_registerName("setFillGapsInMask:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(request, sel_registerName("setDisableConnectedComponentRefinement:"), NO);
    
    __request = [request retain];
    return [request autorelease];
}

- (void)_didTriggerPhotoPickerToolbarItem:(NSToolbarItem *)sender {
    PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] initWithPhotoLibrary:PHPhotoLibrary.sharedPhotoLibrary];
    configuration.filter = [PHPickerFilter imagesFilter];
    configuration.selectionLimit = 1;
    
    PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:configuration];
    [configuration release];
    
    pickerViewController.delegate = self;
    
    [self presentViewControllerAsSheet:pickerViewController];
//    [self presentViewControllerAsModalWindow:pickerViewController];
    [pickerViewController release];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self._photoPickerToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self._photoPickerToolbarItem.itemIdentifier]) {
        return self._photoPickerToolbarItem;
    } else {
        return nil;
    }
}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    [self dismissViewController:picker];
    
    if (PHPickerResult *result = results.firstObject) {
        [result.itemProvider loadObjectOfClass:[NSImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self._imageView.image = object;
            });
        }];
    }
}

- (void)generateImageSegmentationDrawingView:(GenerateImageSegmentationDrawingView *)generateImageSegmentationDrawingView didFinishDrawingWithPoints:(NSArray<NSValue *> *)points {
    if (points.count == 0) return;
    
    CGRect bounds = generateImageSegmentationDrawingView.bounds;
    CGRect regionOfInterest = self._request.regionOfInterest;
    
    NSMutableArray<VNPoint *> *normalizedPoints = [[NSMutableArray alloc] initWithCapacity:points.count];
    for (NSValue *pointValue in points) {
        NSPoint point = pointValue.pointValue;
        
        VNPoint *vnPoint = [[VNPoint alloc] initWithX:std::min(std::max(point.x / CGRectGetWidth(bounds), CGRectGetMinX(regionOfInterest) + 0.001), CGRectGetMaxX(regionOfInterest) - 0.001)
                                                    y:std::min(std::max(point.y / CGRectGetHeight(bounds), CGRectGetMinY(regionOfInterest) + 0.001), CGRectGetMaxY(regionOfInterest) - 0.001)];
        [normalizedPoints addObject:vnPoint];
        [vnPoint release];
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self._request, sel_registerName("setTargetPoints:"), normalizedPoints);
    [normalizedPoints release];
    
    CGImageRef cgImage = reinterpret_cast<CGImageRef (*)(id, SEL)>(objc_msgSend)(self._imageView.image, sel_registerName("vk_cgImageGeneratingIfNecessary"));
    CGImagePropertyOrientation cgImagePropertyOrientation = reinterpret_cast<CGImagePropertyOrientation (*)(id, SEL)>(objc_msgSend)(self._imageView.image, sel_registerName("vk_cgImagePropertyOrientation"));
    
    VNImageRequestHandler *requestHandler = [[VNImageRequestHandler alloc] initWithCGImage:cgImage orientation:cgImagePropertyOrientation options:@{
        MLFeatureValueImageOptionCropAndScale: @(VNImageCropAndScaleOptionScaleFill)
    }];
    
    
    NSError * _Nullable error = nil;
    [requestHandler performRequests:@[self._request] error:&error];
    assert(error == nil);
    
    for (VNInstanceMaskObservation *observation in self._request.results) {
        if (![observation isKindOfClass:[VNInstanceMaskObservation class]]) abort();
        
        NSError * _Nullable error = nil;
        CVPixelBufferRef mask = [observation generateScaledMaskForImageForInstances:observation.allInstances fromRequestHandler:requestHandler error:&error];;
        
        if (error != nil) {
            NSLog(@"%@", error);
            continue;
        }
        
        CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:mask];
        CVPixelBufferRelease(mask);
        
        CIFilter<CIColorInvert> *colorInvertFilter = [CIFilter colorInvertFilter];
        colorInvertFilter.inputImage = ciImage;
        [ciImage release];
        CIImage *invertedImage = colorInvertFilter.outputImage;
        
        CIFilter<CIBlendWithMask> *blendWithMaskFilter = [CIFilter blendWithMaskFilter];
        blendWithMaskFilter.inputImage = [CIImage imageWithCGImage:cgImage];
        blendWithMaskFilter.maskImage = invertedImage;
        
        CIImage *outputImage = blendWithMaskFilter.outputImage;
        
        CIContext *ciContext = [CIContext new];
        CGImageRef cgImage = [ciContext createCGImage:outputImage fromRect:outputImage.extent];
        [ciContext release];
        NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:outputImage.extent.size];
        CGImageRelease(cgImage);
        self._imageView.image = image;
        [image release];
    }
    
    [requestHandler release];
}

@end
