//
 //  NSString+Category.mm
 //  CamPresentation
 //
 //  Created by Jinwoo Kim on 1/1/25.
 //
 
 #import "NSString+Category.h"
 #import <objc/message.h>
 #import <objc/runtime.h>
 
 namespace cp__NSCFString {
 namespace hasPrefix_ {
 BOOL (*original)(NSString *self, SEL _cmd, NSString *other);
 BOOL custom(NSString *self, SEL _cmd, NSString *other) {
     if ([other isEqualToString:@"com.apple.Compose"]) {
         return YES;
     }
     
     return original(self, _cmd, other);
 }
 void swizzle() {
     Method method = class_getInstanceMethod(objc_lookUpClass("__NSCFString"), sel_registerName("hasPrefix:"));
     original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
     method_setImplementation(method, reinterpret_cast<IMP>(custom));
 }
 }
 }
 
 @implementation NSString (Category)
 
 + (void)load {
     cp__NSCFString::hasPrefix_::swizzle();
 }
 
 @end
