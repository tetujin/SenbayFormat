//
//  SenbayFormatCompressor.h
//  QRCodeTest
//
//  Created by Yuuki Nishiyama on 2015/03/20.
//  Copyright (c) 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SpecialNumber.h"

@interface SenbayDataFormatCompressor : NSObject

- (NSString *) encode:(NSString *)text baseNumber:(int)baseNumber;
- (NSString *) decode:(NSString *)text baseNumber:(int)baseNumber;
- (int) getVersionNumber:(NSString *)text;
@end
