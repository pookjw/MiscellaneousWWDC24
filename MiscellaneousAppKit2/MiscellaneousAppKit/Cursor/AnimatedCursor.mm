//
//  AnimatedCursor.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/28/24.
//

#import "AnimatedCursor.h"
#import <CoreFoundation/CoreFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

// thanks https://github.com/NUIKit/CGSInternal

typedef int CGSConnectionID;

CG_EXTERN CGSConnectionID CGSMainConnectionID(void);

// SLSRegisterCursorWithImages
CG_EXTERN CGError CGSRegisterCursorWithImages(CGSConnectionID cid,
                                              const char *cursorName,
                                              bool setGlobally,
                                              bool instantly,
                                              NSUInteger frameCount,
                                              CFArrayRef imageArray,
                                              CGSize cursorSize,
                                              CGPoint hotspot,
                                              int *seed,
                                              CGRect bounds,
                                              CGFloat frameDuration,
                                              NSInteger repeatCount);

@interface AnimatedCursor ()
@property (retain, readonly, nonatomic) id eventObserver;
@property (assign, nonatomic, getter=isAnimating) BOOL animating;
@end

@implementation AnimatedCursor
@synthesize eventObserver = _eventObserver;

+ (NSImage *)imageAtFrame:(NSUInteger)frame {
    NSURL *URL = [NSBundle.mainBundle URLForResource:[NSString stringWithFormat:@"icons8-mouse-cursor-%lu", frame] withExtension:@"png"];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:URL];
    return [image autorelease];
}

- (instancetype)init {
    self = [super initWithImage:[AnimatedCursor imageAtFrame:0] hotSpot:NSZeroPoint];
    
    [self eventObserver];
    
    return self;
}

- (void)dealloc {
    if (id eventObserver = _eventObserver) {
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(eventObserver, sel_registerName("invalidate"));
        [eventObserver release];
    }
    
    [super dealloc];
}

- (id)eventObserver {
    if (id eventObserver = _eventObserver) return eventObserver;
    
    __weak auto weakSelf = self;
    
    id eventObserver = reinterpret_cast<id (*)(Class, SEL, NSEventMask, id)>(objc_msgSend)(NSEvent.class, sel_registerName("addLocalMonitorForEventsMatchingMask:handler:"), NSEventMaskLeftMouseDown, ^NSEvent * (NSEvent *event) {
        if (auto _self = weakSelf) {
            _self.animating = YES;
            [_self _reallySet];
        }
        
        return event;
    });
    
    _eventObserver = [eventObserver retain];
    return eventObserver;
}

- (void)_reallySet {
    if (!self.animating) {
        struct objc_super superInfo = { self, [self class] };
        reinterpret_cast<void (*)(struct objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
        return;
    }
    
    CFIndex imagesCount = 28;
    
    CFMutableArrayRef imageArray = CFArrayCreateMutable(kCFAllocatorDefault, imagesCount, &kCFTypeArrayCallBacks);
    
    for (CFIndex index = 0; index < imagesCount; index++) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        
        NSURL *url = [NSBundle.mainBundle URLForResource:[NSString stringWithFormat:@"icons8-mouse-cursor-%lu", index] withExtension:@"png"];
        NSString *urlString = url.path;
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([urlString cStringUsingEncoding:NSUTF8StringEncoding]);
        CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, YES, kCGRenderingIntentDefault);
        CFRelease(dataProvider);
        
        CFArrayAppendValue(imageArray, imageRef);
        CGImageRelease(imageRef);
        
        
        [pool release];
    }
    
    CGSConnectionID cid = CGSMainConnectionID();
    
    // 왜 안 됨 ㅠ
    int seed;
    CGError result = CGSRegisterCursorWithImages(cid,
                                                 [[[NSUUID UUID] UUIDString] cStringUsingEncoding:NSUTF8StringEncoding],
                                                 YES,
                                                 YES,
                                                 imagesCount,
                                                 imageArray,
                                                 CGSizeMake(40., 40.),
                                                 CGPointZero,
                                                 &seed,
                                                 CGRectMake(0., 0., 40., 40.), 
                                                 0.1, 
                                                 0);
    
    assert(result == kCGErrorSuccess);
    
    CFRelease(imageArray);
}

@end
