//
//  CanvasCollectionContentView.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "CanvasCollectionContentView.h"
#import <objc/message.h>
#import <objc/runtime.h>

__attribute__((objc_direct_members))
@interface CanvasCollectionContentView ()
@property (copy, nonatomic, getter=_contentConfiguration, setter=_setContentConfiguration:) CanvasCollectionContentConfiguration *contentConfiguration;
@property (retain, nonatomic, readonly, getter=_canvasImageView) UIImageView *canvasImageView;
@property (retain, nonatomic, readonly, getter=_customItemsImageView) UIImageView *customItemsImageView;
@end

@implementation CanvasCollectionContentView
@synthesize canvasImageView = _canvasImageView;
@synthesize customItemsImageView = _customItemsImageView;

- (instancetype)initWithConfiguration:(CanvasCollectionContentConfiguration *)configuration {
    if (self = [super initWithFrame:CGRectNull]) {
        UIImageView *canvasImageView = self.canvasImageView;
        [self addSubview:canvasImageView];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), canvasImageView);
        
        UIImageView *customItemsImageView = self.customItemsImageView;
        [self addSubview:customItemsImageView];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), customItemsImageView);
        
        self.contentConfiguration = configuration;
    }
    
    return self;
}

- (void)dealloc {
    [_contentConfiguration release];
    [_canvasImageView release];
    [_customItemsImageView release];
    [super dealloc];
}

- (id<UIContentConfiguration>)configuration {
    return self.contentConfiguration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    self.contentConfiguration = static_cast<CanvasCollectionContentConfiguration *>(configuration);
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:[CanvasCollectionContentConfiguration class]];
}

- (void)_setContentConfiguration:(CanvasCollectionContentConfiguration *)contentConfiguration {
    [_contentConfiguration release];
    _contentConfiguration = [contentConfiguration copy];
    
    [MCCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        NSData *canvasImageData = contentConfiguration.canvas.canvasImageData;
        NSData *customItemsImageData = contentConfiguration.canvas.customItemsImageData;
        
        UIImage *canvasImage = [[UIImage alloc] initWithData:canvasImageData];
        UIImage *customItemsImage = [[UIImage alloc] initWithData:customItemsImageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.contentConfiguration.canvas isEqual:contentConfiguration.canvas]) {
                self.canvasImageView.image = canvasImage;
                self.customItemsImageView.image = customItemsImage;
            }
        });
        
        [canvasImage release];
        [customItemsImage release];
    }];
}

- (UIImageView *)_canvasImageView {
    if (auto canvasImageView = _canvasImageView) return canvasImageView;
    
    UIImageView *canvasImageView = [UIImageView new];
    canvasImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _canvasImageView = canvasImageView;
    return canvasImageView;
}

- (UIImageView *)_customItemsImageView {
    if (auto customItemsImageView = _customItemsImageView) return customItemsImageView;
    
    UIImageView *customItemsImageView = [UIImageView new];
    customItemsImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _customItemsImageView = customItemsImageView;
    return customItemsImageView;
}

@end
