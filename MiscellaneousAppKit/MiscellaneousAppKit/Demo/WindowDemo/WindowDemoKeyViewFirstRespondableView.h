//
//  WindowDemoKeyViewFirstRespondableView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowDemoKeyViewFirstRespondableView : NSView
@property (retain, nonatomic, nullable) NSView *preferredNextValidKeyView;
@property (retain, nonatomic, nullable) NSView *preferredPreviousValidKeyView;
@end

NS_ASSUME_NONNULL_END
