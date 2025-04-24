//
//  ShieldConfigurationExtension.mm
//  ShieldConfigurationObjC
//
//  Created by Jinwoo Kim on 4/25/25.
//

#import "ShieldConfigurationExtension.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

/*
 MOShieldConfiguration
 ManagedSettingsUI.ShieldConfigurationExtensionContext
 */

@interface ShieldConfigurationExtension ()
- (void)fetchConfigurationDataForApplication:(NSString *)application tokenData:(NSData *)tokenData localizedDisplayName:(NSString * _Nullable)localizedDisplayName replyHandler:(void (^)(NSData * _Nullable data, NSError * _Nullable error))replyHandler;
@end

namespace sco_ConfigurationContext {
    
    namespace fetchConfigurationDataForApplication_tokenData_localizedDisplayName_replyHandler_ {
        void (*original)(id self, SEL _cmd, NSString *application, NSData *tokenData, NSString * _Nullable localizedDisplayName, void (^replyHandler)(NSData * _Nullable data, NSError * _Nullable error));
        void custom(id self, SEL _cmd, id application, NSData *tokenData, NSString * _Nullable localizedDisplayName, void (^replyHandler)(NSData * _Nullable data, NSError * _Nullable error)) {
            ShieldConfigurationExtension *_principalObject = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_principalObject"));
            assert([_principalObject isKindOfClass:[ShieldConfigurationExtension class]]);
            [_principalObject fetchConfigurationDataForApplication:application tokenData:tokenData localizedDisplayName:localizedDisplayName replyHandler:replyHandler];
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("_TtC17ManagedSettingsUI35ShieldConfigurationExtensionContext"), sel_registerName("fetchConfigurationDataForApplication:tokenData:localizedDisplayName:replyHandler:"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
    
    namespace fetchConfigurationDataForApplication_localizedApplicationDisplayName_categoryTokenData_localizedCategoryDisplayName_replyHandler_ {
        // TODO
    }
    
    namespace fetchConfigurationDataForWebDomain_tokenData_replyHandler_ {
        // TODO
    }
    
    namespace fetchConfigurationDataForWebDomain_categoryTokenData_localizedDisplayName_replyHandler_ {
        // TODO
    }
    
}

@implementation ShieldConfigurationExtension

+ (void)load {
    using namespace sco_ConfigurationContext;
    fetchConfigurationDataForApplication_tokenData_localizedDisplayName_replyHandler_::swizzle();
}

- (void)fetchConfigurationDataForApplication:(NSString *)application tokenData:(NSData *)tokenData localizedDisplayName:(NSString * _Nullable)localizedDisplayName replyHandler:(void (^)(NSData * _Nullable data, NSError * _Nullable error))replyHandler {
    NSError * _Nullable error = nil;
    NSData *systemPinkColorData = [NSKeyedArchiver archivedDataWithRootObject:UIColor.systemPinkColor requiringSecureCoding:YES error:&error];
    assert(error == nil);
    NSData *systemGreenColor = [NSKeyedArchiver archivedDataWithRootObject:UIColor.systemGreenColor requiringSecureCoding:YES error:&error];
    assert(error == nil);
    NSData *systemOrangeColor = [NSKeyedArchiver archivedDataWithRootObject:UIColor.systemOrangeColor requiringSecureCoding:YES error:&error];
    assert(error == nil);
    NSData *systemCyanColor = [NSKeyedArchiver archivedDataWithRootObject:UIColor.systemCyanColor requiringSecureCoding:YES error:&error];
    assert(error == nil);
    NSData *systemGrayColor = [NSKeyedArchiver archivedDataWithRootObject:UIColor.systemGrayColor requiringSecureCoding:YES error:&error];
    assert(error == nil);
    NSData *systemIndigoColor = [NSKeyedArchiver archivedDataWithRootObject:UIColor.systemIndigoColor requiringSecureCoding:YES error:&error];
    assert(error == nil);
    
    NSData *darkStyleData = [NSKeyedArchiver archivedDataWithRootObject:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] requiringSecureCoding:YES error:&error];
    assert(error == nil);
    
    NSData *appleIntelligenceData = UIImagePNGRepresentation([[UIImage systemImageNamed:@"apple.intelligence"] imageWithTintColor:UIColor.whiteColor renderingMode:UIImageRenderingModeAlwaysTemplate]);
    
    id title = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("MOShieldLabel") alloc], sel_registerName("initWithText:colorData:"), @"Title", systemPinkColorData);
    id subtitle = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("MOShieldLabel") alloc], sel_registerName("initWithText:colorData:"), @"Subiitle", systemGreenColor);
    id primaryButtonLabel = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("MOShieldLabel") alloc], sel_registerName("initWithText:colorData:"), @"Primary Button", systemOrangeColor);
    id secondaryButtonLabel = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("MOShieldLabel") alloc], sel_registerName("initWithText:colorData:"), @"Secondary Button", systemCyanColor);
    
    id configuration = reinterpret_cast<id (*)(id, SEL, id, id, id, id, id, id, id, id)>(objc_msgSend)([objc_lookUpClass("MOShieldConfiguration") alloc], sel_registerName("initWithBackgroundColorData:backgroundEffectData:iconData:title:subtitle:primaryButtonLabel:primaryButtonColorData:secondaryButtonLabel:"), nil, darkStyleData, appleIntelligenceData, title, subtitle, primaryButtonLabel, systemGrayColor, secondaryButtonLabel);
    [title release];
    [subtitle release];
    [primaryButtonLabel release];
    [secondaryButtonLabel release];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:configuration requiringSecureCoding:YES error:&error];
    assert(error == nil);
    [configuration release];
    replyHandler(data, error);
}

@end
