//
//  TokenContentConfiguration.mm
//  MyScreenTimeObjC
//
//  Created by Jinwoo Kim on 4/26/25.
//

#import "TokenContentConfiguration.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TokenContentConfiguration ()
@property (copy, nonatomic, readonly, getter=_applicationToken) NSData *applicationToken;
@property (assign, nonatomic, readonly, getter=_tokenType) NSInteger tokenType;
@end

@interface _TokenContentView : UIView <UIContentView>
@end

@implementation TokenContentConfiguration

- (instancetype)initWithApplicationToken:(NSData *)applicationToken tokenType:(NSInteger)tokenType {
    if (self = [super init]) {
        _applicationToken = [applicationToken copy];
        _tokenType = tokenType;
    }
    
    return self;
}

- (void)dealloc {
    [_applicationToken release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    auto casted = static_cast<TokenContentConfiguration *>(other);
    return [_applicationToken isEqualToData:casted->_applicationToken];
}

- (NSUInteger)hash {
    return _applicationToken.hash;
}

- (__kindof UIView<UIContentView> *)makeContentView {
    _TokenContentView *contentView = [[_TokenContentView alloc] initWithFrame:CGRectNull];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end

@interface _TokenContentView ()
@property (retain, nonatomic, readonly, getter=_iconSlotView) __kindof UIView *iconSlotView;
@property (retain, nonatomic, readonly, getter=_displayNameSlotView) __kindof UIView *displayNameSlotView;
@property (retain, nonatomic, readonly, getter=_stackView) UIStackView *stackView;
@property (retain, nonatomic, readonly, getter=_familyControlsConnection) NSXPCConnection *familyControlsConnection;
@property (nonatomic, readonly, nullable, getter=_ownConfiguration) TokenContentConfiguration *ownConfiguration;
@end

@implementation _TokenContentView
@synthesize configuration = _configuration;
@synthesize iconSlotView = _iconSlotView;
@synthesize displayNameSlotView = _displayNameSlotView;
@synthesize stackView = _stackView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _familyControlsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.FamilyControlsAgent", NSXPCConnectionPrivileged);
        NSXPCInterface *remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP14FamilyControls19FamilyControlsAgent_")];
        [remoteObjectInterface setClasses:[NSSet setWithObject:objc_lookUpClass("UISSlotStyle")] forSelector:sel_registerName("getRemoteContentForActivitySlotWithSlotID:slotStyle:slotType:tokenToPresent:tokenType::") argumentIndex:1 ofReply:NO];
        [remoteObjectInterface setClasses:[NSSet setWithObject:objc_lookUpClass("UISSlotRemoteContent")] forSelector:sel_registerName("getRemoteContentForActivitySlotWithSlotID:slotStyle:slotType:tokenToPresent:tokenType::") argumentIndex:0 ofReply:YES];
        _familyControlsConnection.remoteObjectInterface = remoteObjectInterface;
        _familyControlsConnection.interruptionHandler = ^{
            
        };
        [_familyControlsConnection resume];
        
        [self addSubview:self.stackView];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), self.stackView);
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_familyControlsConnection invalidate];
    [_familyControlsConnection release];
    [_iconSlotView release];
    [_displayNameSlotView release];
    [super dealloc];
}

- (__kindof UIView *)_iconSlotView {
    if (auto iconSlotView = _iconSlotView) return iconSlotView;
    
    __kindof UIView *iconSlotView = [objc_lookUpClass("_UISlotView") new];
    
    NSXPCConnection *familyControlsConnection = _familyControlsConnection;
    __weak auto weakSelf = self;
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(iconSlotView, sel_registerName("_setSlotAnyContentProvider:"), ^(NSInteger contextId, id slotStyle, BOOL (^contentHandler)(id content)) {
        TokenContentConfiguration *configuration = weakSelf.ownConfiguration;
        if (configuration == nil) {
            contentHandler(nil);
            return;
        }
        
        reinterpret_cast<void (*)(id, SEL, NSInteger, id, NSInteger, id, NSInteger, id)>(objc_msgSend)(familyControlsConnection.remoteObjectProxy, sel_registerName("getRemoteContentForActivitySlotWithSlotID:slotStyle:slotType:tokenToPresent:tokenType::"), contextId, slotStyle, 0, configuration.applicationToken, configuration.tokenType, ^(id _Nullable content, NSError * _Nullable error) {
//            assert(error == nil);
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    contentHandler(nil);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([configuration isEqual:weakSelf.configuration]) {
                    contentHandler(content);
                } else {
                    contentHandler(nil);
                }
                [weakSelf invalidateIntrinsicContentSize];
            });
        });
    });
    
    _iconSlotView = iconSlotView;
    return iconSlotView;
}

- (__kindof UIView *)_displayNameSlotView {
    if (auto displayNameSlotView = _displayNameSlotView) return displayNameSlotView;
    
    __kindof UIView *displayNameSlotView = [objc_lookUpClass("_UISlotView") new];
    
    NSXPCConnection *familyControlsConnection = _familyControlsConnection;
    __weak auto weakSelf = self;
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(displayNameSlotView, sel_registerName("_setSlotAnyContentProvider:"), ^(NSInteger contextId, id slotStyle, BOOL (^contentHandler)(id content)) {
        TokenContentConfiguration *configuration = weakSelf.ownConfiguration;
        if (configuration == nil) {
            contentHandler(nil);
            return;
        }
        
        reinterpret_cast<void (*)(id, SEL, NSInteger, id, NSInteger, id, NSInteger, id)>(objc_msgSend)(familyControlsConnection.remoteObjectProxy, sel_registerName("getRemoteContentForActivitySlotWithSlotID:slotStyle:slotType:tokenToPresent:tokenType::"), contextId, slotStyle, 1, configuration.applicationToken, configuration.tokenType, ^(id _Nullable content, NSError * _Nullable error) {
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    contentHandler(nil);
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([configuration isEqual:weakSelf.configuration]) {
                    contentHandler(content);
                } else {
                    contentHandler(nil);
                }
                [weakSelf invalidateIntrinsicContentSize];
            });
        });
    });
    
    _displayNameSlotView = displayNameSlotView;
    return displayNameSlotView;
}

- (UIStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconSlotView, self.displayNameSlotView]];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = stackView;
    return stackView;
}

- (TokenContentConfiguration *)_ownConfiguration {
    return static_cast<TokenContentConfiguration *>(self.configuration);
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:[TokenContentConfiguration class]];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [_configuration release];
    _configuration = [configuration copyWithZone:NULL];
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.iconSlotView, sel_registerName("_updateContent"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.displayNameSlotView, sel_registerName("_updateContent"));
}

@end
