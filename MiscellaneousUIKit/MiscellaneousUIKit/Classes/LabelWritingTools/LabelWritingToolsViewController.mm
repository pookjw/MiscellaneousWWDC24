//
//  LabelWritingToolsViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/5/24.
//

#import "LabelWritingToolsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#include <random>

@interface IndexedTextPosition : UITextPosition <NSCopying>
@property (assign, nonatomic, readonly) NSInteger index;
@end
@implementation IndexedTextPosition
- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        _index = index;
    }
    return self;
}
- (id)copyWithZone:(struct _NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        auto casted = static_cast<IndexedTextPosition *>(copy);
        casted->_index = _index;
    }
    
    return copy;
}
- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:IndexedTextPosition.class]) {
        return NO;
    } else {
        auto casted = static_cast<IndexedTextPosition *>(other);
        return _index == casted->_index;
    }
}

- (NSUInteger)hash {
    return _index;
}
@end

@interface IndexedTextRange : UITextRange <NSCopying>
@property (retain, nonatomic, readonly) IndexedTextPosition *start;
@property (retain, nonatomic, readonly) IndexedTextPosition *end;
@property (nonatomic, readonly) NSRange nsRange;
@end
@implementation IndexedTextRange
@synthesize start = _start;
@synthesize end = _end;

- (instancetype)initWithNSRange:(NSRange)range {
    IndexedTextPosition *start = [[IndexedTextPosition alloc] initWithIndex:range.location];
    IndexedTextPosition *end = [[IndexedTextPosition alloc] initWithIndex:range.location + range.length];
    
    self = [self initWithStart:start end:end];
    [start release];
    [end release];
    
    return self;
}

- (instancetype)initWithStart:(IndexedTextPosition *)start end:(IndexedTextPosition *)end {
    if (self = [super init]) {
        assert(start.index <= end.index);
        _start = [start retain];
        _end = [end retain];
    }
    return self;
}

- (void)dealloc {
    [_start release];
    [_end release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        auto casted = static_cast<IndexedTextRange *>(copy);
        casted->_start = [_start copyWithZone:zone];
        casted->_end = [_end copyWithZone:zone];
    }
    
    return copy;
}

- (BOOL)isEmpty {
    return NO;
}

- (NSRange)nsRange {
    return NSMakeRange(self.start.index, self.end.index - self.start.index);
}

@end

@interface TextInputLabel : UILabel <UITextInput>
@property (assign, nonatomic) NSRange selectedRange;
@end
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
    return [[[IndexedTextPosition alloc] initWithIndex:self.text.length - 1] autorelease];
}

- (NSString *)textInRange:(UITextRange *)range {
    auto casted = static_cast<IndexedTextRange *>(range);
    assert([casted isKindOfClass:IndexedTextRange.class]);
    
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
    
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:NSMakeRange(startIndex, 1) actualGlyphRange:&glyphRange];
    
    CGRect indexRect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    
    CGPoint point;
    switch (direction) {
        case UITextLayoutDirectionUp:
            point = CGPointMake(CGRectGetMinX(indexRect), CGRectGetMinY(self.bounds));
            break;
        case UITextLayoutDirectionLeft:
            point = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(indexRect));
            break;
        case UITextLayoutDirectionRight:
            point = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(indexRect));
            break;
        case UITextLayoutDirectionDown:
            point = CGPointMake(CGRectGetMinX(indexRect), CGRectGetMaxY(self.bounds));
            break;
        default:
            abort();
    }
    
    NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
    [textContainer release];
    
    NSUInteger finalIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    [layoutManager release];
    
    IndexedTextPosition *start;
    IndexedTextPosition *end;
    if (startIndex < finalIndex) {
        start = [[IndexedTextPosition alloc] initWithIndex:startIndex];
        end = [[IndexedTextPosition alloc] initWithIndex:finalIndex];
    } else {
        start = [[IndexedTextPosition alloc] initWithIndex:startIndex];
        end = [[IndexedTextPosition alloc] initWithIndex:finalIndex];
    }
    
    IndexedTextRange *range = [[IndexedTextRange alloc] initWithStart:start end:end];
    [start release];
    [end release];
    
    return [range autorelease];
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

