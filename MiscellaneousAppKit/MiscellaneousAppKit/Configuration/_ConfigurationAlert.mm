//
//  _ConfigurationAlert.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import "_ConfigurationAlert.h"

// TODO: viewGeometryNotificationCenter

@interface _ConfigurationAlert ()
@property (retain, nonatomic, nullable, getter=_geometryInWindowDidChangeObserver, setter=_setGeometryInWindowDidChange:) id<NSObject> geometryInWindowDidChangeObserver;
@end

@implementation _ConfigurationAlert

- (instancetype)init {
    if (self = [super init]) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_viewFrameDidChange:) name:NSViewFrameDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [super dealloc];
}

- (void)setAccessoryView:(NSView *)accessoryView {
    [super setAccessoryView:accessoryView];
    accessoryView.postsFrameChangedNotifications = YES;
}

- (void)_viewFrameDidChange:(NSNotification *)notification {
    if (![notification.object isEqual:self.accessoryView]) return;
    [self layout];
}

@end
