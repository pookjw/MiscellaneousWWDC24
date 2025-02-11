//
//  MRUIInset.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import <CoreGraphics/CoreGraphics.h>

/*
 +[NSValue mrui_valueWithMRUIInset:]
 -[NSValue mrui_MRUIInsetValue]
 */

struct MRUIInset {
    CGFloat top;
    CGFloat left;
    CGFloat right;
    CGFloat bottom;
};
typedef struct MRUIInset MRUIInset;

static inline MRUIInset MRUIInsetMake(CGFloat top, CGFloat left, CGFloat right, CGFloat bottom) {
    MRUIInset inset;
    inset.top = top;
    inset.left = left;
    inset.right = right;
    inset.bottom = bottom;
    return inset;
}