//- (nullable UITextPosition *)positionFromPosition:(nonnull UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset { 
//    <#code#>
//}
//
//
//- (nullable UITextPosition *)positionFromPosition:(nonnull UITextPosition *)position offset:(NSInteger)offset { 
//    <#code#>
//}
//
//
//- (nullable UITextPosition *)positionWithinRange:(nonnull UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction { 
//    <#code#>
//}
//
//
//- (void)replaceRange:(nonnull UITextRange *)range withText:(nonnull NSString *)text { 
//    <#code#>
//}
//
//
//- (nonnull NSArray<UITextSelectionRect *> *)selectionRectsForRange:(nonnull UITextRange *)range { 
//    <#code#>
//}
//
//
//- (void)setBaseWritingDirection:(NSWritingDirection)writingDirection forRange:(nonnull UITextRange *)range { 
//    <#code#>
//}
//
//
//- (void)setMarkedText:(nullable NSString *)markedText selectedRange:(NSRange)selectedRange { 
//    <#code#>
//}
//
//
//- (nullable UITextRange *)textRangeFromPosition:(nonnull UITextPosition *)fromPosition toPosition:(nonnull UITextPosition *)toPosition { 
//    <#code#>
//}
//
//
//- (void)unmarkText { 
//    <#code#>
//}


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
    abort();
}

- (id<UITextInputTokenizer>)tokenizer {
    abort();
}


@end

@interface LabelWritingToolsViewController () <UIWritingToolsCoordinatorDelegate>
@property (retain, nonatomic, readonly) TextInputLabel *label;
@property (retain, nonatomic, readonly) UIWritingToolsCoordinator *writingToolsCoordinator;
@property (retain, nonatomic, readonly) UIBarButtonItem *menuBarButtonItem;
@end

@implementation LabelWritingToolsViewController
@synthesize label = _label;
@synthesize writingToolsCoordinator = _writingToolsCoordinator;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_label release];
    [_writingToolsCoordinator release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UILabel *label = self.label;
    [self.view addSubview:label];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), label);
    
    self.navigationItem.rightBarButtonItems = @[
        self.menuBarButtonItem
    ];
}

- (TextInputLabel *)label {
    if (auto label = _label) return label;
    
    TextInputLabel *label = [TextInputLabel new];
    label.numberOfLines = 0;
    
    NSURL *articleURL = [NSBundle.mainBundle URLForResource:@"article" withExtension:UTTypePlainText.preferredFilenameExtension];
    NSError * _Nullable error = nil;
    NSString *text = [[NSString alloc] initWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    label.text = text;
    [text release];
    
    _label = [label retain];
    return [label autorelease];
}

- (UIWritingToolsCoordinator *)writingToolsCoordinator {
    if (auto writingToolsCoordinator = _writingToolsCoordinator) return writingToolsCoordinator;
    
    UIWritingToolsCoordinator *writingToolsCoordinator = [[UIWritingToolsCoordinator alloc] initWithDelegate:self];
    [self.label addInteraction:writingToolsCoordinator];
    
    _writingToolsCoordinator = [writingToolsCoordinator retain];
    return [writingToolsCoordinator autorelease];
}

- (UIBarButtonItem *)menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    __block auto unretainedSelf = self;
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        completion(@[
            [unretainedSelf labelBecomeFirstResponderAction],
            [unretainedSelf showWritingToolsAction],
            [unretainedSelf stopWritingToolsAction],
            [unretainedSelf setBehaviorMenu],
//            [unretainedSelf setEffectContainerViewMenu],
//            [unretainedSelf setDecorationContainerViewMenu],
            [unretainedSelf setResultOptionsMenu],
            [unretainedSelf requestedToolsMenu]
        ]);
    }];
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemWritingTools menu:[UIMenu menuWithChildren:@[element]]];
    
    _menuBarButtonItem = [menuBarButtonItem retain];
    return [menuBarButtonItem autorelease];
}

