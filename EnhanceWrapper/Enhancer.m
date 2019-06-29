//
//  Enhancer.m
//  EnhanceWrapper
//
//  Created by Kostiantyn Gorbunov on 29/06/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

#import "Enhancer.h"
#include "GPEnhance.h"

static NSString *kEnhancerErrorDomain = @"EnhancerErrorDomain";

@interface Enhancer () <EnhancerProtocol>

@property(unsafe_unretained, assign, atomic) GPEnhancer *enhancer;

@end

@implementation Enhancer

- (instancetype)init {
    if (self = [super init]) {
        _enhancer = gp_enhance_create();
    }
    return self;
}

- (void)dealloc {
    gp_enhance_dispose(self.enhancer);
}

- (nullable NSString *)executeWithInputString:(nonnull NSString *)inputStr error:(NSError ** __nullable)error {
    NSString *resultStr;
    NSUInteger length = inputStr.length;
    const char* input = [inputStr cStringUsingEncoding:NSASCIIStringEncoding];
    char output[length];
    
    NSInteger result = gp_enhance_execute(self.enhancer, input, output, length);
    
    if (result == 0) {
        resultStr = [NSString stringWithUTF8String:output];
    } else if (error) {
        *error = [NSError errorWithDomain:kEnhancerErrorDomain code:result userInfo:nil];
    }
    return resultStr;
}

@end
