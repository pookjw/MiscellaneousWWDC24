//
//  TextInputLabel.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import "TextInputLabel.h"
#import "IndexedTextRange.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <random>

@implementation TextInputLabel

@synthesize inputDelegate = _inputDelegate;

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (CGRect)_muk_boundingRectForCharacterRange:(NSRange)range {
    // -[UILabel(PXAnimatedCounter) boundingRectForCharacterRange:] (PhotosUICore)
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    [layoutManager release];
    [textContainer release];
    
    return rect;
}

- (void)reloadSelectedTextRange {
    NSUInteger length = self.text.length;
    if (length == 0) {
        self.selectedRange = NSMakeRange(0, 0);
        return;
    }
    
    std::random_device rd;
    std::mt19937 generator(rd());
    
    std::uniform_int_distribution<NSUInteger> distribution_1(0, length - 1);
    NSUInteger loc = distribution_1(generator);
    
    std::uniform_int_distribution<NSUInteger> distribution_2(0, length - loc);
    NSUInteger sublength = distribution_2(generator);
    
    self.selectedRange = NSMakeRange(loc, sublength);
}

- (BOOL)hasText {
    return self.text.length > 0;
}

- (UITextPosition *)beginningOfDocument {
    return [[[IndexedTextPosition alloc] initWithIndex:0] autorelease];
}

- (UITextPosition *)endOfDocument {
    return [[[IndexedTextPosition alloc] initWithIndex:self.text.length] autorelease];
}

- (NSString *)textInRange:(UITextRange *)range {
    auto casted = static_cast<IndexedTextRange *>(range);
    assert([casted isKindOfClass:IndexedTextRange.class]);
    
    if (self.text.length < casted.nsRange.location) {
        return nil;
    } else if (self.text.length < (casted.nsRange.location + casted.nsRange.length)) {
        return [self.text substringFromIndex:casted.nsRange.location];
    }
    
    return [self.text substringWithRange:casted.nsRange];
}

- (NSWritingDirection)baseWritingDirectionForPosition:(nonnull UITextPosition *)position inDirection:(UITextStorageDirection)direction {
    return NSWritingDirectionNatural;
}

- (CGRect)caretRectForPosition:(nonnull UITextPosition *)position {
    assert([position isKindOfClass:IndexedTextPosition.class]);
    auto casted = static_cast<IndexedTextPosition *>(position);
    NSRange range = NSMakeRange(casted.index, 1);
    CGRect rect = [self _muk_boundingRectForCharacterRange:range];
    return rect;
}

- (nullable UITextRange *)characterRangeAtPoint:(CGPoint)point {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    
    NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
    [textContainer release];
    
    NSUInteger characterIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    [layoutManager release];
    
    IndexedTextPosition *start = [[IndexedTextPosition alloc] initWithIndex:characterIndex];
    IndexedTextPosition *end = [[IndexedTextPosition alloc] initWithIndex:characterIndex + 1];
    IndexedTextRange *range = [[IndexedTextRange alloc] initWithStart:start end:end];
    [start release];
    [end release];
    
    return [range autorelease];
}

