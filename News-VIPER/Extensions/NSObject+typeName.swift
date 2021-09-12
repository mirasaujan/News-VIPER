//
//  NSObject+typeName.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Foundation

extension NSObject {
    /// Название класса в виде строки
    @objc public static var typeName: String {
        return String(describing: self)
    }
}
