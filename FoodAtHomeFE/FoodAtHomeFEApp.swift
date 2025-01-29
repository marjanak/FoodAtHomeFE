//
//  FoodAtHomeFEApp.swift
//  FoodAtHomeFE
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

@main
struct FoodAtHomeFEApp: App {
    @State var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(dataManager)
        }
    }
}
