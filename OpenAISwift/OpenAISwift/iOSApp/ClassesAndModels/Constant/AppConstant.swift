//
//  AppConstant.swift
//  OpenAISwift
//
//  Created by Meet Patel on 17/01/2023.
//

import Foundation
import UIKit

let APPDEL = UIApplication.shared.delegate as! AppDelegate

struct Constant {
    
    public static let kAppName = "OpenAISwift"
}

struct OpenAISecretKey {
    
    public static let SECRETKEY = "SET SECRET KEY"
}

extension UIViewController {
    
    func showAlertWithOkButton(message: String, _ completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: Constant.kAppName, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            completion?()
        }
        alert.addAction(OKAction)
        
        self.present(vc: alert)
    }
    func showAlertWithTwoButtons(message: String, btn1Name: String, btn2Name: String, completion: @escaping ((_ btnClickedIndex: Int) -> Void)) {
        
        let alert = UIAlertController(title: Constant.kAppName, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: btn1Name, style: .default) { (action1) in
            completion(1)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: btn2Name, style: .default) { (action2) in
            completion(2)
        }
        alert.addAction(action2)
        self.present(vc: alert)
    }
    private func present(vc: UIViewController) {
    
        if let nav = self.navigationController {
            if let presentedVC = nav.presentedViewController {
                presentedVC.present(vc, animated: true, completion: nil)
            } else {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func ProgressShow() {
        
        if #available(iOS 13.0, *) {
            ProgressHUD.show()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func ProgressHide() {
        
        if #available(iOS 13.0, *) {
            ProgressHUD.dismiss()
        } else {
            // Fallback on earlier versions
        }
    }
}

extension String {
    
    func trime() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func width(withConstrainedHeigh height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}

extension UIView {
    
    func setCornerRaius(corners: UIRectCorner, radious: CGFloat) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radious, height: radious))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UITextField {
    
    func isempty() -> Bool {
        return (self.text ?? "").trime().isEmpty
    }
    func trimText() -> String {
        return (self.text ?? "").trime()
    }
    
    func getUpadatedText(string: String, range: NSRange) -> String {
        
        let text = self.text!
        let textRange = Range(range, in: text)!
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        return updatedText
    }
}

extension Date {
    
    func toStringWith(formate: String) -> String {
        
        let dtformatter = DateFormatter()
        dtformatter.dateFormat = formate
        return dtformatter.string(from: self)
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon) ?? Date()
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon) ?? Date()
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    static func getCurrentDateTime(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}

extension UITextField {
    
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}