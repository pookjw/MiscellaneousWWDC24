//
//  CanvasCustomItemInteraction.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

#import "CanvasCustomItemInteraction.h"

#warning TODO prefersHoverToolPreview

__attribute__((objc_direct_members))
@interface CanvasCustomItemInteraction () {
    UIView *_view;
}
@property (retain, nonatomic, readonly, getter=_tapGestureRecognizer) UITapGestureRecognizer *tapGestureRecognizer;
@property (retain, nonatomic, readonly, getter=_hoverGestureRecognizer) UIHoverGestureRecognizer *hoverGestureRecognizer;
@end

@implementation CanvasCustomItemInteraction

- (instancetype)init {
    if (self = [super init]) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTriggerTapGestureRecognizer:)];
        UIHoverGestureRecognizer *hoverGestureRecognizer = [[UIHoverGestureRecognizer alloc] initWithTarget:self action:@selector(_didTriggerHoverGestureRecognizer:)];
        
        _tapGestureRecognizer = tapGestureRecognizer;
        _hoverGestureRecognizer = hoverGestureRecognizer;
        
        [UIPencilInteraction addObserver:self forKeyPath:@"prefersPencilOnlyDrawing" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void)dealloc {
    [UIPencilInteraction removeObserver:self forKeyPath:@"prefersPencilOnlyDrawing"];
    [_tapGestureRecognizer release];
    [_hoverGestureRecognizer release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"prefersPencilOnlyDrawing"] and (object == [UIPencilInteraction class])) {
        NSArray<NSNumber *> *allowedTouchTypes;
        if (UIPencilInteraction.prefersPencilOnlyDrawing) {
            allowedTouchTypes = @[@(UITouchTypePencil)];
        } else {
            allowedTouchTypes = @[@(UITouchTypeDirect), @(UITouchTypeIndirect), @(UITouchTypePencil)];
        }
        
        self.tapGestureRecognizer.allowedTouchTypes = allowedTouchTypes;
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (BOOL)isEnabled {
    return self.tapGestureRecognizer.enabled & self.hoverGestureRecognizer.enabled;
}

- (void)setEnabled:(BOOL)enabled {
    self.tapGestureRecognizer.enabled = enabled;
    self.hoverGestureRecognizer.enabled = enabled;
}

- (__kindof UIView *)view {
    return _view;
}

- (void)willMoveToView:(nullable UIView *)view {
    if (UIView *oldView = _view) {
        [oldView removeGestureRecognizer:self.tapGestureRecognizer];
        [oldView removeGestureRecognizer:self.hoverGestureRecognizer];
    }
}

- (void)didMoveToView:(nullable UIView *)view {
    _view = view;
    
    if (view) {
        [view addGestureRecognizer:self.tapGestureRecognizer];
        [view addGestureRecognizer:self.hoverGestureRecognizer];
    }
}

- (void)_didTriggerTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.delegate canvasCustomItemInteraction:self didTriggerTapGestureRecognizer:sender];
}

- (void)_didTriggerHoverGestureRecognizer:(UIHoverGestureRecognizer *)sender {
    [self.delegate canvasCustomItemInteraction:self didTriggerHoverGestureRecognizer:sender];
}

@end
