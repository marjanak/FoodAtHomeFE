//
//  DetailView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI

struct DetailView: View {
    var name: String
    
    var body: some View {
        VStack {
            Text(name)
            Text("Placeholder for description")
            Text("Placeholder for other stuff")
        }
    }
}

#Preview {
    DetailView(name: "Check all windows")
}
