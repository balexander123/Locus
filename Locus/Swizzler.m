//
//  Swizzler.m
//  Locus
//
//  Created by barry alexander on 2/11/13.
//  Copyright (c) 2013 barry alexander. All rights reserved.
//

#import "Swizzler.h"

@implementation Swizzler

Method originalMethod = nil;
Method swizzleMethod = nil;

/**
 Swaps the implementation of an existing class method with the corresponding method in the swizzleClass.
 */
- (void)swizzleClassMethod:(Class)targetClass selector:(SEL)selector swizzleClass:(Class)swizzleClass
{
	originalMethod = class_getClassMethod(targetClass, selector); // save the oringinal implementation so it can be restored
	swizzleMethod = class_getClassMethod(swizzleClass, selector); // save the replacement method
	method_exchangeImplementations(originalMethod, swizzleMethod); // perform the swap, replacing the original with the swizzle method implementation.
}

/**
 Restores the implementation of an existing class method with its original implementation.
 */
- (void)deswizzle
{
	method_exchangeImplementations(swizzleMethod, originalMethod); // perform the swap, replacing the previously swizzled method with the original implementation.
	swizzleMethod = nil;
	originalMethod = nil;
}

@end
