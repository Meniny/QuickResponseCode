//
//  QuickResponseCode.swift
//  QuickResponseCode
//
//  Created by Meniny on 25/01/15.
//  Copyright (c) 2015 Meniny. All rights reserved.
//

import UIKit

/// QuickResponseCode(QRCode) generator
open class QuickResponseCode {
    
    open static var defaultCanvasSize: CGSize = CGSize(width: 200, height: 200)
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    public enum ErrorCorrectionLevel: String {
        /// 7%
        case low = "L"
        /// 15%
        case medium = "M"
        /// 25%
        case quartile = "Q"
        /// 30%
        case high = "H"
    }
    
    open let string: String
    
    /// Foreground color of the output
    /// Defaults to black
    open var foregroundColor: UIColor// = CIColor(red: 0, green: 0, blue: 0)
    
    /// Background color of the output
    /// Defaults to white
    open var backgroundColor: UIColor// = CIColor(red: 1, green: 1, blue: 1)
    
    /// Size of the output
    open var size: CGSize
    
    /// The error correction. The default value is `.Low`.
    open var errorCorrection: QuickResponseCode.ErrorCorrectionLevel// = .low
    
    public init(string source: String,
                 size s: CGSize = QuickResponseCode.defaultCanvasSize,
                 foreground: UIColor = .black,
                 background: UIColor = .white,
                 correction level: QRCodeErrorCorrectionLevel = .low) {
        string = source
        size = s
        foregroundColor = foreground
        backgroundColor = background
        errorCorrection = level
    }
    
