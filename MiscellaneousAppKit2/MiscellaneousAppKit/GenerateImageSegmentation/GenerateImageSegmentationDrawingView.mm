//
//  GenerateImageSegmentationDrawingView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/7/25.
//

#import "GenerateImageSegmentationDrawingView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <optional>

@interface GenerateImageSegmentationDrawingView ()
@property (assign, nonatomic) std::optional<unsigned long long> _currentEventUniqueID;
@property (retain, nonatomic, readonly) NSMutableArray<NSValue *> *_drawingPoints;
@end

@implementation GenerateImageSegmentationDrawingView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit];
    }
    
    return self;
}

- (void)dealloc {
    [__drawingPoints release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSGraphicsContext *context = NSGraphicsContext.currentContext;
    [context saveGraphicsState];
    
    context.shouldAntialias = YES;
    
    NSMutableArray<NSValue *> *drawingPoints = self._drawingPoints;
    
    if (drawingPoints.count > 1) {
        NSBezierPath *bezierPath = [NSBezierPath new];
        
        for (NSValue *drawingPoint in drawingPoints) {
            if (bezierPath.isEmpty) {
                [bezierPath moveToPoint:drawingPoint.pointValue];
            } else {
                [bezierPath lineToPoint:drawingPoint.pointValue];
            }
        }
        
        bezierPath.lineWidth = 3.;
        [NSColor.cyanColor setStroke];
        [bezierPath stroke];
        
        [bezierPath release];
    }
    
    [context restoreGraphicsState];
}

- (void)mouseDown:(NSEvent *)event {
    if (self._currentEventUniqueID.has_value()) return;
    
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint convertedLocation = [self convertPoint:locationInWindow fromView:nil];
    
    self._currentEventUniqueID = event.uniqueID;
    [self._drawingPoints removeAllObjects];
    [self._drawingPoints addObject:@(convertedLocation)];
    self.needsDisplay = YES;
}

- (void)mouseDragged:(NSEvent *)event {
    if (!self._currentEventUniqueID.has_value()) return;
    if (self._currentEventUniqueID.value() != event.uniqueID) return;
    
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint convertedLocation = [self convertPoint:locationInWindow fromView:nil];
    [self._drawingPoints addObject:@(convertedLocation)];
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)event {
    if (!self._currentEventUniqueID.has_value()) return;
    if (self._currentEventUniqueID.value() != event.uniqueID) return;
    
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint convertedLocation = [self convertPoint:locationInWindow fromView:nil];
    [self._drawingPoints addObject:@(convertedLocation)];
    
    self._currentEventUniqueID = std::nullopt;
    
    if (id<GenerateImageSegmentationDrawingViewDelegate> delegate = self.delegate) {
        NSArray<NSValue *> *drawingPoints = [self._drawingPoints copy];
        [delegate generateImageSegmentationDrawingView:self didFinishDrawingWithPoints:drawingPoints];
        [drawingPoints release];
    }
    
    [self._drawingPoints removeAllObjects];
    
    self.needsDisplay = YES;
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)_commonInit {
    __currentEventUniqueID = std::nullopt;
    __drawingPoints = [NSMutableArray new];
}

@end