- (UIAction *)labelBecomeFirstResponderAction {
    UILabel *label = self.label;
    
    UIAction *action = [UIAction actionWithTitle:@"becomeFirstResponder" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [label becomeFirstResponder];
    }];
    
    return action;
}

- (UIAction *)showWritingToolsAction {
    UILabel *label = self.label;
    
    UIAction *action = [UIAction actionWithTitle:@"showWritingTools:" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [label showWritingTools:action.sender];
    }];
    
//    action.attributes = UIMenuElementAttributesKeepsMenuPresented;
    
    return action;
}

- (UIAction *)stopWritingToolsAction {
    UILabel *label = self.label;
    
    UIAction *action = [UIAction actionWithTitle:@"stopWritingToolsAction" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        [textView.writingToolsCoordinator stopWritingTools];
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("_endWritingToolsIfNecessaryForResignFirstResponder"));
    }];
    
    return action;
}

- (UIMenu *)setBehaviorMenu {
    UIWritingToolsCoordinator *writingToolsCoordinator = self.writingToolsCoordinator;
    
    NSArray<NSNumber *> *allUIWritingToolsBehaviors = [LabelWritingToolsViewController allUIWritingToolsBehaviors];
    NSMutableArray<UIAction *> *behaviorActions = [[NSMutableArray alloc] initWithCapacity:allUIWritingToolsBehaviors.count];
    for (NSNumber *number in allUIWritingToolsBehaviors) {
        UIWritingToolsBehavior behavior = (UIWritingToolsBehavior)number.integerValue;
        
        UIAction *action = [UIAction actionWithTitle:[LabelWritingToolsViewController stringFromUIWritingToolsBehavior:(UIWritingToolsBehavior)number.integerValue]
                                               image:nil
                                          identifier:nil
                                             handler:^(__kindof UIAction * _Nonnull action) {
            // 둘이 같음
//            textView.writingToolsBehavior = (UIWritingToolsBehavior)number.integerValue;
            writingToolsCoordinator.preferredBehavior = behavior;
        }];
        
        action.state = (behavior == writingToolsCoordinator.preferredBehavior) ? UIMenuElementStateOn : UIMenuElementStateOff;
        
        [behaviorActions addObject:action];
    }
    
    UIMenu *behaviorMenu = [UIMenu menuWithTitle:@"UIWritingToolsBehavior" children:behaviorActions];
    [behaviorActions release];
    
    behaviorMenu.subtitle = [LabelWritingToolsViewController stringFromUIWritingToolsBehavior:writingToolsCoordinator.preferredBehavior];
    
    return behaviorMenu;
}

//- (UIMenu *)setDecorationContainerViewMenu {
//    UITextView *textView = self.textView;
//    UIView *decorationContainerView = self.decorationContainerView;
//    
//    UIMenu *menu = [UIMenu menuWithTitle:@"setDecorationContainerView" children:@[
//        [UIAction actionWithTitle:@"set" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        decorationContainerView.hidden = NO;
//        textView.writingToolsCoordinator.decorationContainerView = decorationContainerView;
//    }],
//        [UIAction actionWithTitle:@"nil" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        decorationContainerView.hidden = YES;
//        textView.writingToolsCoordinator.decorationContainerView = nil;
//    }]
//    ]];
//    
//    return menu;
//}
//
//- (UIMenu *)setEffectContainerViewMenu {
//    UITextView *textView = self.textView;
//    UIView *effectContainerView = self.effectContainerView;
//    
//    UIMenu *menu = [UIMenu menuWithTitle:@"setEffectContainerView:" children:@[
//        [UIAction actionWithTitle:@"set" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        effectContainerView.hidden = NO;
//        textView.writingToolsCoordinator.effectContainerView = effectContainerView;
//    }],
//        [UIAction actionWithTitle:@"nil" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        effectContainerView.hidden = YES;
//        textView.writingToolsCoordinator.effectContainerView = nil;
//    }]
//    ]];
//    
//    return menu;
//}