    open class func generate(string source: String,
                             size s: CGSize = QuickResponseCode.defaultCanvasSize,
                             foreground: UIColor = .black,
                             background: UIColor = .white,
                             correction level: QRCodeErrorCorrectionLevel = .low) -> QuickResponseCode {
        return QuickResponseCode(string: source, size: s, foreground: foreground, background: background, correction: level)
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's CIImage representation
    open var ciImage: CIImage? {
        return CIImage.QRCodeImage(string: string, foreground: foregroundColor, background: backgroundColor, correction: errorCorrection)
    }
    
    /// The QRCode's UIImage representation
    open var image: UIImage? {
        if let ci = ciImage {
            return UIImage.from(ciImage: ci, size: size)
        }
        return nil
    }
    
    /// The QRCode's UIImage representation with centerd icon
    open func iconedImage(_ icon: UIImage, radius: CGFloat = 5) -> UIImage? {
        guard let img = image else {
            return nil
        }
        return UIImage.drawIcon(icon, radius: radius, atCenterOfQRCode: img)
    }
    
    open func detectMessages() -> [String] {
        return QuickResponseCode.detectMessages(from: image)
    }
    
    open class func detectMessages(from image: UIImage?) -> [String] {
        if let img = image {
            return img.QRCodeMessages
        }
        return []
    }
    
}

public typealias QRCode = QuickResponseCode
public typealias QRCodeErrorCorrectionLevel = QRCode.ErrorCorrectionLevel

extension UIImage {
    /// Create UIImage from CIImage with specific size
    ///
    /// - Parameters:
    ///   - source: CIImage
    ///   - canvasSize: size
    /// - Returns: UIImage
    public static func from(ciImage source: CIImage, size canvasSize: CGSize) -> UIImage? {
        // Size
        let ciImageSize = source.extent.size
        let widthRatio = canvasSize.width / ciImageSize.width
        let heightRatio = canvasSize.height / ciImageSize.height
        
        guard let cgImg = CIContext(options: nil).createCGImage(source, from: source.extent) else {
            return nil
        }
        
        // Creates an `UIImage` with interpolation disabled and scaled given a scale property
        
        let contextSize = CGSize(width: source.extent.size.width * widthRatio,
                                 height: source.extent.size.height * heightRatio)
        
        UIGraphicsBeginImageContextWithOptions(contextSize, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.interpolationQuality = .none
        context.translateBy(x: 0, y: contextSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImg, in: context.boundingBoxOfClipPath)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

extension UIImage {
    /// Detect QRCode Message Strings
    ///
    /// - Returns: Message Strings
    open var QRCodeMessages: [String] {
        var results = [String]()
        guard let cgImage = self.cgImage else {
            return results
        }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {
            return results
        }
        for f in detector.features(in: ciImage) {
            if let str = (f as? CIQRCodeFeature)?.messageString {
                results.append(str)
            }
        }
        return results
    }
    
    /// Draw an icon at the center of QRCode image
    ///
    /// - Parameters:
    ///   - icon: UIImage
    ///   - radius: Corner radius
    /// - Returns: return the orangnal image if failed, otherwise the new image
    public static func drawIcon(_ icon: UIImage, radius: CGFloat = 5, atCenterOfQRCode qrcode: UIImage) -> UIImage {
        // 绘制
        UIGraphicsBeginImageContext(qrcode.size)
        qrcode.draw(in: CGRect(x: 0, y: 0, width: qrcode.size.width, height: qrcode.size.height))
        guard let con = UIGraphicsGetCurrentContext() else {
            return qrcode
        }
        con.setFillColor(UIColor.white.cgColor)
        con.beginPath()
        // icon区域尺寸
        let length = qrcode.size.width * 0.250
        let rect = CGRect(x: (qrcode.size.width - length) * 0.50,
                          y: (qrcode.size.height - length) * 0.50,
                          width: length,
                          height: length)
        
        // 移动到初始点
        con.move(to: CGPoint(x: radius + rect.origin.x, y: rect.origin.y))
        
        // 绘制第1条线和第1个1/4圆弧
        con.addLine(to: CGPoint(x: rect.size.width - radius + rect.origin.x, y: rect.origin.y))
        con.addArc(center: CGPoint(x: rect.size.width - radius + rect.origin.x, y: radius + rect.origin.y),
                   radius: radius,
                   startAngle: -0.50 * CGFloat.pi,
                   endAngle: 0,
                   clockwise: false)
        
        // 绘制第2条线和第2个1/4圆弧
        con.addLine(to: CGPoint(x: rect.size.width + rect.origin.x, y: rect.size.height - radius + rect.origin.y))
        con.addArc(center: CGPoint(x: rect.size.width - radius + rect.origin.x, y: rect.size.height - radius + rect.origin.y),
                   radius: radius,
                   startAngle: 0,
                   endAngle: 0.50 * CGFloat.pi,
                   clockwise: false);
        
        // 绘制第3条线和第3个1/4圆弧
        con.addLine(to: CGPoint(x: radius + rect.origin.x, y: rect.size.height + rect.origin.y))
        con.addArc(center: CGPoint(x: radius + rect.origin.x, y: rect.size.height - radius + rect.origin.y),
                    radius: radius,
                    startAngle: 0.50 * CGFloat.pi,
                    endAngle: CGFloat.pi,
                    clockwise: false)
        
        // 绘制第4条线和第4个1/4圆弧
        con.addLine(to: CGPoint(x: rect.origin.x, y: radius + rect.origin.y))
        con.addArc(center: CGPoint(x: radius + rect.origin.x, y: radius + rect.origin.y),
                   radius: radius,
                   startAngle: CGFloat.pi,
                   endAngle: 1.50 * CGFloat.pi,
                   clockwise: false)
        
        // 闭合路径
        con.closePath();
        // 填充
        con.setFillColor(UIColor.white.cgColor)
        con.drawPath(using: .fill)
        
        // 添加icon
        
        icon.draw(in: CGRect(x: rect.origin.x + radius,
                             y: rect.origin.y + radius,
                             width: rect.size.width - radius * 2,
                             height: rect.size.height - radius * 2))
        // 最终图片
        let final = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return final ?? qrcode
    }
}

extension CIImage {
    /// Generate QRCode CIImage
    ///
    /// - Parameters:
    ///   - string: Source string
    ///   - foregroundColor: Foreground color
    ///   - backgroundColor: Background color
    ///   - level: Error correction level
    /// - Returns: CIImage
    public static func QRCodeImage(string: String,
                                   foreground foregroundColor: UIColor = .black,
                                   background backgroundColor: UIColor = .white,
                                   correction level: QRCodeErrorCorrectionLevel = .low) -> CIImage? {
        guard let stringData = string.data(using: .isoLatin1) else {
            return nil
        }
        // Generate QRCode
        guard let QRFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        QRFilter.setDefaults()
        QRFilter.setValue(stringData, forKey: "inputMessage")
        QRFilter.setValue(level.rawValue, forKey: "inputCorrectionLevel")
        
        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else {
            return nil
        }
        
        colorFilter.setDefaults()
        colorFilter.setValue(QRFilter.outputImage, forKey: "inputImage")
        let fci = CIColor(color: foregroundColor) //foregroundColor.ciColor
        let bci = CIColor(color: backgroundColor) //backgroundColor.ciColor
        colorFilter.setValue(fci, forKey: "inputColor0")
        colorFilter.setValue(bci, forKey: "inputColor1")
        
        return colorFilter.outputImage
    }
}

extension String {
    /// Generate QRCode UIImage
    ///
    /// - Parameters:
    ///   - size: Image size
    ///   - foregroundColor: Foreground color
    ///   - backgroundColor: Background color
    ///   - level: Error correction level
    /// - Returns: UIImage
    public func QRCodeImage(size: CGSize = QuickResponseCode.defaultCanvasSize,
                            foreground foregroundColor: UIColor = .black,
                            background backgroundColor: UIColor = .white,
                            correction level: QRCodeErrorCorrectionLevel = .low) -> UIImage? {
        return QuickResponseCode(string: self,
                                 size: size,
                                 foreground: foregroundColor,
                                 background: backgroundColor,
                                 correction: level).image
    }
}

extension UIImage {
    /// Generate QRCode UIImage
    ///
    /// - Parameters:
    ///   - string: Source string
    ///   - foregroundColor: Foreground color
    ///   - backgroundColor: Background color
    ///   - level: Error correction level
    /// - Returns: UIImage
    public static func QRCodeImage(from string: String,
                                   size: CGSize = QuickResponseCode.defaultCanvasSize,
                                   foreground foregroundColor: UIColor = .black,
                                   background backgroundColor: UIColor = .white,
                                   correction level: QRCodeErrorCorrectionLevel = .low) -> UIImage? {
        return QuickResponseCode(string: string,
                                 size: size,
                                 foreground: foregroundColor,
                                 background: backgroundColor,
                                 correction: level).image
    }
}
