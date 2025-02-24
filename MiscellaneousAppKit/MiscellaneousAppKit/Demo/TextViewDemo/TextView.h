//
//  TextView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextView : NSTextView
@property (assign, nonatomic, getter=isSmartReplyEnabled, setter=setSmartReplayEnabled:) BOOL smartReplyEnabled;
@end

NS_ASSUME_NONNULL_END
