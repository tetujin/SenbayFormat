//
//  SensorDataManager.h
//  SpecialNumber
//
//  Created by Yuuki Nishiyama on 2014/12/27.
//  Copyright (c) 2014 Yuuki NISHIYAMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SensorDataManager : NSObject
{
    NSMutableDictionary *map;
}

- (void) setSensorDataString:(NSString *)str;

- (NSString *) getDataByKey: (NSString *)key;

@end