- (nullable UITextRange *)characterRangeByExtendingPosition:(nonnull UITextPosition *)position inDirection:(UITextLayoutDirection)direction {
    assert([position isKindOfClass:IndexedTextPosition.class]);
    auto casted = static_cast<IndexedTextPosition *>(position);
    NSInteger startIndex = casted.index;
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    
    NSRange inputGlyphRange;
    [layoutManager characterRangeForGlyphRange:NSMakeRange(startIndex, 1) actualGlyphRange:&inputGlyphRange];
    
    CGRect inputRect = [layoutManager boundingRectForGlyphRange:inputGlyphRange inTextContainer:textContainer];
    
    CGRect findingRect;
    switch (direction) {
        case UITextLayoutDirectionUp:
            findingRect = CGRectMake(CGRectGetMinX(inputRect),
                                     CGRectGetMinY(self.bounds),
                                     CGRectGetWidth(inputRect),
                                     CGRectGetMinY(inputRect) - CGRectGetMinY(self.bounds));
            break;
        case UITextLayoutDirectionLeft:
            findingRect = CGRectMake(CGRectGetMinX(self.bounds),
                                     CGRectGetMinY(inputRect),
                                     CGRectGetMinX(inputRect) - CGRectGetMinX(self.bounds),
                                     CGRectGetHeight(inputRect));
            break;
        case UITextLayoutDirectionRight:
            findingRect = CGRectMake(CGRectGetMaxX(inputRect),
                                     CGRectGetMinY(inputRect),
                                     CGRectGetMaxX(self.bounds) - CGRectGetMaxX(inputRect),
                                     CGRectGetHeight(inputRect));
            break;
        case UITextLayoutDirectionDown:
            findingRect = CGRectMake(CGRectGetMinX(inputRect),
                                     CGRectGetMaxY(inputRect),
                                     CGRectGetWidth(inputRect),
                                     CGRectGetMaxY(self.bounds) - CGRectGetMaxY(inputRect));
            break;
        default:
            abort();
    }
    
    NSRange outputGlyphRange = [layoutManager glyphRangeForBoundingRect:findingRect inTextContainer:textContainer];
    [textContainer release];
    NSRange outputCharacterRange = [layoutManager characterRangeForGlyphRange:outputGlyphRange actualGlyphRange:NULL];
    [layoutManager release];
    
    return [[[IndexedTextRange alloc] initWithNSRange:outputCharacterRange] autorelease];
}

- (nullable UITextPosition *)closestPositionToPoint:(CGPoint)point {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    
    NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
    [textContainer release];
    
    NSUInteger characterIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    [layoutManager release];
    
    return [[[IndexedTextPosition alloc] initWithIndex:characterIndex] autorelease];
}

- (nullable UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(nonnull UITextRange *)range {
    assert([range isKindOfClass:IndexedTextRange.class]);
    
    auto casted = static_cast<IndexedTextRange *>(range);
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:casted.nsRange actualGlyphRange:&glyphRange];
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    
    if (CGRectContainsPoint(rect, point)) {
        NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
        [textContainer release];
        
        NSUInteger finalIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
        [layoutManager release];
        
        return [[[IndexedTextPosition alloc] initWithIndex:finalIndex] autorelease];
    } else {
        /*
                |       |
            1   |   2   |   3
                |       |
         -----------------------
                |       |
            4   |   X   |   5
                |       |
         -----------------------
                |       |
            6   |   7   |   8
                |       |
         */
        CGPoint nearestPoint;
        if ((CGRectGetMinY(rect) <= point.y) and (point.y <= CGRectGetMaxY(rect))) {
            if (point.x < CGRectGetMinX(rect)) {
                nearestPoint = CGPointMake(CGRectGetMinX(rect), point.y); // 4
            } else if (CGRectGetMaxX(rect) < point.x) {
                nearestPoint = CGPointMake(CGRectGetMaxX(rect), point.y); // 5
            } else {
                abort();
            }
        } else if ((CGRectGetMinX(rect) <= point.x) and (point.x <= CGRectGetMaxX(rect))) {
            if (point.y < CGRectGetMinY(rect)) {
                nearestPoint = CGPointMake(point.x, CGRectGetMinY(rect)); // 2
            } else if (CGRectGetMaxY(rect) < point.y) {
                nearestPoint = CGPointMake(point.x, CGRectGetMaxY(rect)); // 7
            } else {
                abort();
            }
        } else if ((point.x < CGRectGetMinX(rect)) and (point.y < CGRectGetMinY(rect))) {
            nearestPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)); // 1
        } else if ((CGRectGetMaxX(rect) < point.x) and (point.y < CGRectGetMinY(rect))) {
            nearestPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)); // 3
        } else if ((point.x < CGRectGetMinX(rect)) and (CGRectGetMaxY(rect) < point.y)) {
            nearestPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)); // 6
        } else if ((CGRectGetMaxX(rect) < point.x) and (point.y < CGRectGetMaxY(rect))) {
            nearestPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)); // 8
        } else {
            abort();
        }
        
        NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:nearestPoint inTextContainer:textContainer];
        [textContainer release];
        
        NSUInteger characterIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
        [layoutManager release];
        
        return [[[IndexedTextPosition alloc] initWithIndex:characterIndex] autorelease];
    }
}

