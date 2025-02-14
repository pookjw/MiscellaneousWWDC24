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
    return @selector(_didTrigger:);
}

+ (BOOL)conformsToProtocol:(Protocol *)protocol {
    BOOL conforms = [super conformsToProtocol:protocol];
    
    if (!conforms) {
        NSLog(@"%@", NSStringFromProtocol(protocol));
    }
    
    return conforms;
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

- (void)_didTrigger:(id)sender {
    _resolver(sender);
}

- (void)setupMenuItem:(NSMenuItem *)menuItem {
    menuItem.target = self;
    menuItem.action = [ActionResolver action];
    menuItem.representedObject = self;
}

- (void)setupControl:(NSControl *)control {
    control.target = self;
    control.action = [ActionResolver action];
    control.objectValue = self;
}

@end
