//
//  Swizzler.h
//  Locus
//
//  Created by barry alexander on 2/11/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Swizzler : NSObject

- (void)swizzleClassMethod:(Class)target_class selector:(SEL)selector swizzleClass:(Class)swizzleClass;
- (void)deswizzle;

@end