- (UIMenu *)requestedToolsMenu {
    NSArray<NSString *> *allRequestedTools = [LabelWritingToolsViewController allRequestedTools];
    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allRequestedTools.count];
    
    UILabel *label = self.label;
    
    for (NSString *tool in allRequestedTools) {
        UIAction *action = [UIAction actionWithTitle:tool image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(label, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), tool, nil, action.sender);
        }];
        
        [actions addObject:action];
    }
    
    UIMenu *menu = [UIMenu menuWithTitle:@"Request Tool" children:actions];
    [actions release];
    
    return menu;
}

- (UIMenu *)setResultOptionsMenu {
    NSArray<NSNumber *> *allUIWritingToolsResultOptions = [LabelWritingToolsViewController allUIWritingToolsResultOptions];
    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allUIWritingToolsResultOptions.count];
    
    UIWritingToolsCoordinator *writingToolsCoordinator = self.writingToolsCoordinator;
    
    for (NSNumber *number in allUIWritingToolsResultOptions) {
        UIWritingToolsResultOptions option = (UIWritingToolsResultOptions)number.unsignedIntegerValue;
        BOOL selected = (writingToolsCoordinator.preferredResultOptions & option) == option;
        
        UIAction *action = [UIAction actionWithTitle:[LabelWritingToolsViewController stringFromUIWritingToolsResultOption:option] image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIWritingToolsResultOptions newOptions;
            
            if (selected) {
                newOptions = writingToolsCoordinator.preferredResultOptions & ~option;
            } else {
                newOptions = writingToolsCoordinator.preferredResultOptions | option;
            }
            
            writingToolsCoordinator.preferredResultOptions = newOptions;
        }];
        
        action.state = selected ? UIMenuElementStateOn : UIMenuElementStateOff;
        
        [actions addObject:action];
    }
    
    UIMenu *menu = [UIMenu menuWithTitle:@"Preferred Result Options" children:actions];
    [actions release];
    
    return menu;
}

+ (NSString *)stringFromUIWritingToolsBehavior:(UIWritingToolsBehavior)behavior {
    switch (behavior) {
        case UIWritingToolsBehaviorNone:
            return @"None";
        case UIWritingToolsBehaviorDefault:
            return @"Default";
        case UIWritingToolsBehaviorComplete:
            return @"Complete";
        case UIWritingToolsBehaviorLimited:
            return @"Limited";
        default:
            abort();
    }
}

+ (NSArray<NSNumber *> *)allUIWritingToolsBehaviors {
    return @[
        @(UIWritingToolsBehaviorNone),
        @(UIWritingToolsBehaviorDefault),
        @(UIWritingToolsBehaviorComplete),
        @(UIWritingToolsBehaviorLimited)
    ];
}

+ (NSArray<NSString *> *)allRequestedTools {
    return @[
        @"WTUIRequestedToolNone",
        @"WTUIRequestedToolProofreading",
        @"WTUIRequestedToolRewriting",
        @"WTUIRequestedToolSmartReply",
        @"WTUIRequestedToolRewriteProofread",
        @"WTUIRequestedToolRewriteFriendly",
        @"WTUIRequestedToolRewriteProfessional",
        @"WTUIRequestedToolRewriteConcise",
        @"WTUIRequestedToolRewriteOpenEnded",
        @"WTUIRequestedToolSummary",
        @"WTUIRequestedToolTransformKeyPoints",
        @"WTUIRequestedToolTransformList",
        @"WTUIRequestedToolTransformTable",
        @"WTUIRequestedToolCompose"
    ];
}

+ (NSArray<NSNumber *> *)allUIWritingToolsResultOptions {
    return @[
        @(UIWritingToolsResultDefault),
        @(UIWritingToolsResultPlainText),
        @(UIWritingToolsResultRichText),
        @(UIWritingToolsResultList),
        @(UIWritingToolsResultTable)
    ];
}

