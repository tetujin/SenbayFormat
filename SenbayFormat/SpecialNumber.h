//
//  SpecialNumber.h
//  SpecialNumber
//
//  Created by Yuuki Nishiyama on 2014/12/07.
//  Copyright (c) 2014 Yuuki NISHIYAMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialNumber : NSObject


- (NSString *) encodeBaseX:(int)shinsu
                 longValue:(long)value;

- (NSString *) encodeBaseX:(int)shinsu
               doubleValue:(double)value;

- (long) decodeLongBaseX:(int)shinsu
                   value:(NSString *)valueStr;

- (double) decodeDoubleBaseX:(int)shinsu
                       value:(NSString *)valueStr;



- (void) initTable;

@end
