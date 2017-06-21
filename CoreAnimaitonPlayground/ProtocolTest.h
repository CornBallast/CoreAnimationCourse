//
//  ProtocolTest.h
//  CoreAnimaitonPlayground
//
//  Created by ys on 2017/6/2.
//  Copyright © 2017年 ys. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol protocolTest

@property NSString* protocolName;

-(void)setProtocolName:(NSString *)protocolName;

-(void)protocalTestLog;

@end


@interface ProtocolTest : NSObject

@end
