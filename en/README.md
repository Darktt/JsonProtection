# JsonProtection  
[![Swift-6.0](https://img.shields.io/badge/Swift-6.0-red.svg?style=plastic&logo=Swift&logoColor=white&link=)](https://developer.apple.com/swift/)
[![example workflow](https://github.com/Darktt/JsonProtection/actions/workflows/main.yml/badge.svg)]()

A solution for handling and protecting the parsing of various unusual JSON data provided by the backend.

## Installation  

Using Swift Package Manager:  

1. Go to **File > Swift Packages > Add Package Dependency**  
2. Add `https://github.com/Darktt/JsonProtection`  
3. Select **"Up to Next Major"** with version **"1.2.1"**  

## Features  

### BoolProtection  
Handles the issue where JSON data should be **Boolean**, but in reality, it is not a **Boolean**.  

```json
{
    "true": true,
    "false": "FALSE"
}
```

Apply `@BoolProtection` to properties that need to be parsed as `Bool` type for type protection:

```swift
struct BoolObject: Decodable
{
    @BoolProtection
    var `true`: Bool?
    
    @BoolProtection
    var `false`: Bool?
}
```

> Supported values (case-insensitive for strings):  
> - **true:** `1`, `"true"`, `"yes"`  
> - **false:** `0`, `"false"`, `"no"`  

---

### MissingKeyProtection  
Protects against cases where JSON keys are sometimes missing.

```json
Normal case:
{
    "data": {
        "name": "Some one",
        "age": 11
    }
}

Error case:
{
    "error": "Missing data"
}
```

When parsing, apply `@MissingKeyProtection` to ensure the property does not cause parsing failures:

```swift
struct DataObject: Decodable
{
    @MissingKeyProtection
    var name: String?
    
    @MissingKeyProtection
    var age: Int?
}
```

---

### NumberProtection  
Handles JSON values that should be **numbers** but are actually **strings**.

```json
{
    "price": "100",
    "discount": "10.5"
}
```

Use `@NumberProtection` for automatic conversion:

```swift
struct Product: Decodable
{
    @NumberProtection
    var price: Double?
    
    @NumberProtection
    var discount: Double?
}
```

> Supported types: 
> * Int
> * Float
> * Double
> * Decimal
> * And enum with `RawValue` type of Int, Float, Double, Decimal
    (Needs to conform to `NumberType` protocol)

---

### NumbersProtection  
Handles cases where **numeric values array** in JSON may be stored as **strings array** or incorrect formats.
```json
{
    "index": ["10", "20", "50", "100"]
}
```

Use `@NumbersProtection` to ensure the values are correctly converted:

```swift
struct Library: Decodable
{
    @NumbersProtection
    var index: [Int]?
}
```

> Supported types:
> * Same as `NumberProtection`

----

### NumberArrayProtection
Handles cases where **numeric array** in JSON may be stored as **string** or incorrect formats.

```json
{
    "dices": "[1, 5.2, 1.0]"
}
```

Use `@NumberArrayProtection` to ensure the values are correctly converted:

```swift
struct NumberArray: Decodable
{
    @NumberArrayProtection
    var dices: [Double]?
}
```

> Supported types:
> * Same as `NumberProtection`

----

### ObjectProtection
Handles cases where **JSON object** is stored as a **string**.

```json
{
    "data": "{\"name\":\"Some one\",\"age\":11}"
}
```

Use `@ObjectProtection` to ensure the value is correctly converted:

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

### DateProtection  
Handles cases where **date values** in JSON are stored as **strings** or **UNIX timestamps**.

```json
{
    "updateTime": 1694102400,
    "expiredDate": "202309080100"
}
```

Use `@DateProtection` to ensure correct parsing:

```swift
struct DateObject: Decodable
{
    let updateTime: Date?
    
    @DateProtection(configuration: DateConfiguration.self)
    private(set)
    var expiredDate: Date?
}
```

And set the `DateConfiguration` for the date format:

```swift
sextension DateObject
{
    struct DateConfiguration: DateConfigurate
    {
        static var option: DateConfigurateOption {
            
            .dateFormat("yyyyMMddhhss", timeZone: TimeZone(abbreviation: "GMT+0800"))
        }
    }
}
```

> Options:
> * `dateFormat`: Date format string, and time zone.
> * `secondsSince1970`: Convert the value to a time interval.
> * `millisecondsSince1970`: Convert the value to a time interval in milliseconds.
> * `iso8601`: Convert the value to an ISO8601 date format.

> Supported types:
> * Strings
> * Any numeric type

---

### UIImageProtection
Converts **strings** in JSON to `UIImage` type.
> ⚠️: The project must contain the same name image files.

---

### URLProtection
Avoids parsing failures when JSON data contains **Empty string**.

```json
{
    "homePageUrl": "https://www.google.com",
    "detailPageUrl": ""
}
```

Use `@URLProtection` to ensure the URL is correctly parsed:
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

### AESDecoder
This feature is used to decode the data that has been encrypted with AES.

Use `AESAdopter` to provide the decryption information:
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

Then use `@AESDecoder` to decode the data:
```swift
struct AESObject: Decodable
{
    @AESDecoder(adopter: AESAdopting.self)
    var url: String?
}
```

> Supported types:
> * Strings
> * Strings array

## Author
Created by Darktt.

## License  

This project is licensed under the MIT License.
