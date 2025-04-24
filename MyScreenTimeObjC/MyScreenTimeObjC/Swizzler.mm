//
//  Swizzler.m
//  MyScreenTimeObjC
//
//  Created by Jinwoo Kim on 4/23/25.
//

#import "Swizzler.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

NSNotificationName const MT_ActivityPickerRemoteViewControllerDidCancelNotificationName = @"MT_ActivityPickerRemoteViewControllerDidCancelNotificationName";
NSNotificationName const MT_ActivityPickerRemoteViewControllerDidFinishSelectionNotificationName = @"MT_ActivityPickerRemoteViewControllerDidFinishSelectionNotificationName";
NSNotificationName const MT_ActivityPickerRemoteViewControllerDidChangeSelectionNotificationName = @"MT_ActivityPickerRemoteViewControllerDidChangeSelectionNotificationName";
NSString * const MT_ApplicationsKey = @"applications";
NSString * const MT_CategoriesKey = @"categories";
NSString * const MT_WebDomainsKey = @"webDomains";
NSString * const MT_UntokenizedApplicationsKey = @"untokenizedApplications";
NSString * const MT_UntokenizedCategoriesKey = @"untokenizedCategories";
NSString * const MT_UntokenizedWebDomainsKey = @"untokenizedWebDomains";

namespace mt_ActivityPickerRemoteViewController {
namespace didCancel {
void (*original)(__kindof UIViewController *self, SEL _cmd);
void custom(__kindof UIViewController *self, SEL _cmd) {
    original(self, _cmd);
    [NSNotificationCenter.defaultCenter postNotificationName:MT_ActivityPickerRemoteViewControllerDidCancelNotificationName object:self];
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("ActivityPickerRemoteViewController"), sel_registerName("didCancel"));
    if (method == NULL) return;
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace didFinishSelection {
void (*original)(__kindof UIViewController *self, SEL _cmd);
void custom(__kindof UIViewController *self, SEL _cmd) {
    original(self, _cmd);
    [NSNotificationCenter.defaultCenter postNotificationName:MT_ActivityPickerRemoteViewControllerDidFinishSelectionNotificationName object:self];
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("ActivityPickerRemoteViewController"), sel_registerName("didFinishSelection"));
    if (method == NULL) return;
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace didSelectWithApplications_categories_webDomains_untokenizedApplications_untokenizedCategories_untokenizedWebDomains_ {
void (*original)(__kindof UIViewController *self, SEL _cmd, NSArray<NSData *> *applications, NSArray<NSData *> *categories, NSArray<NSData *> *webDomains, NSArray<NSData *> *untokenizedApplications, NSArray<NSData *> *untokenizedCategories, NSArray<NSData *> *untokenizedWebDomains);
void custom(__kindof UIViewController *self, SEL _cmd, NSArray<NSData *> *applications, NSArray<NSData *> *categories, NSArray<NSData *> *webDomains, NSArray<NSData *> *untokenizedApplications, NSArray<NSData *> *untokenizedCategories, NSArray<NSData *> *untokenizedWebDomains) {
    original(self, _cmd, applications, categories, webDomains, untokenizedApplications, untokenizedCategories, untokenizedWebDomains);
    [NSNotificationCenter.defaultCenter postNotificationName:MT_ActivityPickerRemoteViewControllerDidChangeSelectionNotificationName object:self userInfo:@{
        MT_ApplicationsKey: applications,
        MT_CategoriesKey: categories,
        MT_WebDomainsKey: webDomains,
        MT_UntokenizedApplicationsKey: untokenizedApplications,
        MT_UntokenizedCategoriesKey: untokenizedCategories,
        MT_UntokenizedWebDomainsKey: untokenizedWebDomains
    }];
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("ActivityPickerRemoteViewController"), sel_registerName("didSelectWithApplications:categories:webDomains:untokenizedApplications:untokenizedCategories:untokenizedWebDomains:"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

@interface Swizzler : NSObject
@end

@implementation Swizzler

+ (void)load {
    using namespace mt_ActivityPickerRemoteViewController;
    didCancel::swizzle();
    didFinishSelection::swizzle();
    didSelectWithApplications_categories_webDomains_untokenizedApplications_untokenizedCategories_untokenizedWebDomains_::swizzle();
}

@end