- (NSComparisonResult)comparePosition:(nonnull UITextPosition *)position toPosition:(nonnull UITextPosition *)other {
    assert([position isKindOfClass:IndexedTextPosition.class]);
    assert([other isKindOfClass:IndexedTextPosition.class]);
    
    return [@(static_cast<IndexedTextPosition *>(position).index) compare:@(static_cast<IndexedTextPosition *>(other).index)];
}

- (CGRect)firstRectForRange:(nonnull UITextRange *)range {
    assert([range isKindOfClass:IndexedTextRange.class]);
    auto casted = static_cast<IndexedTextRange *>(range);
    return [self _muk_boundingRectForCharacterRange:casted.nsRange];
}

- (NSInteger)offsetFromPosition:(nonnull UITextPosition *)from toPosition:(nonnull UITextPosition *)toPosition {
    assert([from isKindOfClass:IndexedTextPosition.class]);
    assert([toPosition isKindOfClass:IndexedTextPosition.class]);
    
    return static_cast<IndexedTextPosition *>(toPosition).index - static_cast<IndexedTextPosition *>(from).index;
}

- (nullable UITextPosition *)positionFromPosition:(nonnull UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {
//    assert([position isKindOfClass:IndexedTextPosition.class]);
//    auto casted = static_cast<IndexedTextPosition *>(position);
//    
//    NSInteger newIndex = casted.index;
//    switch (direction) {
//        case UITextLayoutDirectionLeft:
//        case UITextLayoutDirectionUp:
//            newIndex += offset;
//            break;
//        case UITextLayoutDirectionRight:
//        case UITextLayoutDirectionDown:
//            newIndex -= offset;
//            break;
//        default:
//            abort();
//    }
//    
//    IndexedTextPosition *newPosition = [[IndexedTextPosition alloc] initWithIndex:newIndex];
//    return [newPosition autorelease];
    return [self positionFromPosition:position offset:offset];
}

- (nullable UITextPosition *)positionFromPosition:(nonnull UITextPosition *)position offset:(NSInteger)offset {
    assert([position isKindOfClass:IndexedTextPosition.class]);
    auto casted = static_cast<IndexedTextPosition *>(position);
    
    IndexedTextPosition *newPosition = [[IndexedTextPosition alloc] initWithIndex:casted.index + offset];
    return [newPosition autorelease];
}

- (nullable UITextPosition *)positionWithinRange:(nonnull UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction {
    assert([range isKindOfClass:IndexedTextRange.class]);
    auto casted = static_cast<IndexedTextRange *>(range);
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    
    NSRange inputGlyphRange;
    [layoutManager characterRangeForGlyphRange:casted.nsRange actualGlyphRange:&inputGlyphRange];
    
    CGRect inputRect = [layoutManager boundingRectForGlyphRange:inputGlyphRange inTextContainer:textContainer];
    
    CGRect findingRect;
    switch (direction) {
        case UITextLayoutDirectionUp:
            findingRect = CGRectMake(CGRectGetMinX(inputRect),
                                     CGRectGetMinY(self.bounds),
                                     CGRectGetWidth(inputRect),
                                     CGRectGetMinY(inputRect) - CGRectGetMinY(self.bounds));
            break;
        case UITextLayoutDirectionLeft:
            findingRect = CGRectMake(CGRectGetMinX(self.bounds),
                                     CGRectGetMinY(inputRect),
                                     CGRectGetMinX(inputRect) - CGRectGetMinX(self.bounds),
                                     CGRectGetHeight(inputRect));
            break;
        case UITextLayoutDirectionRight:
            findingRect = CGRectMake(CGRectGetMaxX(inputRect),
                                     CGRectGetMinY(inputRect),
                                     CGRectGetMaxX(self.bounds) - CGRectGetMaxX(inputRect),
                                     CGRectGetHeight(inputRect));
            break;
        case UITextLayoutDirectionDown:
            findingRect = CGRectMake(CGRectGetMinX(inputRect),
                                     CGRectGetMaxY(inputRect),
                                     CGRectGetWidth(inputRect),
                                     CGRectGetMaxY(self.bounds) - CGRectGetMaxY(inputRect));
            break;
        default:
            abort();
    }
    
    NSRange outputGlyphRange = [layoutManager glyphRangeForBoundingRect:findingRect inTextContainer:textContainer];
    [textContainer release];
    NSRange outputCharacterRange = [layoutManager characterRangeForGlyphRange:outputGlyphRange actualGlyphRange:NULL];
    [layoutManager release];
    
    return [[[IndexedTextPosition alloc] initWithIndex:outputCharacterRange.location] autorelease];
}

- (void)replaceRange:(nonnull UITextRange *)range withText:(nonnull NSString *)text {
    assert([range isKindOfClass:IndexedTextRange.class]);
    auto casted = static_cast<IndexedTextRange *>(range);
    
    self.text = [self.text stringByReplacingCharactersInRange:casted.nsRange withString:text];
}

- (nonnull NSArray<UITextSelectionRect *> *)selectionRectsForRange:(nonnull UITextRange *)range {
    assert([range isKindOfClass:IndexedTextRange.class]);
    auto casted = static_cast<IndexedTextRange *>(range);
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [textStorage addLayoutManager:layoutManager];
    [textStorage release];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding = 0.;
    [layoutManager addTextContainer:textContainer];
    [textContainer release];
    
    NSRange inputGlyphRange;
    [layoutManager characterRangeForGlyphRange:casted.nsRange actualGlyphRange:&inputGlyphRange];
    
    NSMutableArray<__kindof UITextSelectionRect *> *results = [NSMutableArray new];
    [layoutManager enumerateLineFragmentsForGlyphRange:inputGlyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
        __kindof UITextSelectionRect *result = reinterpret_cast<id (*)(Class, SEL, CGRect, id)>(objc_msgSend)(objc_lookUpClass("_UIMutableTextSelectionRect"), sel_registerName("selectionRectWithRect:fromView:"), rect, self);
        [results addObject:result];
    }];
    
    return [results autorelease];
}

- (void)setBaseWritingDirection:(NSWritingDirection)writingDirection forRange:(nonnull UITextRange *)range {
    NSLog(@"TODO");
}

- (void)setMarkedText:(nullable NSString *)markedText selectedRange:(NSRange)selectedRange {
    NSLog(@"TODO");
}

- (nullable UITextRange *)textRangeFromPosition:(nonnull UITextPosition *)fromPosition toPosition:(nonnull UITextPosition *)toPosition {
    assert([fromPosition isKindOfClass:IndexedTextPosition.class]);
    assert([toPosition isKindOfClass:IndexedTextPosition.class]);
    
    auto castedFrom = static_cast<IndexedTextPosition *>(fromPosition);
    auto castedTo = static_cast<IndexedTextPosition *>(toPosition);
    
    return [[[IndexedTextRange alloc] initWithStart:castedFrom end:castedTo] autorelease];
}

- (void)unmarkText {
    NSLog(@"TODO");
}

- (UITextRange *)selectedTextRange {
    NSRange selectedRange = self.selectedRange;
    if (selectedRange.location == 0 and selectedRange.length == 0) return nil;
    
    return [[[IndexedTextRange alloc] initWithNSRange:selectedRange] autorelease];
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange {
    assert([selectedTextRange isKindOfClass:IndexedTextRange.class]);
    auto casted = static_cast<IndexedTextRange *>(selectedTextRange);
    
    self.selectedRange = casted.nsRange;
}

- (UITextRange *)markedTextRange {
    return nil;
}

- (NSDictionary<NSAttributedStringKey,id> *)markedTextStyle {
    return nil;
}

- (void)setMarkedTextStyle:(NSDictionary<NSAttributedStringKey,id> *)markedTextStyle {
    NSLog(@"TODO");
}

- (id<UITextInputTokenizer>)tokenizer {
    return [[[UITextInputStringTokenizer alloc] initWithTextInput:self] autorelease];
}

- (void)deleteBackward { 
    NSString *text = self.text;
    if (text.length == 0) return;
    
    self.text = [text substringWithRange:NSMakeRange(0, text.length - 1)];
}

- (void)insertText:(nonnull NSString *)text { 
    self.text = [self.text stringByAppendingString:text];
}

@end
