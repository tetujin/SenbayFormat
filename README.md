# SenbayFormat
![Senbay Icon](https://yt3.ggpht.com/-hQFgscIKccg/AAAAAAAAAAI/AAAAAAAAAAA/MANEDCbBn7M/s100-c-k-no/photo.jpg "Senbay Icon")

## Overview
SenbayFormat library provides control method of sensor data format which is used in [Senbay](http://www.senbay.info "Senbay").
In the sample codes, we will show you following points.
- Compression and uncompression method for sensor data by using Base-121 
- Sensor data compression/uncompression method by SenbayFormat
- Sensor data manegement using SensorDataManager

## What's new?
### Version 1.0
* _We add a new method of getVersionNumber to SenbayDataFormatCompression. This method return a format version of SenbayFormat (Version 0 ~ 4) from a SenbayFormat text. _



## Adding the library to your iOS project
### CocoaPods
1. Install [CocoaPod](https://guides.cocoapods.org/using/getting-started.html#toc_3) on your computer
2. Create a [Podfile](https://guides.cocoapods.org/using/using-cocoapods.html), and add your dependencies:
  ```
    pod 'SenbayFormat'
  ```
3. Run `$ Pod install` in your project directory.
4. Open `App.xcworkspace` and build.


### Directly
1. First, you should copy following files from SenbayFormat.

  * ReservedKeys.h
  * ReservedKeys.m
  * SenbayDataFormatCompressor.h
  * SenbayDataFormatCompressor.m
  * SensorDataManager.h
  * SensorDataManager.m
  * SpecialNumber.h
  * SpecialNumber.m

2. Second, please import ``SenbayDataFormatCompressor.h`` and ``SensorDataManager.h`` at your target file.

  ```Objective-C
  #import "SenbayDataFormatCompressor.h" 
  #import "SensorDataManager.h"
  ```

3. Finally, you will initialize SenbayDataFormatCompressor and SensorDataManager

  ```Objective-C
  SenbayDataFormatCompressor* compressor = [[SenbayDataFormatCompressor alloc] init];
  SensorDataManager* manager = [[SensorDataManager alloc] init];
  ```




## Sample Code
Please open a Project on Xcode through double clicking `SenbayFormat.xcodeproj`.

Smaple codes is written on the `main.m` file.

* Compression and uncompression method for sensor data by using Base-121 
* Sensor data compression/uncompression method by SenbayFormat
* Sensor data manegement using SensorDataManager


### Compression and uncompression method for sensor data by using Base-121 
```Objective-C
// Case of long value 
long sampleValue01 = 12345;
NSLog(@"%ld", sampleValue01);
SpecialNumber* spNum = [[SpecialNumber alloc] init];
NSString *encodedValue01 = [spNum encodeBaseX:baseNumber longValue:sampleValue01];
NSLog(@"%@", encodedValue01);
long decodedValue01 = [spNum decodeLongBaseX:baseNumber value:encodedValue01];
NSLog(@"%ld", decodedValue01);

// Case of double value
double sampleValue02 = -234.00345;
NSLog(@"%g", sampleValue02);
NSString* encodedValue02 = [spNum encodeBaseX:baseNumber doubleValue:sampleValue02];
NSLog(@"%@",encodedValue02);
double decodedValue02 = [spNum decodeDoubleBaseX:baseNumber value:encodedValue02];
NSLog(@"%g", decodedValue02);
```


### Definition of SenbayFormat
Currenty, we have 5 version of SenbayFormat (Version 0 ~ 4) . We recommend to use __Version 4__.

|Version Number|Format|Version Information Existence| Compression Existence | Smaple Data (Befor Compression)| Sample (After   Compression)|
|---|---|---|---|---|---|
|0|CSV|×|×|1234,0.1,0.01,-0.1|×|
|1|Key-Value|×|×|TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|×|
|2|Key-Value|×|○|TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|0xxx,1xxx,2xxx,3xxx|
|3|Key-Value|○|×|V:3,TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|×|
|4|Key-Value|○|○|V:4,TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|V:4,0xxx,1xxx,2xxx,3xxx|
* _xxx_ means characters of compressed text which is compressed by using 121 base-number compression algorithm. 

__Definition's Keys__

16 type of KEYs are defined as the definition KEYs.

|Reserved Word|After Compression|Sense|
|---|---|---|
|TIME|1|Unixtime|
|LONG|2|Latitude|
|LATI|3|Longitude|
|ALTI|4|Altitude|
|ACCX|5|Accelerometer-X|
|ACCY|6|Accelerometer-Y|
|ACCZ|7|Accelerometer-Z|
|YAW|8|Gryo Scope - Yaw|
|ROLL|9|Gryo Scope - Roll|
|PITC|A|Gryo Scope - Pitc|
|HEAD|B|Heading|
|SPEE|C|Speed|
|BRIG|D|Brigthness|
|AIRP|E|Air pressure|
|HTBT|F|heartbeat|
|V|V|Version|


#### Version 0 (CSV, No version information, No compression)

|0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|unixtime|timestamp|AccX|AccY|AccZ|GyroX|GyroY|GyroZ|Lng|Lat|Orientation|proximity|heading|battery|h-accuracy|v-accuracy|altitude|HTBT|
|1.40997908972E11|2014/09/06 13:51:29:714|0.54921|-0.183899|-0.595016|0.19394|0.025706|-0.254604|140.188107|36.317965|0.0|1.0|303.031494|-1.0|10.0|8.0|347.317627|141|

```Objective-C
[Sample] NSString* sampleCSVDate = @"1.40997908972E11,2014/09/06 13:51:29:714,0.54921,-0.183899,-0.595016,0.19394,0.025706,-0.254604,140.188107,36.317965,0.0,1.0,303.031494,-1.0,10.0,8.0,347.317627,141";
```


#### Version 1 (Key-Value, No version information, No compression)
You have to set the TIME at head of a text.
```Objective-C
NSString* sampleText02 = @"TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:0.001";
NSLog(@"%@", sampleText02);
NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText02]);
// Get sensor data by using SenbayDataManager
SensorDataManager* manager = [[SensorDataManager alloc] init];
[manager setSensorDataString:decodedText05];
NSLog(@"%@", [manager getDataByKey:@"TIME"]);
```

#### Version 2 (Key-Value, No version information, Compression)
```Objective-C
// [Format No.2] No version information and compression
SenbayDataFormatCompressor* compressor = [[SenbayDataFormatCompressor alloc] init];
NSString* sampleText02 = @"TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:0.001";
NSString* sampleText03 = [compressor encode:sampleText02 baseNumber:121]
NSLog(@"%@", sampleText03);
NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText03]);
```

```Objective-C
NSString* sample = @"TIME:1425941221.812044,LONG:139.635849,LATI:35.439283,ALTI:-0.109436,SPEE:0.2,ACCX:-0.140427,ACCY:-0.145172,ACCZ:-0.754669,YAW:3.269728,ROLL:-0.698060,PITC:1.455648,HEAD:50.542423,BRIG:0.360247,BATT:-1,AIRP:0,TEMP:8.149988,WEAT:'Fog',HUMI:100,WIND:3.1";
```

#### Version 3 (Key-Value, No version information, No compression)
```Objective-C
NSString* sampleText04 = [NSString stringWithFormat:@"V:%d,%@", dataNormalVersionNumber, sampleText02];
NSLog(@"%@",sampleText04);
NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText04]);
if([compressor getVersionNumber:sampleText04] == dataNormalVersionNumber){
  NSLog(@"%@", sampleText04);
}
```

#### Version 4 (Key-Value, Version information, Compression)
```Objective-C
// [Format No.4] Version information and compression
NSString* sampleText05 = [NSString stringWithFormat:@"V:%d,%@",dataCompressionVerNumber, [compressor encode:sampleText02 baseNumber:baseNumber]];
NSString *decodedText05 = @"";
NSLog(@"%@",sampleText05);
NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText05]);
if([compressor getVersionNumber:sampleText05] == dataCompressionVerNumber){
    decodedText05 = [compressor decode:sampleText05 baseNumber:baseNumber];
    NSLog(@"%@", decodedText05);
}
```

```Objective-C
NSString* sample = @"TIME:1427521914.127140,LONG:139.495503,LATI:35.306662,ALTI:11.211637,SPEE:5.800000,ACCX:-1.454250,ACCY:-0.114590,ACCZ:-0.104630,YAW:0.369279,ROLL:-0.193332,PITC:0.238990,HEAD:11.522325,BRIG:0.973568,BATT:0.340000,AIRP:101.484795,TEMP:18.559991,WEAT:'Clear',HUMI:15,WIND:1.540000,HTBT:124";
```

### Get sensor data by using SenbayDataManager
```Objective-C
SensorDataManager* manager = [[SensorDataManager alloc] init];
[manager setSensorDataString:decodedText05];
NSLog(@"%@", [manager getDataByKey:@"TIME"]);
NSLog(@"%@", [manager getDataByKey:@"ACCX"]);
NSLog(@"%@", [manager getDataByKey:@"ACCY"]);
NSLog(@"%@", [manager getDataByKey:@"ACCZ"]);
```


## Links
* [Yuuki NISHIYAMA](http://www.ht.sfc.keio.ac.jp/~tetujin "Yuuki NISHIYAMA")
* [Takuro YONEZAWA](http://www.ht.sfc.keio.ac.jp/~takuro "Takuro YONEZAWA")
* [Tokuda Laboratory](http://www.ht.sfc.keio.ac.jp "Tokuda Laboratory")
* [Senbay Offical Webpage](http://www.senbay.info "Senbay")
* [Senbay Channel](https://www.youtube.com/channel/UCbnQUEc3KpE1M9auxwMh2dA?feature=iv&src_vid=zNybcucFGpI&annotation_id=annotation_602936465 "Senbay Channel")
* [Senbay App Store](https://itunes.apple.com/jp/app/id975034760 "App Store")
* [Senbay Reader App Store](https://itunes.apple.com/jp/app/senbay-reader-senbayde-cuo/id975073024?mt=8 "App Store")

## License
The MIT License (MIT)

Copyright (c) 2015 Yuuki NISHIYAMA

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Reference
