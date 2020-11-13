//
//  Currency.swift
//  swiftUI_study2_project01
//
//  Created by 최인정 on 2020/11/12.
//
import Foundation

struct Currency {
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 3
        formatter.currencySymbol = ""
        
        return formatter
    }
    
}

//
//import SwiftUI
//
//struct Currency: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct Currency_Previews: PreviewProvider {
//    static var previews: some View {
//        Currency()
//    }
//}
