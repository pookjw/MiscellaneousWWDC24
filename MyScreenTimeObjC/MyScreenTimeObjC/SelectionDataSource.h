//
//  SelectionDataSource.h
//  MyScreenTimeObjC
//
//  Created by Jinwoo Kim on 4/23/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectionDataSource : NSObject
@property (copy, nonatomic, readonly) NSArray<NSData *> *applications;
@property (copy, nonatomic, readonly) NSArray<NSData *> *categories;
@property (copy, nonatomic, readonly) NSArray<NSData *> *webDomains;
@property (copy, nonatomic, readonly) NSArray<NSData *> *untokenizedApplications;
@property (copy, nonatomic, readonly) NSArray<NSData *> *untokenizedCategories;
@property (copy, nonatomic, readonly) NSArray<NSData *> *untokenizedWebDomains;

- (instancetype)initWithNotification:(NSNotification *)notification;
+ (SelectionDataSource * _Nullable)selectionFromSavedData;
- (void)save;
@end

NS_ASSUME_NONNULL_END
