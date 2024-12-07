//
//  NewWritingToolsViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/4/24.
//

#import "NewWritingToolsViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

/*
 _UIWTCProofreadingDecorationView
 _UIWTCProofreadingInteraction
 */

@interface NewWritingToolsViewController () <UITextViewDelegate>
@property (retain, nonatomic, readonly) UITextView *textView;
@property (retain, nonatomic, readonly) UIImageView *decorationContainerView;
@property (retain, nonatomic, readonly) UIImageView *effectContainerView;
@property (retain, nonatomic, readonly) UIBarButtonItem *menuBarButtonItem;
@end

@implementation NewWritingToolsViewController
@synthesize textView = _textView;
@synthesize decorationContainerView = _decorationContainerView;
@synthesize effectContainerView = _effectContainerView;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_textView release];
    [_decorationContainerView release];
    [_effectContainerView release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    assert(UIWritingToolsCoordinator.isWritingToolsAvailable);
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    NSLog(@"%@", self.textView.writingToolsCoordinator);
    
//    self.decorationContainerView.hidden = YES;
//    [self.view addSubview:self.decorationContainerView];
//    self.decorationContainerView.translatesAutoresizingMaskIntoConstraints = NO;
//    [NSLayoutConstraint activateConstraints:@[
//        [self.decorationContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
//        [self.decorationContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
//        [self.decorationContainerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
//        [self.decorationContainerView.heightAnchor constraintEqualToConstant:200.]
//    ]];
    
    [self.view addSubview:self.textView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.textView);
    
    self.effectContainerView.hidden = YES;
    [self.view addSubview:self.effectContainerView];
    self.effectContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.effectContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.effectContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.effectContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.effectContainerView.heightAnchor constraintEqualToConstant:200.]
    ]];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.rightBarButtonItems = @[
        self.menuBarButtonItem
    ];
}

- (UITextView *)textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    textView.delegate = self;
    textView.backgroundColor = UIColor.clearColor;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    
    NSURL *articleURL = [NSBundle.mainBundle URLForResource:@"article" withExtension:UTTypePlainText.preferredFilenameExtension];
    NSError * _Nullable error = nil;
    NSString *text = [[NSString alloc] initWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    textView.text = text;
    [text release];
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (UIImageView *)decorationContainerView {
    if (auto decorationContainerView = _decorationContainerView) return decorationContainerView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"beer" withExtension:@"jpg"];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    
    UIImageView *decorationContainerView = [[UIImageView alloc] initWithImage:image];
    decorationContainerView.contentMode = UIViewContentModeScaleAspectFill;
    decorationContainerView.clipsToBounds = YES;
    
    _decorationContainerView = [decorationContainerView retain];
    return [decorationContainerView autorelease];
}

- (UIImageView *)effectContainerView {
    if (auto effectContainerView = _effectContainerView) return effectContainerView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"image" withExtension:UTTypeHEIC.preferredFilenameExtension];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    
    UIImageView *effectContainerView = [[UIImageView alloc] initWithImage:image];
    effectContainerView.contentMode = UIViewContentModeScaleAspectFill;
    effectContainerView.clipsToBounds = YES;
    
    _effectContainerView = [effectContainerView retain];
    return [effectContainerView autorelease];
}

- (UIBarButtonItem *)menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    __block auto unretainedSelf = self;
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        completion(@[
            [unretainedSelf selectAllAction],
            [unretainedSelf showWritingToolsAction],
            [unretainedSelf stopWritingToolsAction],
            [unretainedSelf setBehaviorMenu],
            [unretainedSelf setEffectContainerViewMenu],
            [unretainedSelf setDecorationContainerViewMenu],
            [unretainedSelf setResultOptionsMenu],
            [unretainedSelf requestedToolsMenu]
        ]);
    }];
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemWritingTools menu:[UIMenu menuWithChildren:@[element]]];
    
    _menuBarButtonItem = [menuBarButtonItem retain];
    return [menuBarButtonItem autorelease];
}

- (UIAction *)selectAllAction {
    UITextView *textView = self.textView;
    
    UIAction *action = [UIAction actionWithTitle:@"Select All" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [textView selectAll:action.sender];
    }];
    
    action.attributes = UIMenuElementAttributesKeepsMenuPresented;
    
    return action;
}

- (UIAction *)showWritingToolsAction {
    UITextView *textView = self.textView;
    
    UIAction *action = [UIAction actionWithTitle:@"showWritingTools:" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [textView showWritingTools:action.sender];
    }];
    
//    action.attributes = UIMenuElementAttributesKeepsMenuPresented;
    
    return action;
}

