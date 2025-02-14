//
//  RectSlidersView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import "RectSlidersView.h"
#import <objc/message.h>
#import <objc/runtime.h>

#define RECT_VALUE_KEY @"rectValue"
#define MIN_RECT_VALUE_KEY @"minRectValue"
#define MAX_RECT_VALUE_KEY @"maxRectValue"
#define USER_INFO_KEY @"userInfo"
#define CONFIGURATION_KEY @"ma_rectSlidersConfiguration"

#define X_SLIDER_TAG 100
#define Y_SLIDER_TAG 101
#define WIDTH_SLIDER_TAG 102
#define HEIGHT_SLIDER_TAG 103

NSNotificationName const RectSlidersViewDidChangeValueNotification = @"RectSlidersViewDidChangeValueNotification";
NSString * RectSlidersConfigurationKey = @"RectSlidersConfigurationKey";
NSString * RectSlidersChangedKeyPath = @"RectSlidersChangedKeyPath";
NSString * RectSlidersKeyPathX = @"RectSlidersKeyPathX";
NSString * RectSlidersKeyPathY = @"RectSlidersKeyPathY";
NSString * RectSlidersKeyPathWidth = @"RectSlidersKeyPathWidth";
NSString * RectSlidersKeyPathHeight = @"RectSlidersKeyPathHeight";

@implementation RectSlidersConfiguration

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (RectSlidersConfiguration *)configurationWithRect:(NSRect)rect minRect:(NSRect)minRect maxRect:(NSRect)maxRect userInfo:(NSDictionary * _Nullable)userInfo {
    return [[[RectSlidersConfiguration alloc] initWithRect:rect minRect:minRect maxRect:maxRect userInfo:userInfo] autorelease];
}

- (instancetype)initWithRect:(NSRect)rect minRect:(NSRect)minRect maxRect:(NSRect)maxRect userInfo:(NSDictionary * _Nullable)userInfo {
    if (self = [super init]) {
        _rect = rect;
        _minRect = minRect;
        _maxRect = maxRect;
        _userInfo = [userInfo copy];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSValue *rectValue = [coder decodeObjectOfClass:[NSValue class] forKey:RECT_VALUE_KEY];
    assert(rectValue != nil);
    NSValue *minRectValue = [coder decodeObjectOfClass:[NSValue class] forKey:MIN_RECT_VALUE_KEY];
    assert(minRectValue != nil);
    NSValue *maxRectValue = [coder decodeObjectOfClass:[NSValue class] forKey:MAX_RECT_VALUE_KEY];
    assert(maxRectValue != nil);
    NSDictionary *userInfo = [coder decodeObjectOfClass:[NSDictionary class] forKey:USER_INFO_KEY];
    
    if (self = [super init]) {
        _rect = rectValue.rectValue;
        _minRect = minRectValue.rectValue;
        _maxRect = maxRectValue.rectValue;
        _userInfo = [userInfo copy];
    }
    
    return self;
}

- (void)dealloc {
    [_userInfo release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSValue valueWithRect:_rect] forKey:RECT_VALUE_KEY];
    [coder encodeObject:[NSValue valueWithRect:_minRect] forKey:MIN_RECT_VALUE_KEY];
    [coder encodeObject:[NSValue valueWithRect:_maxRect] forKey:MAX_RECT_VALUE_KEY];
    
    if (_userInfo) {
        [coder encodeObject:_userInfo forKey:USER_INFO_KEY];
    }
}

- (RectSlidersConfiguration *)configurationWithNewRect:(NSRect)newRect {
    return [RectSlidersConfiguration configurationWithRect:newRect minRect:_minRect maxRect:_maxRect userInfo:_userInfo];
}

@end

@interface RectSlidersView ()
@property (retain, nonatomic, readonly, getter=_xSlider) NSSlider *xSlider;
@property (retain, nonatomic, readonly, getter=_ySlider) NSSlider *ySlider;
@property (retain, nonatomic, readonly, getter=_widthSlider) NSSlider *widthSlider;
@property (retain, nonatomic, readonly, getter=_heghtSlider) NSSlider *heightSlider;
@end

