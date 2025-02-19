//
//  ActionResolver.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import "ActionResolver.h"
#import <objc/runtime.h>

@implementation ActionResolver

+ (void *)_associationKey {
    static void *key = &key;
    return key;
}

+ (SEL)action {
    return @selector(_didTriggerActionResolver:);
}

- (instancetype)initWithResolver:(void (^)(id _Nonnull))resolver {
    if (self = [super init]) {
        _resolver = [resolver copy];
    }
    
    return self;
}

+ (ActionResolver *)resolver:(void (^)(id _Nonnull))resolver {
    return [[[ActionResolver alloc] initWithResolver:resolver] autorelease];
}

- (void)dealloc {
    [_resolver release];
    [super dealloc];
}

- (void)_didTriggerActionResolver:(id)sender {
    _resolver(sender);
}

- (void)setupMenuItem:(NSMenuItem *)menuItem {
    menuItem.target = self;
    menuItem.action = [ActionResolver action];
    
    // NSMenuItem은 복사될 여지가 있기에 Associated Object로 처리하면 안 됨
    menuItem.representedObject = self;
}

- (void)setupControl:(NSControl *)control {
    control.target = self;
    control.action = [ActionResolver action];
    control.objectValue = control;;
    
    // control.objectValue은 NSCopying을 지원해야 함
    assert(objc_getAssociatedObject(control, [ActionResolver _associationKey]) == nil);
    objc_setAssociatedObject(control, [ActionResolver _associationKey], self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
