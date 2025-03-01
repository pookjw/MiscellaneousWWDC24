//
//  ConfigurationBaseComponentItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import "ConfigurationBaseComponentItem.h"

@implementation ConfigurationBaseComponentItem

- (void)dealloc {
    [_resolvedValue release];
    [super dealloc];
}

@end
