//
//  ToolBox.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "ToolBox.h"
#include <dlfcn.h>

@implementation ToolBox

+ (void *)_MRUIKit {
    static void *handle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
    });
    return handle;
}

+ (void)MRUISeparateAllViews {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *_symbol = dlsym([ToolBox _MRUIKit], "MRUISeparateAllViews");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    reinterpret_cast<void (*)(void)>(symbol)();
}

+ (void)MRUIDebug {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *_symbol = dlsym([ToolBox _MRUIKit], "MRUIDebug");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    reinterpret_cast<void (*)(void)>(symbol)();
}

+ (void)MRUIDebugVerbose {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *_symbol = dlsym([ToolBox _MRUIKit], "MRUIDebugVerbose");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    reinterpret_cast<void (*)(void)>(symbol)();
}

+ (NSString *)MRUIEntityRecursiveDescription:(void *)entity {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *_symbol = dlsym([ToolBox _MRUIKit], "MRUIEntityRecursiveDescription");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(void *)>(symbol)(entity);
}

@end
