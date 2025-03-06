//
//  CanvasCollectionContentConfiguration.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "CanvasCollectionContentConfiguration.h"
#import "CanvasCollectionContentView.h"

@implementation CanvasCollectionContentConfiguration

- (instancetype)initWithCanvas:(MCCanvas *)canvas {
    if (self = [super init]) {
        _canvas = [canvas retain];
    }
    
    return self;
}

- (void)dealloc {
    [_canvas release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [self retain];
}

- (__kindof UIView<UIContentView> *)makeContentView {
    return [[[CanvasCollectionContentView alloc] initWithConfiguration:self] autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end
