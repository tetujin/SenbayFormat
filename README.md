# SenbayFormat
![Senbay Icon](https://yt3.ggpht.com/-hQFgscIKccg/AAAAAAAAAAI/AAAAAAAAAAA/MANEDCbBn7M/s100-c-k-no/photo.jpg "Senbay Icon")

## Overview
SenbayFormatライブラリは、[Senbay](http://www.senbay.info "Senbay")で使用するセンサデータフォーマットを操作する為のライブラリです。
SenbayFormatライブラリには、SnebayFormatでのセンサデータの入出力と圧縮、解凍機能が備わっています。
データ圧縮には、121進数を用いた圧縮を用いています。


## What's new?
### Version 1.0
* _SenbayDataFormatCompressorに、getVersionNumberメソッドを追加しました。本メソッドでは、Senbay形式の文字列を引数に与えることで、形式のバージョン(0-4)を返します。_


## Test code
`SenbayFormat.xcodeproj`をダブルクリックして、Xcodeでプロジェクトを開く。

`main.m`には、以下のサンプルコードが記述されている。

* 121進数でのEncode, Decode
* 5種類のSenbay形式でのEncode, Decode
* SensorDataManagerを用いたセンサデータの取得


### 121進数でのEncode, Decode
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


### 5種類のSenbay形式でのEncode, Decode
Senbayには以下の0-4の5種類のバージョンがあり、__Version 4__ の使用を推奨する。

|バージョン番号|形式|バージョン情報の有無|圧縮の有無|サンプル（圧縮前）|サンプル（圧縮後）|
|---|---|---|---|---|---|
|0|CSV|×|×|1234,0.1,0.01,-0.1|×|
|1|Key-Value|×|×|TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|×|
|2|Key-Value|×|○|TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|0xxx,1xxx,2xxx,3xxx|
|3|Key-Value|○|×|V:3,TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|×|
|4|Key-Value|○|○|V:4,TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|V:4,0xxx,1xxx,2xxx,3xxx|
* サンプル(圧縮後)の_x_は、121進数圧縮後の文字列

__定義済みKEY__

16種類がKEYが定義済みKEYとして定義されている。定義済みKEYを用いることで、データの圧縮率が向上する。

|予約語|圧縮後|意味|
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


#### Version 0 (CSV, バージョン情報無し, 圧縮無し)

|0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|unixtime|timestamp|AccX|AccY|AccZ|GyroX|GyroY|GyroZ|Lng|Lat|Orientation|proximity|heading|battery|h-accuracy|v-accuracy|altitude|HTBT|
|1.40997908972E11|2014/09/06 13:51:29:714|0.54921|-0.183899|-0.595016|0.19394|0.025706|-0.254604|140.188107|36.317965|0.0|1.0|303.031494|-1.0|10.0|8.0|347.317627|141|

```Objective-C
[Sample] NSString* sampleCSVDate = @"1.40997908972E11,2014/09/06 13:51:29:714,0.54921,-0.183899,-0.595016,0.19394,0.025706,-0.254604,140.188107,36.317965,0.0,1.0,303.031494,-1.0,10.0,8.0,347.317627,141";
```


#### Version 1 (Key-Value, バージョン情報無し, 圧縮無し)
圧縮の必要は無いため、データをそのまま扱う。また、TIME(時間)のKEYを文字列の一番はじめにしなればならない。
```Objective-C
NSString* sampleText02 = @"TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:0.001";
NSLog(@"%@", sampleText02);
NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText02]);
// Get sensor data by using SenbayDataManager
SensorDataManager* manager = [[SensorDataManager alloc] init];
[manager setSensorDataString:decodedText05];
NSLog(@"%@", [manager getDataByKey:@"TIME"]);
```

#### Version 2 (Key-Value, バージョン情報無し, 圧縮有り)
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

#### Version 3 (Key-Value, バージョン情報有り, 圧縮無し)
```Objective-C
NSString* sampleText04 = [NSString stringWithFormat:@"V:%d,%@", dataNormalVersionNumber, sampleText02];
NSLog(@"%@",sampleText04);
NSLog(@"Format version is ... %d", [compressor getVersionNumber:sampleText04]);
if([compressor getVersionNumber:sampleText04] == dataNormalVersionNumber){
  NSLog(@"%@", sampleText04);
}
```

#### Version 4 (Key-Value, バージョン情報有り, 圧縮有り)
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

## Adding the static library to your iOS project
1. SenbayFormat内の以下のファイルを、プロジェクトに保存。

  * ReservedKeys.h
  * ReservedKeys.m
  * SenbayDataFormatCompressor.h
  * SenbayDataFormatCompressor.m
  * SensorDataManager.h
  * SensorDataManager.m
  * SpecialNumber.h
  * SpecialNumber.m

2. SenbayDataFormatCompressor.hとSensorDataManager.hをインポート。

```Objective-C
#import "SenbayDataFormatCompressor.h" 
#import "SensorDataManager.h"
```

3. SenbayDataFormatCompressorとSensorDataManagerを初期化

```Objective-C
SenbayDataFormatCompressor* compressor = [[SenbayDataFormatCompressor alloc] init];
SensorDataManager* manager = [[SensorDataManager alloc] init];
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
The MIT License
Copyright (c) 2015 Yuuki NISHIYAMA

以下に定める条件に従い、本ソフトウェアおよび関連文書のファイル（以下「ソフトウェア」）の複製を取得するすべての人に対し、ソフトウェアを無制限に扱うことを無償で許可します。これには、ソフトウェアの複製を使用、複写、変更、結合、掲載、頒布、サブライセンス、および/または販売する権利、およびソフトウェアを提供する相手に同じことを許可する権利も無制限に含まれます。

上記の著作権表示および本許諾表示を、ソフトウェアのすべての複製または重要な部分に記載するものとします。

ソフトウェアは「現状のまま」で、明示であるか暗黙であるかを問わず、何らの保証もなく提供されます。ここでいう保証とは、商品性、特定の目的への適合性、および権利非侵害についての保証も含みますが、それに限定されるものではありません。 作者または著作権者は、契約行為、不法行為、またはそれ以外であろうと、ソフトウェアに起因または関連し、あるいはソフトウェアの使用またはその他の扱いによって生じる一切の請求、損害、その他の義務について何らの責任も負わないものとします。

## Reference
