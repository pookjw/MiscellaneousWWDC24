//
//  PasteboardDemoDetectView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PasteboardDemoDetectType) {
    PasteboardDemoDetectTypeMetadata,
    PasteboardDemoDetectTypePatterns,
    PasteboardDemoDetectTypeValues
};

@interface PasteboardDemoDetectView : NSView
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect pasteboard:(NSPasteboard *)pasteboard type:(PasteboardDemoDetectType)type;
@property (nonatomic, readonly) NSInteger selectedPasteboardItemIndex;
@property (nonatomic, readonly) NSSet<NSString *> *selectedTypes;
@end

NS_ASSUME_NONNULL_END
