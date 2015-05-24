//
//  main.m
//  SenbayFormat
//
//  Created by Yuuki Nishiyama on 2015/05/24.
//  Copyright (c) 2015 Yuuki NISHIYAMA. All rights reserved.
//

// [List of Format Version]
// Format Version 0 (normal data     ) => "1234,0.1,0.03378785976,0.001,-1,-0.1,-0.01,-0.001,'CLEAR'" => normal versiono
// Format Version 1 (normal data     ) => "TIME:1234,ACCX:0.1,ACCY:0.03378785976,ACCZ:0.001,YAW:-1,ROLL:-0.1,PITC:-0.01,BRIG:-0.001,WEATHER:'CLEAR'"
// Format Version 2 (compression data) => "TIME:1234,ACCX:0.1,ACCY:0.03378785976,ACCZ:0.001,YAW:-1,ROLL:-0.1,PITC:-0.01,BRIG:-0.001,WEATHER:'CLEAR'"
// Format Version 3 (normal data     ) => "V:3,TIME:1234,ACCX:0.1,ACCY:0.03378785976,ACCZ:0.001,YAW:-1,ROLL:-0.1,PITC:-0.01,BRIG:-0.001,WEATHER:'CLEAR'"
// Format Version 4 (compression data) => "V:4,TIME:1234,ACCX:0.1,ACCY:0.03378785976,ACCZ:0.001,YAW:-1,ROLL:-0.1,PITC:-0.01,BRIG:-0.001,WEATHER:'CLEAR'"

// [List of Reserved Word]
// "TIME" => "0"
// "LONG" => "1"
// "LATI" => "2"
// "ALTI" => "3"
// "ACCX" => "4"
// "ACCY" => "5"
// "ACCZ" => "6"
// "YAW"  => "7"
// "ROLL" => "8"
// "PITC" => "9"
// "HEAD" => "A"
// "SPEE" => "B"
// "BRIG" => "C"
// "AIRP" => "D"
// "HTBT" => "E"
// "V"  => "V"

#import <Foundation/Foundation.h>
#import "SenbayDataFormatCompressor.h"
#import "SpecialNumber.h"
#import "SensorDataManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int baseNumber = 121;

        /**
         * Basic Sample Code for long value to compressed string
         */
        long sampleValue01 = 12345;
        NSLog(@"%ld", sampleValue01);
        SpecialNumber* spNum = [[SpecialNumber alloc] init];
        NSString *encodedValue01 = [spNum encodeBaseX:baseNumber longValue:sampleValue01];
        NSLog(@"%@", encodedValue01);
        long decodedValue01 = [spNum decodeLongBaseX:baseNumber value:encodedValue01];
        NSLog(@"%ld", decodedValue01);
        
        
        /**
         * Basic Sample Code for double value to compressed string
         */
        double sampleValue02 = -234.00345;
        NSLog(@"%g", sampleValue02);
        NSString* encodedValue02 = [spNum encodeBaseX:baseNumber doubleValue:sampleValue02];
        NSLog(@"%@",encodedValue02);
        double decodedValue02 = [spNum decodeDoubleBaseX:baseNumber value:encodedValue02];
        NSLog(@"%g", decodedValue02);
        
        
        
        /**
         * Basic sample code for compress value with Senbay Format
         */
        NSString *sampleText00 = @"TIME:1234,ACCX:0.1,ACCY:0.03378785976,ACCZ:0.001,YAW:-1,ROLL:-0.1,PITC:-0.01,BRIG:-0.001,WEATHER:'CLEAR'";
        SenbayDataFormatCompressor* compressor = [[SenbayDataFormatCompressor alloc] init];
        NSString *encodedText00 = [compressor encode:sampleText00 baseNumber:baseNumber];
        NSLog(@"%@", encodedText00);
        NSString *decodedText00 = [compressor decode:encodedText00 baseNumber:baseNumber];
        NSLog(@"%@",decodedText00);
        
        
        
        /**
         * Sample Code for compress value with Senbay Format and Version information
         */
        NSString* sampleText01 = @"1234,0.01,0.1,1,12,123,-12,-1.2,-0.1,-0.01";
        NSString* sampleText02 = @"TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:0.001";
        NSString* sampleText03 = @"0:1234,ACCX:0.1,ACCY:0.01,ACCZ:0.001";
//        int csvFormat = 0;
//        int noVerInfoNormalFormat = 1;
//        int noVerInfoCompressionFormat = 2;
        int dataNormalVersionNumber = 3;
        int dataCompressionVerNumber = 4;
        
        // [Format No.0] CSV Format
        NSLog(@"%@", sampleText01);
        NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText01]);
    
        // [Format No.1] No version information and no compression
        NSLog(@"%@", sampleText02);
        NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText02]);
        
        // [Format No.2] No version information and compression
        NSLog(@"%@", sampleText03);
        NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText03]);
        
        // *** You will append version (type) of data format yourself. ***
        
        // [Format No.3] Version information and no compression
        NSString* sampleText04 = [NSString stringWithFormat:@"V:%d,%@", dataNormalVersionNumber, sampleText02];
        NSLog(@"%@",sampleText04);
        NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText04]);
        if([compressor getVersionNumber:sampleText04] == dataNormalVersionNumber){
            NSLog(@"%@", sampleText04);
        }
        
        // [Format No.4] Version information and compression
        NSString* sampleText05 = [NSString stringWithFormat:@"V:%d,%@",dataCompressionVerNumber, [compressor encode:sampleText02 baseNumber:baseNumber]];
        NSString *decodedText05 = @"";
        NSLog(@"%@",sampleText05);
        NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText05]);
        if([compressor getVersionNumber:sampleText05] == dataCompressionVerNumber){
            decodedText05 = [compressor decode:sampleText05 baseNumber:baseNumber];
            NSLog(@"%@", decodedText05);
        }
    
        // Get sensor data by using SenbayDataManager
        SensorDataManager* manager = [[SensorDataManager alloc] init];
        [manager setSensorDataString:decodedText05];
        NSLog(@"%@", [manager getDataByKey:@"TIME"]);
        NSLog(@"%@", [manager getDataByKey:@"ACCX"]);
        NSLog(@"%@", [manager getDataByKey:@"ACCY"]);
        NSLog(@"%@", [manager getDataByKey:@"ACCZ"]);
    }
    return 0;
}
