//
//  CanvasCollectionContentView.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "CanvasCollectionContentView.h"

__attribute__((objc_direct_members))
@interface CanvasCollectionContentView ()
@property (copy, nonatomic, getter=_contentConfiguration, setter=_setContentConfiguration:) CanvasCollectionContentConfiguration *contentConfiguration;
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@end

@implementation CanvasCollectionContentView
@synthesize label = _label;

- (instancetype)initWithConfiguration:(CanvasCollectionContentConfiguration *)configuration {
    if (self = [super initWithFrame:CGRectNull]) {
        UILabel *label = self.label;
        label.frame = self.bounds;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:label];
        
        self.contentConfiguration = configuration;
    }
    
    return self;
}

- (void)dealloc {
    [_contentConfiguration release];
    [_label release];
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
        NSDate *lastEditedSate = contentConfiguration.canvas.lastEditedDate;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.contentConfiguration.canvas isEqual:contentConfiguration.canvas]) {
                self.label.text = lastEditedSate.description;
            }
        });
    }];
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    
    _label = label;
    return label;
}

@end
