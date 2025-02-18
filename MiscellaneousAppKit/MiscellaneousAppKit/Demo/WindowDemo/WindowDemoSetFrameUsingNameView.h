//
//  WindowDemoSetFrameUsingNameView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/18/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowDemoSetFrameUsingNameView : NSView
@property (copy, nonatomic) NSWindowFrameAutosaveName autosaveName;
@property (assign, nonatomic) BOOL force;
@property (nonatomic, readonly, nullable) NSWindowPersistableFrameDescriptor frameDescriptorForAutosaveName;
@end

NS_ASSUME_NONNULL_END
