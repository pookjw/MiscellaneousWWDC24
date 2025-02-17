//
//  RectSlidersView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import "RectSlidersView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <cstring>
#import <ranges>

#define RECT_VALUE_KEY @"rectValue"
#define MIN_RECT_VALUE_KEY @"minRectValue"
#define MAX_RECT_VALUE_KEY @"maxRectValue"
#define KEYPATHS_KEY @"keyPaths"
#define USER_INFO_KEY @"userInfo"
#define CONFIGURATION_KEY @"ma_rectSlidersConfiguration"

#define X_SLIDER_TAG 100
#define Y_SLIDER_TAG 101
#define WIDTH_SLIDER_TAG 102
#define HEIGHT_SLIDER_TAG 103

NSNotificationName const RectSlidersViewDidChangeValueNotification = @"RectSlidersViewDidChangeValueNotification";
NSString * const RectSlidersIsTrackingKey = @"RectSlidersIsTrackingKey";
NSString * const RectSlidersConfigurationKey = @"RectSlidersConfigurationKey";
NSString * const RectSlidersChangedKeyPath = @"RectSlidersChangedKeyPath";
RectSlidersKeyPath const RectSlidersKeyPathX = @"RectSlidersKeyPathX";
RectSlidersKeyPath const RectSlidersKeyPathY = @"RectSlidersKeyPathY";
RectSlidersKeyPath const RectSlidersKeyPathWidth = @"RectSlidersKeyPathWidth";
RectSlidersKeyPath const RectSlidersKeyPathHeight = @"RectSlidersKeyPathHeight";

@implementation RectSlidersConfiguration

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (RectSlidersConfiguration *)configurationWithRect:(NSRect)rect minRect:(NSRect)minRect maxRect:(NSRect)maxRect keyPaths:(NSSet<RectSlidersKeyPath> * _Nullable)keyPaths userInfo:(NSDictionary * _Nullable)userInfo {
    return [[[RectSlidersConfiguration alloc] initWithRect:rect minRect:minRect maxRect:maxRect keyPaths:keyPaths userInfo:userInfo] autorelease];
}

- (instancetype)initWithRect:(NSRect)rect minRect:(NSRect)minRect maxRect:(NSRect)maxRect keyPaths:(NSSet<RectSlidersKeyPath> * _Nullable)keyPaths userInfo:(NSDictionary * _Nullable)userInfo {
    for (RectSlidersKeyPath keyPath in keyPaths) {
        if (!([keyPath isEqualToString:RectSlidersKeyPathX]) and
            !([keyPath isEqualToString:RectSlidersKeyPathY]) and
            !([keyPath isEqualToString:RectSlidersKeyPathWidth]) and
            !([keyPath isEqualToString:RectSlidersKeyPathHeight])) {
            abort();
        }
    }
    
    if (self = [super init]) {
        _rect = rect;
        _minRect = minRect;
        _maxRect = maxRect;
        _keyPaths = [keyPaths copy];
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
    NSArray<RectSlidersKeyPath> *keyPaths = [coder decodeObjectOfClasses:[NSSet setWithArray:@[[NSSet class], [NSString class]]] forKey:KEYPATHS_KEY];
    NSDictionary *userInfo = [coder decodeObjectOfClass:[NSDictionary class] forKey:USER_INFO_KEY];
    
    if (self = [super init]) {
        _rect = rectValue.rectValue;
        _minRect = minRectValue.rectValue;
        _maxRect = maxRectValue.rectValue;
        _keyPaths = [keyPaths copy];
        _userInfo = [userInfo copy];
    }
    
    return self;
}

- (void)dealloc {
    [_keyPaths release];
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
    
    if (_keyPaths) {
        [coder encodeObject:_keyPaths forKey:KEYPATHS_KEY];
    }
    
    if (_userInfo) {
        [coder encodeObject:_userInfo forKey:USER_INFO_KEY];
    }
}

- (RectSlidersConfiguration *)configurationWithNewRect:(NSRect)newRect {
    return [RectSlidersConfiguration configurationWithRect:newRect minRect:_minRect maxRect:_maxRect keyPaths:_keyPaths userInfo:_userInfo];
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
                                                                    keyPaths:nil
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
    [super layout];
    
    NSArray<NSSlider *> *sliders = [self _slidersFromKeyPaths:self.configuration.keyPaths];
    NSRect bounds = self.bounds;
    NSUInteger count = sliders.count;
    assert(count > 0);
    
    [sliders enumerateObjectsUsingBlock:^(NSSlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = NSMakeRect(NSMinX(bounds),
                               NSMinY(bounds) + NSHeight(bounds) * (1. - (1. / count) * (idx + 1)),
                               NSWidth(bounds),
                               NSHeight(bounds) * (1. / count));
    }];
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
    
    
    NSMutableArray<NSSlider *> *hideSliders = [[NSMutableArray alloc] initWithObjects:_xSlider, _ySlider, _widthSlider, _heightSlider, nil];
    for (NSSlider *slider in [self _slidersFromKeyPaths:configuration.keyPaths]) {
        [hideSliders removeObject:slider];
        slider.hidden = NO;
    }
    for (NSSlider *slider in hideSliders) {
        slider.hidden = YES;
    }
    [hideSliders release];
    
    [self layout];
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
    
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList([sender.cell class], &ivarsCount);
    
    Ivar *ivarPtr = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        auto name = ivar_getName(ivar);
        return std::strcmp(name, "_scFlags") == 0;
    });
    
    assert(*ivarPtr != NULL);
    ptrdiff_t offset = ivar_getOffset(*ivarPtr);
    free(ivars);
    uintptr_t base = reinterpret_cast<uintptr_t>(sender.cell);
    uint8_t value = *reinterpret_cast<uint8_t *>(base + offset);
    BOOL isTracking = (value & 0x8);
    
    [NSNotificationCenter.defaultCenter postNotificationName:RectSlidersViewDidChangeValueNotification
                                                      object:self
                                                    userInfo:@{
        RectSlidersIsTrackingKey: @(isTracking),
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

- (NSArray<NSSlider *> *)_slidersFromKeyPaths:(NSSet<RectSlidersKeyPath> * _Nullable)keyPaths {
    NSArray<NSSlider *> *sliders;
    if (keyPaths != nil) {
        if (keyPaths.count == 0) {
            sliders = @[
                _xSlider,
                _ySlider,
                _widthSlider,
                _heightSlider
            ];
        } else {
            NSMutableArray<NSSlider *> *_sliders = [NSMutableArray array];
            
            for (RectSlidersKeyPath keyPath in keyPaths) {
                if ([keyPath isEqualToString:RectSlidersKeyPathX]) {
                    [_sliders addObject:_xSlider];
                } else if ([keyPath isEqualToString:RectSlidersKeyPathY]) {
                    [_sliders addObject:_ySlider];
                } else if ([keyPath isEqualToString:RectSlidersKeyPathWidth]) {
                    [_sliders addObject:_widthSlider];
                } else if ([keyPath isEqualToString:RectSlidersKeyPathHeight]) {
                    [_sliders addObject:_heightSlider];
                } else {
                    abort();
                }
            }
            
            sliders = _sliders;
        }
    } else {
        sliders = @[
            _xSlider,
            _ySlider,
            _widthSlider,
            _heightSlider
        ];
    }
    
    return [sliders sortedArrayUsingComparator:^NSComparisonResult(NSSlider * _Nonnull obj1, NSSlider * _Nonnull obj2) {
        return [@(obj1.tag) compare:@(obj2.tag)];
    }];
}

@end
