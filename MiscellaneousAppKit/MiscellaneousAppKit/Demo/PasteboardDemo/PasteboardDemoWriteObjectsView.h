//
//  PasteboardDemoWriteObjectsView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasteboardDemoWriteObjectsView : NSView
@property (copy, nonatomic, readonly) NSArray<NSString *> *strings;
@end

NS_ASSUME_NONNULL_END
