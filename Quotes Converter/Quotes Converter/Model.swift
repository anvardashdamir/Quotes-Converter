//
//  Model.swift
//  Quotes Converter
//
//  Created by Enver Dashdemirov on 12.10.24.
//

import UIKit
import Foundation

struct Currency: Decodable {
    let code: String
    let en: String
    let az: String
    let ru: String
    let tr: String
}

struct CurrencyRate: Decodable {
    let from: String
    let to: String
    let result: Double
    let date: String
    let menbe: String
}

typealias CurrencyList = [Currency]
typealias CurrencyRates = [CurrencyRate]
