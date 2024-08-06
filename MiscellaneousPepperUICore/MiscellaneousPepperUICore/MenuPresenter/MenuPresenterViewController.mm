//
//  MenuPresenterViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

#import "MenuPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation MenuPresenterViewController

+ (void)load {
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_MenuPresenterViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
//        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICMenuViewControllerDelegate")));
        
        //
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id) {
        [weakSelf presetViewController];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)presetViewController __attribute__((objc_direct)) {
    NSMutableArray *menuElements = [[NSMutableArray alloc] initWithCapacity:100];
    
    for (NSUInteger index = 0; index < 100; index++) {
        NSString *title = [NSString stringWithFormat:@"Button %ld", index];
        UIImage *image = [UIImage systemImageNamed:@"paperplane.fill"];
        
        NSString * _Nullable detail;
        if (index % 2 == 0) {
            detail = @"Detail";
        } else {
            detail = nil;
        }
        
        // style
        //  - 0 : Leading
        //  - 1 : Center
        //
        // state : ?
        id menuAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), title, detail, image, @(index).stringValue, 0, 0, 0, ^(id action) {
            NSLog(@"%@", action);
        });
        
        [menuElements addObject:menuAction];
        [menuAction release];
    }
    
    id menuViewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuViewController") alloc], sel_registerName("initWithMenuElements:"), menuElements);
    [menuElements release];
    
    // 안 되는듯?
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(menuViewController, sel_registerName("setDelegate:"), self);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(menuViewController, sel_registerName("navigationItem"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), @"Navigation Title");
    
    //
    
    id puicSwitch = [objc_lookUpClass("PUICSwitch") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(puicSwitch, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL, BOOL)>(objc_msgSend)(puicSwitch, sel_registerName("setOn:animated:"), YES, NO);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(menuViewController, sel_registerName("setGlobalHeaderView:"), puicSwitch);
    [puicSwitch release];
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), menuViewController, YES, nil);
    
    [menuViewController release];
}

@end