@implementation RectSlidersView
@synthesize xSlider = _xSlider;
@synthesize ySlider = _ySlider;
@synthesize widthSlider = _widthSlider;
@synthesize heightSlider = _heightSlider;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit_RectSlidersView];
        self.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., 50., 50.)
                                                                     minRect:NSZeroRect
                                                                     maxRect:NSMakeRect(100., 100., 100., 100.)
                                                                    userInfo:nil];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _xSlider = [[self viewWithTag:X_SLIDER_TAG] retain];
        assert(_xSlider.target == self);
        _ySlider = [[self viewWithTag:Y_SLIDER_TAG] retain];
        assert(_ySlider.target == self);
        _widthSlider = [[self viewWithTag:WIDTH_SLIDER_TAG] retain];
        assert(_widthSlider.target == self);
        _heightSlider = [[self viewWithTag:HEIGHT_SLIDER_TAG] retain];
        assert(_heightSlider.target == self);
        
        self.configuration = [coder decodeObjectForKey:CONFIGURATION_KEY];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_xSlider release];
    [_ySlider release];
    [_widthSlider release];
    [_heightSlider release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.configuration forKey:CONFIGURATION_KEY];
}

- (void)layout {
    NSRect bounds = self.bounds;
    
    _xSlider.frame = NSMakeRect(NSMinX(bounds),
                                NSMinY(bounds) + NSHeight(bounds) * 0.75,
                                NSWidth(bounds),
                                NSHeight(bounds) * 0.25);
    
    _ySlider.frame = NSMakeRect(NSMinX(bounds),
                                NSMinY(bounds) + NSHeight(bounds) * 0.5,
                                NSWidth(bounds),
                                NSHeight(bounds) * 0.25);
    
    _widthSlider.frame = NSMakeRect(NSMinX(bounds),
                                NSMinY(bounds) + NSHeight(bounds) * 0.25,
                                NSWidth(bounds),
                                NSHeight(bounds) * 0.25);
    
    _heightSlider.frame = NSMakeRect(NSMinX(bounds),
                                NSMinY(bounds),
                                NSWidth(bounds),
                                NSHeight(bounds) * 0.25);
}

- (void)_commonInit_RectSlidersView {
    _xSlider = [self _newSlider];
    _xSlider.tag = X_SLIDER_TAG;
    [self addSubview:_xSlider];
    
    _ySlider = [self _newSlider];
    _ySlider.tag = Y_SLIDER_TAG;
    [self addSubview:_ySlider];
    
    _widthSlider = [self _newSlider];
    _widthSlider.tag = WIDTH_SLIDER_TAG;
    [self addSubview:_widthSlider];
    
    _heightSlider = [self _newSlider];
    _heightSlider.tag = HEIGHT_SLIDER_TAG;
    [self addSubview:_heightSlider];
}

- (NSSlider *)_newSlider {
    NSSlider *slider = [NSSlider new];
    slider.target = self;
    slider.action = @selector(_didChangeSliderValue:);
    return slider;
}

- (void)setConfiguration:(RectSlidersConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    _xSlider.minValue = NSMinX(_configuration.minRect);
    _xSlider.maxValue = NSMinX(_configuration.maxRect);
    _xSlider.doubleValue = NSMinX(_configuration.rect);
    
    _ySlider.minValue = NSMinY(_configuration.minRect);
    _ySlider.maxValue = NSMinY(_configuration.maxRect);
    _ySlider.doubleValue = NSMinY(_configuration.rect);
    
    _widthSlider.minValue = NSWidth(_configuration.minRect);
    _widthSlider.maxValue = NSWidth(_configuration.maxRect);
    _widthSlider.doubleValue = NSWidth(_configuration.rect);
    
    _heightSlider.minValue = NSHeight(_configuration.minRect);
    _heightSlider.maxValue = NSHeight(_configuration.maxRect);
    _heightSlider.doubleValue = NSHeight(_configuration.rect);
}

- (void)_didChangeSliderValue:(NSSlider *)sender {
    NSString *keyPath;
    if ([sender isEqual:_xSlider]) {
        keyPath = RectSlidersKeyPathX;
    } else if ([sender isEqual:_ySlider]) {
        keyPath = RectSlidersKeyPathY;
    } else if ([sender isEqual:_widthSlider]) {
        keyPath = RectSlidersKeyPathWidth;
    } else if ([sender isEqual:_heightSlider]) {
        keyPath = RectSlidersKeyPathHeight;
    } else {
        abort();
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:RectSlidersViewDidChangeValueNotification
                                                      object:self
                                                    userInfo:@{
        RectSlidersConfigurationKey: [self _configurationFromSliderVaues],
        RectSlidersChangedKeyPath: keyPath
    }];
}

- (RectSlidersConfiguration *)_configurationFromSliderVaues {
    return [self.configuration configurationWithNewRect:NSMakeRect(_xSlider.doubleValue,
                                                                   _ySlider.doubleValue,
                                                                   _widthSlider.doubleValue,
                                                                   _heightSlider.doubleValue)];
}

@end
