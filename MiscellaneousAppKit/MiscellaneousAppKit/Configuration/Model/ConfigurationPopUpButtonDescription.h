//
//  ConfigurationPopUpButtonDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

NS_REFINED_FOR_SWIFT
@interface ConfigurationPopUpButtonDescription : NSObject <NSCopying>
@property (copy, nonatomic, readonly) NSArray<NSString *> *titles;
@property (copy, nonatomic, readonly) NSArray<NSString *> *selectedTitles;
@property (copy, nonatomic, readonly, nullable) NSString *selectedDisplayTitle;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (ConfigurationPopUpButtonDescription *)descriptionWithTitles:(NSArray<NSString *> *)titles selectedTitles:(NSArray<NSString *> *)selectedTitles selectedDisplayTitle:(NSString * _Nullable)selectedDisplayTitle;
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles selectedTitles:(NSArray<NSString *> *)selectedTitles selectedDisplayTitle:(NSString * _Nullable)selectedDisplayTitle;
@end

NS_ASSUME_NONNULL_END
