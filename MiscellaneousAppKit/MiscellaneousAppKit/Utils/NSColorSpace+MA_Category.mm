//
//  NSColorSpace+MA_Category.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import "NSColorSpace+MA_Category.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <ranges>
#include <numeric>

NSColorSpaceModel * allNSColorSpaceModels(NSUInteger * _Nullable count) {
    static NSColorSpaceModel allModels[] = {
        NSColorSpaceModelUnknown,
        NSColorSpaceModelGray,
        NSColorSpaceModelRGB,
        NSColorSpaceModelCMYK,
        NSColorSpaceModelLAB,
        NSColorSpaceModelDeviceN,
        NSColorSpaceModelIndexed,
        NSColorSpaceModelPatterned
    };
    
    if (count != NULL) {
        *count = sizeof(allModels) / sizeof(NSColorSpaceModel);
    }
    
    return allModels;
}

@implementation NSColorSpace (MA_Category)

+ (NSArray<NSColorSpace *> *)ma_allColorSpaces {
    NSMutableArray<NSColorSpace *> *results = [NSMutableArray new];
    
    //
    
    unsigned int methodsCount;
    Method *methods = class_copyMethodList(object_getClass(self), &methodsCount);
    
    for (Method *methodPtr : std::views::iota(methods, methods + methodsCount)) {
        Method method = *methodPtr;
        SEL sel = method_getName(method);
        NSString *selString = [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
        
        if (![selString hasSuffix:@"ColorSpace"]) continue;
        
        char returnType[256];
        method_getReturnType(method, returnType, 256);
        
        if (strcmp(returnType, @encode(id)) != 0) continue;
        
        unsigned int numberOfArguments = method_getNumberOfArguments(method);
        if (numberOfArguments != 2) continue;
        
        NSColorSpace *colorSpace = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(self, sel);
        if (![colorSpace isKindOfClass:self]) continue;
        
        [results addObject:colorSpace];
    }
    
    free(methods);
    
    //
    
    NSUInteger modelsCount;
    NSColorSpaceModel *allModels = allNSColorSpaceModels(&modelsCount);
    
    for (NSColorSpaceModel *modelPtr : std::views::iota(allModels, allModels + modelsCount)) {
        NSArray<NSColorSpace *> *availableColorSpaces = [NSColorSpace availableColorSpacesWithModel:*modelPtr];
        
        for (NSColorSpace *_colorSpace in availableColorSpaces) {
            if (![results containsObject:_colorSpace]) {
                [results addObject:_colorSpace];
            }
        }
    }
    
    //
    
    return [results autorelease];
}

@end
