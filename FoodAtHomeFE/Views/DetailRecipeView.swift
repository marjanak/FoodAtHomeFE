//
//  DetailRecipeView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI

struct DetailRecipeView: View {
    var recipeName: String
    
    var body: some View {
        VStack {
            Text(recipeName)
            Text("Placeholder for description")
            Text("Placeholder for other data?")
        }
    }
}

#Preview {
    DetailRecipeView(recipeName: "Check all windows")
}
