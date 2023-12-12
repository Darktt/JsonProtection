# JsonProtection
[![Swift-5.8](https://img.shields.io/badge/Swift-5.8-red.svg?style=plastic&logo=Swift&logoColor=white&link=)](https://developer.apple.com/swift/)
[![example workflow](https://github.com/Darktt/JsonProtection/actions/workflows/main.yml/badge.svg)]()

處理後端提供各種神奇 Json 資料，而做的解析保護

## 安裝方法

使用 Swift Package Manager：

* File > Swift Packages > Add Package Dependency
* Add https://github.com/Darktt/JsonProtection
* Select "Up to Next Major" with "1.0.5"

## 功能說明

### BoolProtection
處理 json 資料應該為**布林值**，但是實際上並**非布林值**的問題
```json
{
    "true": true,
    "false": "FALSE"
}
```

將要解析成 Bool 型態的 property 套上 `@BoolProtection` 進行型態保護
```swift
struct BoolObject: Decodable
{
    @BoolProtection
    var `true`: Bool?
    
    @BoolProtection
    var `false`: Bool?
}
```

> 支援型態（字串不分大小寫）：
> * true: 1、“true”、“yes”
> * false: 0、“false”、“no”

---
### MissingKeyProtection
保護 json key 時有時無的情況
```json
正常情況：
{
    "data": {
        "name": "Some one",
        "age": 11
    }
}

錯誤情況：
{
    "error": "token is expired."
}
```

將 key 可能消失的 property 加上 `@MissingKeyProtection` 進行保護
```swift
struct UserData: Decodable
{
    @MissingKeyProtection
    var data: UserInfo?

    @MissingKeyProtection
    var error: String?
}
```

----
### NumberProtection
處理 json 資料應該為**數字型態**，但是實際上可能為**字串型態**的問題
> 包含 MissingKeyProtection 的功能
```json
{
    "city": "高雄市",
    "lat": "22.78806",
    "lng": "120.24257"
}
```

將要解析成數字型態的 property 套上 `@NumberProtection` 進行型態保護
```swift
struct BikeLocation: Decodable
{
    var city: String?
    
    @NumberProtection
    var lat: CLLocationDegrees?
    
    @NumberProtection
    var lng: CLLocationDegrees?
}
```

> 支援的數字型態：
> * Int
> * Float
> * Double
> * Decimal
> * 含以上型態的列舉 
    eg: `enum Type: Int`
    (需套用 NumberType 這個 protocol)

---
## NumbersProtection
處理 json 資料應該為**數字陣列型態**，但是實際上可能為**字串陣列型態**的問題
```json
{
    "index": ["10", "20", "50", "100"]
}
```

將要解析成數字陣列型態的 property 套上 `@NumbersProtection` 進行型態保護
```swift
struct Library: Decodable
{
    @NumbersProtection
    var index: [Int]?
}
```

> 支援的數字型態：
> * 與 NumberProtection 相同
----
## ObjectProtection
處理 json 裡應為 jsonObject 資料，但實際上是 String 型態的問題
```json
{
    "num": 1,
    "sub": "{\"num\": 22}"
}
```

將要解析成物件的 property 套上 `@ObjectProtection` 進行型態保護
```swift
struct Info: Decodable
{
    var num: Int?
    
    @ObjectProtection
    var sub: Sub?
}

extension Info
{
    struct Sub: Decodable
    {
        var num: Int?
    }
}
```
---
## DateProtection
解決 json 資料裡的時間各式不統一的問題，
並且避免 json 資料型態不正確的問題
```json
{
    "updateTime": 1694102400,
    "expiredDate": "202309080100"
}
```

將要解析成日期陣列型態的 property 套上 `@DateProtection` 進行型態保護
```swift
struct DateObject: Decodable
{
    let updateTime: Date?
    
    @DateProtection(configuration: DateConfiguration.self)
    private(set)
    var expiredDate: Date?
}
```

並且繼承 DateConfigurate 提供相關設定
```swift
extension DateObject
{
    struct DateConfiguration: DateConfigurate
    {
        static var option: DateConfigurateOption {
            
            .dateFormat("yyyyMMddhhss", timeZone: TimeZone(abbreviation: "GMT+0800"))
        }
    }
}
```

> 設定選項：
> * 時間格式 (yyyyMMdd 等格式) 與時區
> * 時間戳（基本單位為秒（Second））
> * 時間戳（基本單位為毫秒（millisecond））
> * iso8601（是否有毫秒）

> 支援型態：
> * 字串
> * 任何數字型態

---
## UIImageProtection
將 json 裡的字串解析成為 UIImage 型態
> ⚠️：專案內需有同名的圖片檔案

---
## URLProtection
避免 json 裡的字串為空時，解析成 URL 型態會解析失敗的問題
```json
{
    "homePageUrl": "https://www.google.com",
    "detailPageUrl": ""
}
```

將要解析成 URL 的 property 套上 `@URLProtection` 進行型態保護
```swift
struct URLObject: Decodable
{
    private(set)
    var homePageUrl: URL?
    
    @URLProtection
    var detailPageUrl: URL?
}
```

---
## AESDecoder
這是唯一不做保護的功能，僅做解析 Json 資料時同時做 AES256 解密

使用需繼承 AESAdopter 提供相關解密資訊
```swift
struct AESAdopting: AESAdopter
{
    static var key: String {
        
        "MnoewgUZrgt5Rk08MtESwHvgzY7ElaEq"
    }
    
    static var iv: String? {
        
        "rtCG5mdgtlCtbyI4"
    }
    
    static var options: DTAES.Options {
        
        [.pkc7Padding, .zeroPadding]
    }
}
```

然後在需解密的 property 時加上 `@AESDecoder`，即可在完成解析後並且做解密的動作
```swift
struct AESObject: Decodable
{
    @AESDecoder(adopter: AESAdopting.self)
    var url: String?
}
```

---
## MultipleKeysProtection (未完成)
保護同變數在不同 json 資料情境下，有複數的 key 存在的問題