+ (NSString *)stringFromUIWritingToolsResultOption:(UIWritingToolsResultOptions)option {
    if ((option & UIWritingToolsResultPlainText) == UIWritingToolsResultPlainText) {
        return @"Plain Text";
    } else if ((option & UIWritingToolsResultRichText) == UIWritingToolsResultRichText) {
        return @"Rich Text";
    } else if ((option & UIWritingToolsResultList) == UIWritingToolsResultList) {
        return @"Result List";
    } else if ((option & UIWritingToolsResultTable) == UIWritingToolsResultTable) {
        return @"Result Table";
    } else if ((option & UIWritingToolsResultDefault) == UIWritingToolsResultDefault) {
        return @"Default";
    } else {
        abort();
    }
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator finishTextAnimation:(UIWritingToolsCoordinatorTextAnimation)textAnimation forRange:(NSRange)range inContext:(nonnull UIWritingToolsCoordinatorContext *)context completion:(nonnull void (^)())completion { 
    completion();
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator prepareForTextAnimation:(UIWritingToolsCoordinatorTextAnimation)textAnimation forRange:(NSRange)range inContext:(nonnull UIWritingToolsCoordinatorContext *)context completion:(nonnull void (^)())completion { 
    completion();
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator replaceRange:(NSRange)range inContext:(nonnull UIWritingToolsCoordinatorContext *)context proposedText:(nonnull NSAttributedString *)replacementText reason:(UIWritingToolsCoordinatorTextReplacementReason)reason animationParameters:(UIWritingToolsCoordinatorAnimationParameters * _Nullable)animationParameters completion:(nonnull void (^)(NSAttributedString * _Nullable))completion { 
//    completion(self.textField.attributedText);
    self.label.attributedText = replacementText;
    completion(replacementText);
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator requestsBoundingBezierPathsForRange:(NSRange)range inContext:(nonnull UIWritingToolsCoordinatorContext *)context completion:(nonnull void (^)(NSArray<UIBezierPath *> * _Nonnull))completion { 
    completion(@[]);
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator requestsContextsForScope:(UIWritingToolsCoordinatorContextScope)scope completion:(nonnull void (^)(NSArray<UIWritingToolsCoordinatorContext *> * _Nonnull))completion { 
    UIWritingToolsCoordinatorContext *context = [[UIWritingToolsCoordinatorContext alloc] initWithAttributedString:self.label.attributedText range:NSMakeRange(0, self.label.text.length)];
    completion(@[context]);
    [context release];
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator requestsPreviewForTextAnimation:(UIWritingToolsCoordinatorTextAnimation)textAnimation ofRange:(NSRange)range inContext:(nonnull UIWritingToolsCoordinatorContext *)context completion:(nonnull void (^)(UITargetedPreview * _Nullable))completion { 
    completion(nil);
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator requestsRangeInContextWithIdentifierForPoint:(CGPoint)point completion:(nonnull void (^)(NSRange, NSUUID * _Nonnull))completion { 
    abort();
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator requestsUnderlinePathsForRange:(NSRange)range inContext:(nonnull UIWritingToolsCoordinatorContext *)context completion:(nonnull void (^)(NSArray<UIBezierPath *> * _Nonnull))completion { 
    completion(@[]);
}

- (void)writingToolsCoordinator:(nonnull UIWritingToolsCoordinator *)writingToolsCoordinator selectRanges:(nonnull NSArray<NSValue *> *)ranges inContext:(nonnull UIWritingToolsCoordinatorContext *)context completion:(nonnull void (^)())completion { 
    completion();
}

- (void)writingToolsCoordinator:(UIWritingToolsCoordinator *)writingToolsCoordinator willChangeToState:(UIWritingToolsCoordinatorState)newState completion:(void (^)())completion {
    completion();
}

@end
