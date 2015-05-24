//
//  SpecialNumber.m
//  SpecialNumber
//
//  Created by Yuuki Nishiyama on 2014/12/07.
//  Copyright (c) 2014 Yuuki NISHIYAMA. All rights reserved.
//

#import "SpecialNumber.h"
#import "stdio.h"

@implementation SpecialNumber
{
    NSArray* TABLE;
    NSArray* REVERSE_TABLE;
    Byte* hoge;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTable];
    }
    return self;
}


/**
 * --------------- Encode processing ------------------
 */

/**
 * -----------------------------------------------
 * Decode "long value" to "String Special Number"
 * -----------------------------------------------
 */
- (NSString *) encodeBaseX:(int)shinsu longValue:(long)value
{
    if(shinsu > [TABLE count] || shinsu < 10){
        NSLog(@"shinsu must be 2-%ld",[TABLE count]);
    }
    // In the case of minus value, this method change a minus value to a plues value.
    bool isNegative = (value < 0);
    if(isNegative){
        value *= -1;
    }
    //Convert normal value to x-number value
    NSMutableArray* ketas = [[NSMutableArray alloc]init];
    if(value == 0){
        [ketas addObject:@0];
    }else{
        while (value > 0) {
//            NSLog(@"%ld / %d  = %ld ... %d", (long)value, shinsu, ((long)value/(int)shinsu), (int)fmod(value, shinsu));
            int amari = (int)fmod(value, shinsu);
            [ketas addObject:[TABLE objectAtIndex:amari]];
            value = ((long)value / (int)shinsu);
        }
    }
    /**
     * 0x31 -> 1 in the 16 hexadecimal number (ascii character)
     * 49   -> 1 in the 10 hexadecimal number (ascii character)
     */
    NSMutableString *muString = [NSMutableString string];
    for(NSNumber* number in ketas){
        char ellipsis = [number floatValue];
        //NSLog(@"%@", [NSString stringWithFormat:@"=> %@", number]);
        //NSLog(@"%@", [NSString stringWithFormat:@"=== %c === %@",ellipsis, number]);
        [muString insertString:[NSString stringWithFormat:@"%c",ellipsis] atIndex:0];
    }
    if(isNegative){
        [muString insertString:@"-" atIndex:0];
        return muString;
    }else{
        return muString;
    }
}


/**
 * -----------------------------------------------
 * Decode "double value" to "String Special Number"
 * -----------------------------------------------
 */
- (NSString *) encodeBaseX:(int)shinsu doubleValue:(double)value
{
    
    if(shinsu > [TABLE count] || shinsu < 10){
        NSLog(@"shinsu must be 2-%ld",[TABLE count]);
    }
    // In the case of minus value, this method change a minus value to a plues value.
    bool isNegative = (value < 0);
    if(isNegative){
        value *= -1;
    }
    
    // Remove extra zeros ( at Number -> String )
    NSString *valueStr = [NSString stringWithFormat:@"%f", value];
    NSMutableString *str = [[NSMutableString alloc]initWithString:valueStr];
    for(int i=[str length]-1; i>=0; i--){
        char zero = '0';
        if([str characterAtIndex:i] == zero){
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
        }else if([str characterAtIndex:i] == '.'){
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
            break;
        }else{
            break;
        }
    }
    valueStr = [[NSString alloc]initWithString:str];
    // Divide a text into "Integer Part" and "Decimal Part"
    NSArray* doubleValues = [[NSArray alloc] initWithArray:[valueStr componentsSeparatedByString:@"."]];
    
    //Calculate a Integer Part
    NSString *integerString = [self encodeBaseX:shinsu longValue:[[doubleValues objectAtIndex:0] longLongValue]];
    if([doubleValues count] == 1){
        if(isNegative){
            return [NSString stringWithFormat:@"-%@", integerString];
        }else{
            return integerString;
        }
    }
    if([[doubleValues objectAtIndex:0] longLongValue] == 0){
        integerString =  [self encodeBaseX:shinsu longValue:0];
    }
    
    //Calculate a Decimal Part
    NSString *doubleString = [self encodeBaseX:shinsu longValue:[[doubleValues objectAtIndex:1] longLongValue]];
    
    //Add zeros
    NSMutableString *zeros = [[NSMutableString alloc] init];
    NSString *doubleBaseStr = [doubleValues objectAtIndex:1];
    for(int i=0; i<doubleBaseStr.length; i++){
        if([[doubleBaseStr substringWithRange:NSMakeRange(i, 1)] compare :@"0"] == NSOrderedSame){
            char ellipsis = [[TABLE objectAtIndex:0] floatValue];
            NSString *zeroChar = [NSString stringWithFormat:@"%c",ellipsis];
            [zeros appendString:zeroChar];
        }else{
            break;
        }
    }
    if(isNegative){
        return [NSString stringWithFormat:@"-%@.%@%@", integerString, zeros, doubleString];
    }else{
        if([doubleValues count] > 0){
        }
        return [NSString stringWithFormat:@"%@.%@%@", integerString, zeros, doubleString];
    }
}




/**
 * --------------- Decode processing ------------------
 */

/**
 * -----------------------------------------------
 * Encode "String Special Number" to "long value"
 * -----------------------------------------------
 */
