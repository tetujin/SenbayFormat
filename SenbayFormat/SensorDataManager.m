//
//  SensorDataManager.m
//  SpecialNumber
//
//  Created by Yuuki Nishiyama on 2014/12/27.
//  Copyright (c) 2014 Yuuki NISHIYAMA. All rights reserved.
//

#import "SensorDataManager.h"

@implementation SensorDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        map = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)setSensorDataString:(NSString *)str
{
    [map removeAllObjects];
    NSArray* array = [str componentsSeparatedByString:@","];
    for (int i=0; i<[array count]; i++) {
        NSArray* contents = [[array objectAtIndex:i] componentsSeparatedByString:@":"];
        if([contents count] > 1){
            NSString* key = [contents objectAtIndex:0];
            NSString* value = [contents objectAtIndex:1];
            if([[value substringToIndex:1] isEqualToString:@"'"]){
                NSMutableString *mvalue = [[NSMutableString alloc] initWithString:value.copy];
                [mvalue deleteCharactersInRange:NSMakeRange(0, 1)];
                [mvalue deleteCharactersInRange:NSMakeRange([mvalue length]-1, 1)];
                value = mvalue;
            }
            map[key] = value;
        }else{
            NSLog(@"error");
        }
    }
}


- (NSString *)getDataByKey:(NSString *)key
{
    NSString* value = map[key];
    if(value!=nil){
        return map[key];
    }else{
        return @"";
    }
}

@end
