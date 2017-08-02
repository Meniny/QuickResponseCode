//
//  ViewController.swift
//  Sample
//
//  Created by Meniny on 2017-08-02.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit
import QuickResponseCode

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func generate(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
        let qr = QRCode(string: textView.text,
                        size: imageView.bounds.size,
                        foreground: UIColor.random,
                        background: UIColor.random,
                        correction: .low)
        imageView.image = qr.iconedImage(#imageLiteral(resourceName: "icon"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

public extension UIColor {
    public static var random: UIColor {
        let m: UInt32 = 255
        let r = CGFloat(arc4random_uniform(m))
        let g = CGFloat(arc4random_uniform(m))
        let b = CGFloat(arc4random_uniform(m))
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}
