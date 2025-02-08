//
//  MRUISize3D.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import "MRUISize3D.h"
#include <dlfcn.h>

NSString * mui_NSStringFromMRUISize3D(MRUISize3D size) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUISize3D");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(MRUISize3D)>(symbol)(size);
}
