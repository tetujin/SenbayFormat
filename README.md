# SenbayFormat

## Overview
SenbayFormatは、[Senbay](http://www.senbay.info "Senbay")で撮影したQRコードに保存されたセンサデータを管理する為のライブラリです。
SenbayFormatには、SnebayFormatでのセンサデータの出力と圧縮、解凍、取得機能が備わっています。
データ圧縮には、121進数を用いた圧縮を用いています。

## What's new?
### Version 1.0
_SenbayDataFormatCompressorに、getVersionNumberメソッドを追加しました。本メソッドでは、Senbay形式の文字列を引数に与えることで、形式のバージョン(0-4)を返します。_


## License


## Test code
`SenbayFormat.xcodeproj`をダブルクリックして、Xcodeでプロジェクトを開いて下さい。

`main.m`には、以下のサンプルコードを記述しています。

* 121進数でのEncode, Decode
* 5種類のSenbay形式でのEncode, Decode
* SensorDataManagerを用いたセンサデータの取得


### 121進数でのEncode, Decode
#### Encode
```Objective-C
        long sampleValue01 = 12345;
        NSLog(@"%ld", sampleValue01);
        SpecialNumber* spNum = [[SpecialNumber alloc] init];
        NSString *encodedValue01 = [spNum encodeBaseX:baseNumber longValue:sampleValue01];
        NSLog(@"%@", encodedValue01);
        long decodedValue01 = [spNum decodeLongBaseX:baseNumber value:encodedValue01];
        NSLog(@"%ld", decodedValue01);
```

#### Decode
```Objective-C
    double sampleValue02 = -234.00345;
    NSLog(@"%g", sampleValue02);
    NSString* encodedValue02 = [spNum encodeBaseX:baseNumber doubleValue:sampleValue02];
    NSLog(@"%@",encodedValue02);
    double decodedValue02 = [spNum decodeDoubleBaseX:baseNumber value:encodedValue02];
    NSLog(@"%g", decodedValue02);
```

### 5種類のSenbay形式でのEncode, Decode
|バージョン番号|形式|バージョン情報の有無|圧縮の有無|サンプル（圧縮前）|サンプル（圧縮後）|
|---|---|---|---|---|---|
|0|CSV|×|×|1234,0.1,0.01,-0.1|×|
|1|Key-Value|×|×|TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|×|
|2|Key-Value|×|○|TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|0xxx,1xxx,2xxx,3xxx|
|3|Key-Value|○|×|V:3,TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|×|
|4|Key-Value|○|○|V:4,TIME:1234,ACCX:0.1,ACCY:0.01,ACCZ:-0.1|V:4,0xxx,1xxx,2xxx,3xxx|



#### CSV形式での保存


## Adding the static library to your iOS project
1. SenbayFormat内の以下のファイルを、プロジェクトに保存して下さい。

* ReservedKeys.h
* ReservedKeys.m
* SenbayDataFormatCompressor.h
* SenbayDataFormatCompressor.m
* SensorDataManager.h
* SensorDataManager.m
* SpecialNumber.h
* SpecialNumber.m


2. SenbayDataFormatCompressor.hとSensorDataManager.hをインポートして下さい。

    #import "SenbayDataFormatCompressor.h" 
    #import "SensorDataManager.h"


## Links
* [Yuuki NISHIYAMA](http://www.ht.sfc.keio.ac.jp/~tetujin "Yuuki NISHIYAMA")
* [Takuro YONEZAWA](http://www.ht.sfc.keio.ac.jp/~takuro "Takuro YONEZAWA")
* [Tokuda Laboratory](http://www.ht.sfc.keio.ac.jp "Tokuda Laboratory")
* [Senbay Offical Webpage](http://www.senbay.info "Senbay")
* [Senbay App Store](https://itunes.apple.com/jp/app/id975034760 "App Store")
* [Senbay Reader App Store](https://itunes.apple.com/jp/app/senbay-reader-senbayde-cuo/id975073024?mt=8 "App Store")


## Reference
