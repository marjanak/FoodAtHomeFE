//
//  OneRecipeView.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/3/25.
//


import SwiftUI

struct MultiSelectDropdownMenu: View {
    @Environment(DataManager.self) var dataManager: DataManager
    @Binding var selectedOptions: Set<String>
    @State private var isExpanded = false

    var options: [String] {
        dataManager.pantry.map { $0.ingredient }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedOptions.isEmpty ? "Select Options" : selectedOptions.joined(separator: ", "))
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            
            if isExpanded {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            HStack {
                                Text(option)
                                Spacer()
                                if selectedOptions.contains(option) {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedOptions.contains(option) {
                                    selectedOptions.remove(option)
                                } else {
                                    selectedOptions.insert(option)
                                }
                            }
                            
                            if option != options.last {
                                Divider()
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            }
        }
        .padding()
        .task {
            await dataManager.fetchPantry()
        }
    }
}
