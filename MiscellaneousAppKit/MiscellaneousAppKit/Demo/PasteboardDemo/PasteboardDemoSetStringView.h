//
//  PasteboardDemoSetStringView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasteboardDemoSetStringView : NSView
@property (copy, nonatomic, readonly) NSPasteboardType pasteboardType;
@property (copy, nonatomic, readonly) NSString *string;
@end

NS_ASSUME_NONNULL_END
