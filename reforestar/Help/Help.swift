//
//  Help.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 12/07/2021.
//

import Foundation
import SwiftUI
import Firebase

extension Color {
    
    static let light_beish = Color("Color1")
    static let light_green = Color("Color2")
    static let dark_green = Color("Color3")
    static let sucess = Color("Color4")
    static let white_gray = Color("Color5")
    static let red_error = Color("Color6")
    static let yellow_warning = Color("Color7")
    static let blue_info = Color("Color8")
    
    
}

class Help {
    
    public static let height_screen = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(30.0) : CGFloat(50.0)
    public static let width_screen = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(70.0) : CGFloat(175.0)
    
    public static let height_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(55.0) : CGFloat(72.0)
    public static let width_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(55.0) : CGFloat(72.0)
    
    public static let border_padding = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(5.0) : CGFloat(15.0)
    
}

extension String {
    
    func isGoodPassword() -> Bool {
        return stringFulfillsRegex(regex: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
    }
    
    func isAnEmail() -> Bool {
        return stringFulfillsRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    func hasCharacters() -> Bool {
        return stringFulfillsRegex(regex: "[A-Z0-9a-z]+")
    }
    
    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
    
}

