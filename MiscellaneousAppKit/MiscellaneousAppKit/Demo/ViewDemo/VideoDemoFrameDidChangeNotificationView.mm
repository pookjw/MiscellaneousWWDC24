//
//  VideoDemoFrameDidChangeNotificationView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 4/4/25.
//

#import "VideoDemoFrameDidChangeNotificationView.h"
#import "RectSlidersView.h"

@interface VideoDemoFrameDidChangeNotificationView ()
@property (retain, nonatomic, readonly, getter=_secondaryView) NSTextField *secondaryView;
@property (retain, nonatomic, readonly, getter=_slidersView) RectSlidersView *slidersView;
@end

@implementation VideoDemoFrameDidChangeNotificationView
@synthesize secondaryView = _secondaryView;
@synthesize slidersView = _slidersView;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.secondaryView];
        [self addSubview:self.slidersView];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_slidersValueDidChange:) name:RectSlidersViewDidChangeValueNotification object:self.slidersView];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_frameDidChange:) name:NSViewFrameDidChangeNotification object:self.secondaryView];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_secondaryView release];
    [_slidersView release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    
    RectSlidersView *slidersView = self.slidersView;
    slidersView.frame = NSMakeRect(0., 0., self.bounds.size.width, slidersView.fittingSize.height);
    
    RectSlidersConfiguration *configuration = [[RectSlidersConfiguration alloc] initWithRect:self.secondaryView.frame minRect:NSZeroRect maxRect:NSMakeRect(self.bounds.size.width, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height) keyPaths:nil userInfo:nil];
    slidersView.configuration = configuration;
    [configuration release];
}

- (NSTextField *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSTextField *secondaryView = [NSTextField wrappingLabelWithString:NSStringFromRect(NSMakeRect(0., 0., 50., 50.))];
    secondaryView.frame = NSMakeRect(0., 0., 50., 50.);
    secondaryView.backgroundColor = NSColor.textBackgroundColor;
    secondaryView.textColor = NSColor.labelColor;
    secondaryView.drawsBackground = YES;
    secondaryView.postsFrameChangedNotifications = YES;
    
    _secondaryView = [secondaryView retain];
    return secondaryView;
}

- (RectSlidersView *)_slidersView {
    if (auto slidersView = _slidersView) return slidersView;
    
    RectSlidersView *slidersView = [RectSlidersView new];
    
    _slidersView = slidersView;
    return slidersView;
}

- (void)_slidersValueDidChange:(NSNotification *)notification {
    self.secondaryView.frame = self.slidersView.configuration.rect;
}

- (void)_frameDidChange:(NSNotification *)notification {
    self.secondaryView.stringValue = NSStringFromRect(self.secondaryView.frame);
}

@end
