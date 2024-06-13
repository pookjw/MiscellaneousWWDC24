//
//  ListEnvironmentContentConfiguration.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "ListEnvironmentContentConfiguration.h"

__attribute__((objc_direct_members))
@interface _ListEnvironmentContentView : UIView <UIContentView>
@property (copy, nonatomic) ListEnvironmentContentConfiguration *contentConfiguration;
@property (retain, readonly, nonatomic) UILabel *label;
@end

@implementation _ListEnvironmentContentView
@synthesize label = _label;

- (instancetype)initWithContentConfiguration:(ListEnvironmentContentConfiguration *)contentConfiguration __attribute__((objc_direct)) {
    if (self = [super initWithFrame:CGRectNull]) {
        UILabel *label = self.label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        [NSLayoutConstraint activateConstraints:@[
            [label.topAnchor constraintEqualToAnchor:self.topAnchor],
            [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        
        self.contentConfiguration = contentConfiguration;
    }
    
    return self;
}

- (void)dealloc {
    [_contentConfiguration release];
    [_label release];
    [super dealloc];
}

- (id<UIContentConfiguration>)configuration {
    return self.contentConfiguration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    self.contentConfiguration = configuration;
}

- (void)setContentConfiguration:(ListEnvironmentContentConfiguration *)contentConfiguration {
    self.label.text = contentConfiguration.indexPath.description;
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:ListEnvironmentContentConfiguration.class];
}

- (UILabel *)label {
    if (auto label = _label) return label;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    
    _label = [label retain];
    return [label autorelease];
}

@end


@implementation ListEnvironmentContentConfiguration

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath {
    if (self = [super init]) {
        _indexPath = [indexPath copy];
    }
    
    return self;
}

- (void)dealloc {
    [_indexPath release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    decltype(self) copy = [self.class new];
    
    if (copy) {
        copy->_indexPath = [_indexPath copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView { 
    return [[[_ListEnvironmentContentView alloc] initWithContentConfiguration:self] autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    switch (state.traitCollection.listEnvironment) {
        case UIListEnvironmentInsetGrouped:
            NSLog(@"Inset Grouped!");
            break;
        case UIListEnvironmentGrouped:
            NSLog(@"Grouped!");
            break;
        default:
            break;
    }
    
    return self;
}

@end
