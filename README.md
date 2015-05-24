# SenbayFormat

## Overview
SenbayFormatは、[Senbay](http://www.senbay.info "Senbay")で撮影したQRコードに保存されたセンサデータを管理する為のライブラリです。
SenbayFormatには、SnebayFormatでのセンサデータの出力と圧縮、解凍、取得機能が備わっています。
データ圧縮には、121進数を用いた圧縮を用いています。

## What's new?
### Version 1.0
_SenbayDataFormatCompressorに、getVersionNumberメソッドを追加しました。本メソッドでは、Senbay形式の文字列を引数に与えることで、形式のバージョン(0-4)を返します。_

## Coding


## License


## Test code
`SenbayFormat.xcodeproj`をダブルクリックして、Xcodeでプロジェクトを開いて下さい。

`main.m`には、以下のサンプルコードを記述しています。

* 121進数でのEncode, Decode
* 5種類のSenbay形式でのEncode, Decode
* SensorDataManagerを用いたセンサデータの取得


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

2. SenbayDataFormatCompressor.hをインポートして下さい。

`#import "SenbayDataFormatCompressor.h"` 


## Links
* [Yuuki NISHIYAMA](http://www.ht.sfc.keio.ac.jp/~tetujin "Yuuki NISHIYAMA")
* [Takuro YONEZAWA](http://www.ht.sfc.keio.ac.jp/~takuro "Takuro YONEZAWA")
* [Tokuda Laboratory](http://www.ht.sfc.keio.ac.jp "Tokuda Laboratory")
* [Senbay Offical Webpage](http://www.senbay.info "Senbay")
* [Senbay App Store](http://www "App Store")
* [Senbay Reader App Store](http://www "App Store")


## Reference