- (long)decodeLongBaseX:(int)shinsu value:(NSString *)value
{
    if(shinsu > [TABLE count] || shinsu < 10){
        NSLog(@"shinsu must be 2-%ld",[TABLE count]);
    }
    BOOL isNegative = [value hasPrefix:@"-"];
    
    // Converts Text to Bytes
    NSData *asciiData = [value dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSUInteger len = [asciiData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [asciiData bytes], len);
    long theValue = 0;
    for (int i=len-1; i>=0; i--) {
        long v = pow(shinsu, len-i-1) * [REVERSE_TABLE[byteData[i]] longValue];
        theValue += v;
        
    }
    
    if(isNegative){
        return theValue * -1;
    }else{
        return theValue;
    }
}



-( double) decodeDoubleBaseX:(int)shinsu value:(NSString *)valueStr
{
    if(shinsu > [TABLE count] || shinsu < 10){
        NSLog(@"shinsu must be 2-%ld",[TABLE count]);
    }
    BOOL isNegative = [valueStr hasPrefix:@"-"];
    // Divide a text into "Integer Part" and "Decimal Part"
    NSArray* doubleValues = [[NSArray alloc] initWithArray:[valueStr componentsSeparatedByString:@"."]];

    if([doubleValues count] > 0){
        //Calculate a integer part
        long seisu = [self decodeLongBaseX:shinsu value:[doubleValues objectAtIndex:0]];
        if(seisu == 0){
            seisu = 0;
        }
        if([doubleValues count] == 1){
            return seisu;
        }
        
        //Add zeros
        NSMutableString *zeros = [[NSMutableString alloc] init];
        NSString *doubleBaseStr = [doubleValues objectAtIndex:1];
        for(int i=0; i<doubleBaseStr.length; i++){
            //NSString *zeroChar = [NSString stringWithFormat:@"%c",[TABLE objectAtIndex:0]];
            char ellipsis = [[TABLE objectAtIndex:0] floatValue];
            NSString *zeroChar = [NSString stringWithFormat:@"%c",ellipsis];
            //Generate zeros
            if([[doubleBaseStr substringWithRange:NSMakeRange(i, 1)] compare:zeroChar] == NSOrderedSame){
                [zeros appendString:@"0"];
            }else{
                break;
            }
        }
        
        NSMutableString *baseShosu = [[NSMutableString alloc] initWithString:[doubleValues objectAtIndex:1]];
        for(int i=0; i<zeros.length; i++){
            [baseShosu deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        //Calculate a Decimal Part
        long syosu =  [self decodeLongBaseX:shinsu value:baseShosu];
        
        if(isNegative && seisu >= 0){
            return [[NSString stringWithFormat:@"-%ld.%@%ld",seisu,zeros,syosu] doubleValue];
        }else{
            return [[NSString stringWithFormat:@"%ld.%@%ld",seisu,zeros,syosu] doubleValue];
        }
    }else{
        return [self decodeLongBaseX:shinsu value:valueStr];
    }
}




- (void) initTable
    {
        TABLE = [[NSArray alloc] initWithObjects:
                      @1, @2, @3, @4,
                 @5,  @6, @7, @8, @9,
                 @10, @11, @12, @13, @14,
                 @15, @16, @17, @18, @19,
                 @20, @21, @22, @23, @24,
                 @25, @26, @27, @28, @29,
                 @30, @31, @32, @33, @34,
                 @35, @36, @37, @38,
                 @40, @41, @42, @43,
                           @47, @48, @49,
                 @50, @51, @52, @53, @54,
                 @55, @56, @57,      @59,
                 @60, @61, @62, @63, @64,
                 @65, @66, @67, @68, @69,
                 @70, @71, @72, @73, @74,
                 @75, @76, @77, @78, @79,
                 @80, @81, @82, @83, @84,
                 @85, @86, @87, @88, @89,
                 @90, @91, @92, @93, @94,
                 @95, @96, @97, @98, @99,
                 @100, @101, @102, @103, @104,
                 @105, @106, @107, @108, @109,
                 @110, @111, @112, @113, @114,
                 @115, @116, @117, @118, @119,
                 @120, @121, @122, @123, @124,
                 @125, @126, @127,
                 nil];
        
        REVERSE_TABLE =   [[NSArray alloc] initWithObjects:
                           @0, @0, @1, @2, @3,
                           @4, @5, @6, @7, @8,
                           @9, @10, @11, @12, @13,
                           @14, @15, @16, @17, @18,
                           @19, @20, @21, @22, @23,
                           @24, @25, @26, @27, @28,
                           @29, @30,@31, @32, @33,
                           @34, @35, @36, @37,@0,
                           @38, @39, @40, @41,@0,
                           @0, @0, @42,@43,@44,
                           @45, @46, @47, @48, @49,
                           @50, @51, @52,  @0,  @53,
                           @54, @55, @56, @57, @58,
                           @59, @60, @61, @62, @63,
                           @64, @65, @66, @67, @68,
                           @69, @70, @71, @72, @73,
                           @74, @75, @76, @77, @78,
                           @79, @80, @81, @82, @83,
                           @84, @85, @86, @87, @88,
                           @89, @90, @91, @92, @93,
                           @94, @95, @96, @97, @98,
                           @99, @100, @101, @102, @103,
                           @104, @105, @106, @107, @108,
                           @109, @110, @111, @112, @113,
                           @114, @115, @116, @117, @118,
                           @119, @120, @121,
                           nil];
        
}


@end
