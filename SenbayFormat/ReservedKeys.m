//
//  ReservedKeys.m
//  SpecialNumber
//
//  Created by Yuuki Nishiyama on 2014/12/27.
//  Copyright (c) 2014 Yuuki NISHIYAMA. All rights reserved.
//

#import "ReservedKeys.h"

@implementation ReservedKeys

- (instancetype)init
{
    self = [super init];
    if (self) {
        reservedKeyValue = [NSMutableDictionary dictionary];
        reservedValueKey = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 * set value and
 */
- (void)setKeyValue:(NSString *)key value:(NSString *)value
{
    reservedKeyValue[key] = value;
    reservedValueKey[value] = key;
}


/**
 *
 */
-(NSString *)getValueByKey:(NSString *)key
{
//    NSLog(@"%@", key);
    return reservedKeyValue[key];
}


/**
 *
 */
- (NSString *)getKeyByValue:(NSString *)value
{
    return reservedValueKey[value];
}


@end
