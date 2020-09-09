//
//  UserData.swift
//  swiftUI_study02_injeong
//
//  Created by 최인정 on 2020/09/03.
//  Copyright © 2020 indoni. All rights reserved.
//



import SwiftUI
import Combine

final class UserData: ObservableObject  {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
    //@Published var showFeaturedOnly = false
}

//struct UserData_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
