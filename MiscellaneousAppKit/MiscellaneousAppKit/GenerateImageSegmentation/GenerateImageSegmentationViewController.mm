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
#import "GenerateImageSegmentationView.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface GenerateImageSegmentationViewController () <NSToolbarDelegate, PHPickerViewControllerDelegate>
@property (retain, readonly, nonatomic) NSToolbar *_toolbar;
@property (retain, readonly, nonatomic) NSToolbarItem *_photoPickerToolbarItem;
@property (retain, readonly, nonatomic) GenerateImageSegmentationView *_segmentationView;
@end

@implementation GenerateImageSegmentationViewController
@synthesize _toolbar = __toolbar;
@synthesize _photoPickerToolbarItem = __photoPickerToolbarItem;
@synthesize _segmentationView = __segmentationView;

- (void)dealloc {
    [__toolbar release];
    [__photoPickerToolbarItem release];
    [__segmentationView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self._segmentationView;
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

- (GenerateImageSegmentationView *)_segmentationView {
    if (auto segmentationView = __segmentationView) return segmentationView;
    
    GenerateImageSegmentationView *segmentationView = [GenerateImageSegmentationView new];
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"cakes" withExtension:UTTypeJPEG.preferredFilenameExtension];
    assert(url != nil);
    NSImage *image = [[NSImage alloc] initByReferencingURL:url];
    assert(image != nil);
    
    segmentationView.image = image;
    [image release];
    
    __segmentationView = [segmentationView retain];
    return [segmentationView autorelease];
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
                self._segmentationView.image = object;
            });
        }];
    }
}

@end
