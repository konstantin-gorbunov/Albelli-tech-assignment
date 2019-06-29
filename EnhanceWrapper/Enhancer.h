//
//  Enhancer.h
//  Enhancer
//
//  Created by Kostiantyn Gorbunov on 29/06/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The function returns the input string reverted. So for example, "abc" becomes "cba".
 
 - Parameter inputString: ASCII string, terminated by a null-character.
 
 - Throws: `NSError`
 if something is wrong.
 
 Error code:    1 = max_length is too small to hold the result
                2 = invalid arguments
 
 - Returns: A new reverted string.
 **/

@protocol EnhancerProtocol <NSObject>

- (nullable NSString *)executeWithInputString:(nonnull NSString *)inputStr error:(NSError *_Nullable * _Nullable)error;

@end


@interface Enhancer : NSObject <EnhancerProtocol>

@end
