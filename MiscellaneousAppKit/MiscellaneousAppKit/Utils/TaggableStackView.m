//
//  TaggableStackView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/15/25.
//

#import "TaggableStackView.h"

@implementation TaggableStackView
@synthesize tag = _tag;

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _tag = [coder decodeIntegerForKey:@"TaggableStackView_tag"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInteger:self.tag forKey:@"TaggableStackView_tag"];
}

@end
