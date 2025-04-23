//
//  NSObject+Foundation_IvarDescription.h
//  IvarDescription
//
//  Created by Jinwoo Kim on 1/17/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Foundation_IvarDescription)
- (NSString *)_fd_shortMethodDescription;
- (NSString *)_fd_methodDescription;
- (NSString *)_fd__methodDescriptionForClass:(Class)arg1;
- (NSString *)_fd_propertyDescription;
- (NSString *)_fd__propertyDescriptionForClass:(Class)arg1;
- (NSString *)_fd_ivarDescription;
- (NSString *)_fd__ivarDescriptionForClass:(Class)arg1;
- (NSString *)_fd__ivarDescriptionForClass:(Class)arg1 resolveValue:(BOOL)resolveValue;
- (NSString *)_fd__protocolDescriptionForProtocol:(Protocol *)arg1;
@end

NS_ASSUME_NONNULL_END
