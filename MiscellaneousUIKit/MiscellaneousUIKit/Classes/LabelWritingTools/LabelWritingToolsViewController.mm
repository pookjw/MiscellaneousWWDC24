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

@interface TextInputLabel : UILabel <UITextInput>
@end
@implementation TextInputLabel
- (BOOL)canBecomeFirstResponder {
    return YES;
}
//- (UITextRange *)selectedTextRange {
//    
//}
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
