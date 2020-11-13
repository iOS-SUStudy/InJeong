//
//  ContentView.swift
//  swiftUI_study2_project01
//
//  Created by 최인정 on 2020/11/12.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmountString: String = ""
    @State private var numberOfPeopleString = ""
    @State private var tipPercentage = TipPercentageChoice.zero
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Initial check amount")) {
                    TextField("Number of Satoshis", text: $checkAmountString).keyboardType(.numberPad)
                }
                Section(header: Text("Number of people")) {
                    TextField("Number of Satoshis", text: $numberOfPeopleString).keyboardType(.numberPad)
                }
                
                Section(header: Text("How much would you like to tip")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(TipPercentageChoice.allCases, id: \.self) { percentage in
                        Text("\(percentage.rawValue)%")
                    }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                if formattedAmountPerPerson != nil && totalCost > 0 {
                    Section(header: HStack{
                        Spacer()
                        Text("Your Splict")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding(.top, 48.0)
                            .padding(.bottom, 8.0)
                        Spacer()
                    },
                    footer:
                        Text("Total including tip:")
                            .fontWeight(.bold)
                        + Text(" \(formattedTotalCost) Satoshis")
                    ){
                        Text("\(formattedAmountPerPerson!) Satoshis")
                    }
                }
                
            } .navigationBarTitle("WeSplit", displayMode: .large)
        }
    }
}

extension ContentView {
    
    private var checkAmount: Double { Double(checkAmountString) ?? 0 }
    // 섹션 1에서 입력받는 값
    private var numberOfPeople: Int { Int(numberOfPeopleString) ?? 0 }
    // 섹션 2에서 입력받는 값
    
    private var totalCost: Double {
        checkAmount
            + (checkAmount * (Double(tipPercentage.rawValue) / 100.0))
    }// 섹션 3에서 선택한 tipPercentage value에 따라 totalCost 변수 값 변경, 섹션 4 footer의 값 결정
    
    
    private var amountPerPerson: Double? {
        guard numberOfPeople > 0 else { return nil } //섹션 2에서 입력받는 값 활용
        
        return totalCost / Double(numberOfPeople)
    }
    
    // 섹션 4의 결과값
    private var formattedAmountPerPerson: String? {
        guard let amountPerPerson = amountPerPerson else { return nil }
        
        return Currency.formatter.string(from: amountPerPerson as NSNumber)
    }
    
    // 섹션 4의 footer 값
    private var formattedTotalCost: String {
        Currency.formatter.string(from: totalCost as NSNumber) ?? ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