- (UIAction *)stopWritingToolsAction {
    UITextView *textView = self.textView;
    
    UIAction *action = [UIAction actionWithTitle:@"stopWritingToolsAction" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        [textView.writingToolsCoordinator stopWritingTools];
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("_endWritingToolsIfNecessaryForResignFirstResponder"));
    }];
    
    return action;
}

- (UIMenu *)setBehaviorMenu {
    UITextView *textView = self.textView;
    
    NSArray<NSNumber *> *allUIWritingToolsBehaviors = [NewWritingToolsViewController allUIWritingToolsBehaviors];
    NSMutableArray<UIAction *> *behaviorActions = [[NSMutableArray alloc] initWithCapacity:allUIWritingToolsBehaviors.count];
    for (NSNumber *number in allUIWritingToolsBehaviors) {
        UIWritingToolsBehavior behavior = (UIWritingToolsBehavior)number.integerValue;
        
        UIAction *action = [UIAction actionWithTitle:[NewWritingToolsViewController stringFromUIWritingToolsBehavior:(UIWritingToolsBehavior)number.integerValue]
                                               image:nil
                                          identifier:nil
                                             handler:^(__kindof UIAction * _Nonnull action) {
            // 둘이 같음
//            textView.writingToolsBehavior = (UIWritingToolsBehavior)number.integerValue;
            textView.writingToolsCoordinator.preferredBehavior = behavior;
        }];
        
        action.state = (behavior == textView.writingToolsCoordinator.preferredBehavior) ? UIMenuElementStateOn : UIMenuElementStateOff;
        
        [behaviorActions addObject:action];
    }
    
    UIMenu *behaviorMenu = [UIMenu menuWithTitle:@"UIWritingToolsBehavior" children:behaviorActions];
    [behaviorActions release];
    
    behaviorMenu.subtitle = [NewWritingToolsViewController stringFromUIWritingToolsBehavior:textView.writingToolsCoordinator.preferredBehavior];
    
    return behaviorMenu;
}

- (UIMenu *)setDecorationContainerViewMenu {
    UITextView *textView = self.textView;
    UIView *decorationContainerView = self.decorationContainerView;
    
    UIMenu *menu = [UIMenu menuWithTitle:@"setDecorationContainerView" children:@[
        [UIAction actionWithTitle:@"set" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        decorationContainerView.hidden = NO;
        textView.writingToolsCoordinator.decorationContainerView = decorationContainerView;
    }],
        [UIAction actionWithTitle:@"nil" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        decorationContainerView.hidden = YES;
        textView.writingToolsCoordinator.decorationContainerView = nil;
    }]
    ]];
    
    return menu;
}

- (UIMenu *)setEffectContainerViewMenu {
    UITextView *textView = self.textView;
    UIView *effectContainerView = self.effectContainerView;
    
    UIMenu *menu = [UIMenu menuWithTitle:@"setEffectContainerView:" children:@[
        [UIAction actionWithTitle:@"set" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        effectContainerView.hidden = NO;
        textView.writingToolsCoordinator.effectContainerView = effectContainerView;
    }],
        [UIAction actionWithTitle:@"nil" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        effectContainerView.hidden = YES;
        textView.writingToolsCoordinator.effectContainerView = nil;
    }]
    ]];
    
    return menu;
}

- (UIMenu *)requestedToolsMenu {
    NSArray<NSString *> *allRequestedTools = [NewWritingToolsViewController allRequestedTools];
    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allRequestedTools.count];
    
    UITextView *textView = self.textView;
    
    for (NSString *tool in allRequestedTools) {
        UIAction *action = [UIAction actionWithTitle:tool image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), tool, nil, action.sender);
        }];
        
        [actions addObject:action];
    }
    
    UIMenu *menu = [UIMenu menuWithTitle:@"Request Tool" children:actions];
    [actions release];
    
    return menu;
}

- (UIMenu *)setResultOptionsMenu {
    NSArray<NSNumber *> *allUIWritingToolsResultOptions = [NewWritingToolsViewController allUIWritingToolsResultOptions];
    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allUIWritingToolsResultOptions.count];
    
    UITextView *textView = self.textView;
    
    for (NSNumber *number in allUIWritingToolsResultOptions) {
        UIWritingToolsResultOptions option = (UIWritingToolsResultOptions)number.unsignedIntegerValue;
        BOOL selected = (textView.writingToolsCoordinator.preferredResultOptions & option) == option;
        
        UIAction *action = [UIAction actionWithTitle:[NewWritingToolsViewController stringFromUIWritingToolsResultOption:option] image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIWritingToolsResultOptions newOptions;
            
            if (selected) {
                newOptions = textView.writingToolsCoordinator.preferredResultOptions & ~option;
            } else {
                newOptions = textView.writingToolsCoordinator.preferredResultOptions | option;
            }
            
            textView.writingToolsCoordinator.preferredResultOptions = newOptions;
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

@end
