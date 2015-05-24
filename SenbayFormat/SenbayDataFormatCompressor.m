//
//  SenbayFormatCompressor.m
//  QRCodeTest
//
//  Created by Yuuki Nishiyama on 2015/03/20.
//  Copyright (c) 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import "SenbayDataFormatCompressor.h"
#import "ReservedKeys.h"


@implementation SenbayDataFormatCompressor{
    ReservedKeys *reservedKeys;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        reservedKeys = [[ReservedKeys alloc]init];
        [self initKeyArray];
    }
    return self;
}

- (void) initKeyArray
{
    [reservedKeys setKeyValue:@"TIME" value:@"0"];
    [reservedKeys setKeyValue:@"LONG" value:@"1"];
    [reservedKeys setKeyValue:@"LATI" value:@"2"];
    [reservedKeys setKeyValue:@"ALTI" value:@"3"];
    [reservedKeys setKeyValue:@"ACCX" value:@"4"];
    [reservedKeys setKeyValue:@"ACCY" value:@"5"];
    [reservedKeys setKeyValue:@"ACCZ" value:@"6"];
    [reservedKeys setKeyValue:@"YAW"  value:@"7"];
    [reservedKeys setKeyValue:@"ROLL" value:@"8"];
    [reservedKeys setKeyValue:@"PITC" value:@"9"];
    [reservedKeys setKeyValue:@"HEAD" value:@"A"];
    [reservedKeys setKeyValue:@"SPEE" value:@"B"];
    [reservedKeys setKeyValue:@"BRIG" value:@"C"];
    [reservedKeys setKeyValue:@"AIRP" value:@"D"];
    [reservedKeys setKeyValue:@"HTBT" value:@"E"];
    [reservedKeys setKeyValue:@"V" value:@"V"];
}


- (NSString *)encode:(NSString *)text
          baseNumber:(int)baseNumber
{
    SpecialNumber* xNumber = [[SpecialNumber alloc] init];
    NSArray* array = [text componentsSeparatedByString:@","];
    NSMutableString* newText = [[NSMutableString alloc] init];
    for (int i=0; i<[array count]; i++) {
        NSArray* contents = [[array objectAtIndex:i] componentsSeparatedByString:@":"];
        NSString* key = [contents objectAtIndex:0];
        NSString* reservedKey = [reservedKeys getValueByKey:key];
        //予約されているキーの判定、予約語の場合は、:を省略する
        bool unkonwnKey = NO;
        if([reservedKey length] != 0){
            key = reservedKey;
            unkonwnKey = YES;
        }else{
            unkonwnKey = NO;
        }
        NSString* value = [contents objectAtIndex:1];
        
        if([value hasPrefix:@"'"]){
            if(unkonwnKey){
                [newText appendString:[NSString stringWithFormat:@"%@%@", key, value]];
            }else{
                [newText appendString:[NSString stringWithFormat:@"%@:%@", key, value]];
            }
        }else if([key isEqualToString:@"V"]){ //If key value is "V", compressor does not compress.
            [newText appendString:[NSString stringWithFormat:@"%@:%@", key, value]];
            NSLog(@"[Warning] Compressing version information (Key='V') was canceled!");
        }else {
            if(unkonwnKey){
                [newText appendString:[NSString stringWithFormat:@"%@%@", key, [xNumber encodeBaseX:baseNumber doubleValue:[value doubleValue]]]];
            }else{
                [newText appendString:[NSString stringWithFormat:@"%@:%@", key, [xNumber encodeBaseX:baseNumber doubleValue:[value doubleValue]]]];
            }
        }
        if(i != [array count]-1){
            [newText appendString:@","];
        }
    }
    return newText;
}



- (NSString *) decode:(NSString *)text
           baseNumber:(int)baseNumber
{
    SpecialNumber* xNumber = [[SpecialNumber alloc] init];
    NSArray* array = [text componentsSeparatedByString:@","];
    NSMutableString* newText = [[NSMutableString alloc] init];
    for (int i=0; i<[array count]; i++){
        // "key"と"value"を分ける
        NSString* line = [array objectAtIndex:i];
        NSString* key = @"";
        NSString* value = @"";
        NSArray* contents = [line componentsSeparatedByString:@":"];
        if([contents count] > 1){ //:を使って分割できた場合
            key = [contents objectAtIndex:0];
            value = [contents objectAtIndex:1];
        }else{ //:を使って分割出来なかった場合
            key = [line substringWithRange:NSMakeRange(0, 1)];
            value = [line substringWithRange:NSMakeRange(1, [line length]-1)];
        }
        // 予約キーに登録されている場合は、keyの値を更新する
        NSString* reservedKey = [reservedKeys getKeyByValue:key];
        if([reservedKey length] != 0){
            key = reservedKey;
        }
        
        if([value hasPrefix:@"'"]){
            [newText appendString:[NSString stringWithFormat:@"%@:%@", key, value]];
        }else {
            NSRange range = [value rangeOfString:@"."];
            if (range.location != NSNotFound) {
                //Case of double value
                double doubleValue = [xNumber decodeDoubleBaseX:baseNumber value:value];
                [newText appendString:[NSString stringWithFormat:@"%@:%g", key, doubleValue]];
            } else if([key isEqualToString:@"V"]){ //If key value is "V", compressor does not compress.
                [newText appendString:[NSString stringWithFormat:@"%@:%@", key, value]];
//                NSLog(@"[Warning] Compressing version information (Key='V') was canceled!");
            } else {
                //Case of long value
                long longValue = [xNumber decodeLongBaseX:baseNumber value:value];
                [newText appendString:[NSString stringWithFormat:@"%@:%ld", key, longValue]];
            }
        }
        if(i != [array count]-1){
            [newText appendString:@","];
        }
    }
    return newText;
}


- (int) getVersionNumber:(NSString *)text{
    NSString* versionNumber = @"0";
    for(int i=0; i<[text length] ; i++){
        NSString *s = [text substringWithRange:NSMakeRange(i,1)];
        if([s isEqualToString:@","]){
            NSString *versionStr = [text substringToIndex:i];
            NSLog(@"%@", versionStr);
            // version 3 or 4
            NSArray *versionElement = [versionStr componentsSeparatedByString:@":"];
            if( versionElement.count > 1){
                if([[versionElement objectAtIndex:0] isEqualToString:@"V"]){
                    versionNumber = [versionElement objectAtIndex:1];
                    return (int)[versionNumber integerValue];
                }
            }
            // verion 0 or 1, 2
            if(versionStr.length > 0){
                NSString *firstKey = [versionStr substringWithRange:NSMakeRange(0,1)];
                if([firstKey isEqualToString:@"0"]){
                    versionNumber = @"2";
                }else if([firstKey isEqualToString:@"T"]){
                    versionNumber = @"1";
                }else{
                    versionNumber = @"0";
                }
                return (int)[versionNumber integerValue];
            }
            break;
        }
    }
    //NSLog(@"%@", versionNumber);
    return (int)[versionNumber integerValue];
}

@end
