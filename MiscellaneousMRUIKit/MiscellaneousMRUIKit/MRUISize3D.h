//
//  MRUISize3D.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import <CoreGraphics/CoreGraphics.h>

/*
 +[NSValue valueWithMRUISize3D:]
 -[NSValue MRUISize3DValue]
 */

struct MRUISize3D {
    CGFloat width;
    CGFloat height;
    CGFloat depth;
};
typedef struct MRUISize3D MRUISize3D;

static inline MRUISize3D MRUISize3DMake(CGFloat width, CGFloat height, CGFloat depth) {
    MRUISize3D size3D;
    size3D.width = width;
    size3D.height = height;
    size3D.depth = depth;
    return size3D;
}

CG_EXTERN NSString *mui_NSStringFromMRUISize3D(MRUISize3D);
