//
//  SelectionDataSource.mm
//  MyScreenTimeObjC
//
//  Created by Jinwoo Kim on 4/23/25.
//

#import "SelectionDataSource.h"
#import "Swizzler.h"

@implementation SelectionDataSource

- (instancetype)init {
    self = [self _initWithApplications:@[] categories:@[] webDomains:@[] untokenizedApplications:@[] untokenizedCategories:@[] untokenizedWebDomains:@[]];
    return self;
}

- (instancetype)initWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    self = [self _initWithApplications:userInfo[MT_ApplicationsKey] categories:userInfo[MT_CategoriesKey] webDomains:userInfo[MT_WebDomainsKey] untokenizedApplications:userInfo[MT_UntokenizedApplicationsKey] untokenizedCategories:userInfo[MT_UntokenizedCategoriesKey] untokenizedWebDomains:userInfo[MT_UntokenizedWebDomainsKey]];
    
    return self;
}

- (instancetype)_initWithApplications:(NSArray<NSData *> *)applications categories:(NSArray<NSData *> *)categories webDomains:(NSArray<NSData *> *)webDomains untokenizedApplications:(NSArray<NSData *> *)untokenizedApplications untokenizedCategories:(NSArray<NSData *> *)untokenizedCategories untokenizedWebDomains:(NSArray<NSData *> *)untokenizedWebDomains {
    if (self = [super init]) {
        _applications = [applications copy];
        _categories = [categories copy];
        _webDomains = [webDomains copy];
        _untokenizedApplications = [untokenizedApplications copy];
        _untokenizedCategories = [untokenizedCategories copy];
        _untokenizedWebDomains = [untokenizedWebDomains copy];
    }
    
    return self;
}

+ (SelectionDataSource *)selectionFromSavedData {
    NSDictionary * _Nullable dictionary = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"selections"];
    if (dictionary == nil) return nil;
    
    SelectionDataSource *result = [[SelectionDataSource alloc] _initWithApplications:dictionary[@"applications"] categories:dictionary[@"categories"] webDomains:dictionary[@"webDomains"] untokenizedApplications:dictionary[@"untokenizedApplications"] untokenizedCategories:dictionary[@"untokenizedCategories"] untokenizedWebDomains:dictionary[@"untokenizedWebDomains"]];
    
    return [result autorelease];
}

- (void)dealloc {
    [_applications release];
    [_categories release];
    [_webDomains release];
    [_untokenizedApplications release];
    [_untokenizedCategories release];
    [_untokenizedWebDomains release];
    [super dealloc];
}

- (void)save {
    [NSUserDefaults.standardUserDefaults setValue:@{
        @"applications": _applications,
        @"categories": _categories,
        @"webDomains": _webDomains,
        @"untokenizedApplications": _untokenizedApplications,
        @"untokenizedCategories": _untokenizedCategories,
        @"untokenizedWebDomains": _untokenizedWebDomains,
    }
                                           forKey:@"selections"];
}

@end
