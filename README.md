
<p align="center">
  <img src="https://ooo.0o0.ooo/2017/08/02/5981c39c426e3.png" alt="QuickResponseCode">
  <br/><a href="https://cocoapods.org/pods/QuickResponseCode">
  <img alt="Version" src="https://img.shields.io/badge/version-1.1.0-brightgreen.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Meniny-blue.svg">
  <img alt="Build Passing" src="https://img.shields.io/badge/build-passing-brightgreen.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-3.0%2B-orange.svg">
  <br/>
  <img alt="Platforms" src="https://img.shields.io/badge/platform-iOS%20%7C%20tvOS-lightgrey.svg">
  <img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
  <br/>
  <img alt="Cocoapods" src="https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg">
  <img alt="Carthage" src="https://img.shields.io/badge/carthage-working%20on-red.svg">
  <img alt="SPM" src="https://img.shields.io/badge/swift%20package%20manager-working%20on-red.svg">
  </a>
</p>

## What's this?

`QuickResponseCode` is a tiny Quick Response Code (QRCode) library for iOS written in Swift.

## Requirements

* iOS 8.0+
* tvOS 9.0+
* Xcode 9 with Swift 4

## Installation

#### CocoaPods

```ruby
use_frameworks!
pod 'QuickResponseCode'
```

## Contribution

You are welcome to fork and submit pull requests.

## License

`QuickResponseCode` is open-sourced software, licensed under the `MIT` license.

## Usage

```swift
import QuickResponseCode

func generate() {
  let qr = QRCode(string: textView.text,
                        size: imageView.bounds.size,
                        foreground: UIColor.random,
                        background: UIColor.random,
                        correction: .low)
  let iconedimage = qr.iconedImage(#imageLiteral(resourceName: "icon"))
  let image = qr.image
}

func generate2() {
  let image = UIImage.QRCodeImage(from: textView.text,
                        size: imageView.bounds.size,
                        foreground: UIColor.random,
                        background: UIColor.random,
                        correction: .low)
}

func generate3() {
  let image = "SourceString".QRCodeImage(size: imageView.bounds.size,
                        foreground: UIColor.random,
                        background: UIColor.random,
                        correction: .low)
}
```
