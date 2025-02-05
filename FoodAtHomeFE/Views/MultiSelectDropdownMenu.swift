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

    // Compute the list of options from the dataManager's pantry.
    var options: [String] {
        dataManager.pantry.map { $0.ingredient }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // The dropdown button shows the selected options (or a placeholder).
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
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            // When expanded, display a scrollable list of pantry items.
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
                            .contentShape(Rectangle()) // makes the entire row tappable
                            .onTapGesture {
                                if selectedOptions.contains(option) {
                                    selectedOptions.remove(option)
                                } else {
                                    selectedOptions.insert(option)
                                }
                            }
                            
                            // Add a divider between rows except for the last row.
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
        // Fetch the pantry items when this view appears.
        .task {
            await dataManager.fetchPantry()
        }
    }
}





//import SwiftUI
//
//
//struct MultiSelectDropdownMenu: View {
//    @Environment(DataManager.self) var dataManager: DataManager
//    @State private var isExpanded = false
//    @State private var selectedOptions: Set<String> = []
//    var options: [String] {
//            dataManager.pantry.map { $0.ingredient }
//        }
//    
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Button(action: { isExpanded.toggle() }) {
//                HStack {
//                    Text(selectedOptions.isEmpty ? "Select Options" : selectedOptions.joined(separator: ", "))
//                    Spacer()
//                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                }
//                .padding()
//                .background(Color.blue.opacity(0.1))
//                .cornerRadius(8)
//            }
//            
//            if isExpanded {
//                VStack {
//                    ScrollView(.vertical, showsIndicators: true) {
//                        ForEach(options, id: \.self) { option in
//                            HStack {
//                                Text(option)
//                                Spacer()
//                                if selectedOptions.contains(option) {
//                                    Image(systemName: "checkmark")
//                                }
//                            }
//                            .padding()
//                            .onTapGesture {
//                                if selectedOptions.contains(option) {
//                                    selectedOptions.remove(option)
//                                } else {
//                                    selectedOptions.insert(option)
//                                    print(selectedOptions)
//                                }
//                            }
//                        }
//                    }
//                }
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(radius: 5)
//                .frame(maxHeight: 200)
//            }
//        }
//        .padding()
//    }
//}
//#Preview {
//    MultiSelectDropdownMenu()
//}

//struct SearchableDropdownMenu: View {
//    @Environment(DataManager.self) var dataManager: DataManager
//    @State private var isExpanded = false
//    @State private var selectedOption: String? = nil  // Now a String
//    @State private var searchText = ""
//
//    // filteredOptions returns an array of Strings (the ingredient names)
//    var filteredOptions: [String] {
//        if searchText.isEmpty {
//            return dataManager.pantry.map { $0.ingredient }
//        } else {
//            return dataManager.pantry
//                .filter { $0.ingredient.lowercased().contains(searchText.lowercased()) }
//                .map { $0.ingredient }
//        }
//    }
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            // Dropdown button
//            Button(action: {
//                withAnimation {
//                    isExpanded.toggle()
//                }
//            }) {
//                HStack {
//                    Text(selectedOption ?? "Select an Option")
//                        .foregroundColor(.primary)
//                    Spacer()
//                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//            }
//            .padding(.horizontal)
//
//            // Dropdown list
//            if isExpanded {
//                VStack {
//                    // Search field
//                    TextField("Search...", text: $searchText)
//                        .padding(8)
//                        .background(Color(.systemGray5))
//                        .cornerRadius(8)
//                        .padding([.horizontal, .top])
//
//                    // List of filtered options
//                    ScrollView {
//                        ForEach(filteredOptions, id: \.self) { option in
//                            Button(action: {
//                                selectedOption = option  // option is now a String
//                                withAnimation {
//                                    isExpanded = false
//                                }
//                                searchText = ""
//                            }) {
//                                Text(option)
//                                    .foregroundColor(.primary)
//                                    .padding(.vertical, 8)
//                                    .padding(.horizontal)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                            Divider()
//                        }
//                    }
//                    .frame(maxHeight: 200)
//                }
//                .background(Color(.systemBackground))
//                .cornerRadius(8)
//                .shadow(radius: 4)
//                .padding(.horizontal)
//            }
//        }
//    }
//}
//
//
////struct SearchableDropdownMenu: View {
////    @Environment(DataManager.self) var dataManager: DataManager
////    @State private var isExpanded = false
//////    @State private var selectedOption = "Select an Option"
////    @State private var selectedOption: Ingredient? = nil
////
//////    @Bindable var selectedOption: Ingredient? = nil
////    @State private var searchText = ""
////
////
////    var filteredOptions: [String] {
////        if searchText.isEmpty {
////            // Map the entire pantry array to a list of ingredient names.
////            return dataManager.pantry.map { $0.ingredient }
////        } else {
////            // Filter based on the search text, then map to ingredient names.
////            return dataManager.pantry
////                .filter { $0.ingredient.lowercased().contains(searchText.lowercased()) }
////                .map { $0.ingredient }
////        }
////    }
////
////    var body: some View {
////            VStack(alignment: .leading) {
////                // Dropdown button
////                Button(action: {
////                    withAnimation {
////                        isExpanded.toggle()
////                    }
////                }) {
////                    HStack {
////                        Text(selectedOption?.ingredient ?? "Select an Option")
////                            .foregroundColor(.primary)
////                        Spacer()
////                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
////                            .foregroundColor(.gray)
////                    }
////                    .padding()
////                    .background(Color(.systemGray6))
////                    .cornerRadius(8)
////                }
////                .padding(.horizontal)
////
////                // Dropdown list
////                if isExpanded {
////                    VStack {
////                        // Search field
////                        TextField("Search...", text: $searchText)
////                            .padding(8)
////                            .background(Color(.systemGray5))
////                            .cornerRadius(8)
////                            .padding([.horizontal, .top])
////
////                        // List of filtered options
////                        ScrollView {
////                            ForEach(filteredOptions, id: \.self) { option in
////                                Button(action: {
////                                    selectedOption = option
////                                    withAnimation {
////                                        isExpanded = false
////                                    }
////                                    searchText = ""
////                                }) {
////                                    Text(option)
////                                        .foregroundColor(.primary)
////                                        .padding(.vertical, 8)
////                                        .padding(.horizontal)
////                                        .frame(maxWidth: .infinity, alignment: .leading)
////                                }
////                                Divider()
////                            }
////                        }
////                        .frame(maxHeight: 200)
////                    }
////                    .background(Color(.systemBackground))
////                    .cornerRadius(8)
////                    .shadow(radius: 4)
////                    .padding(.horizontal)
////                }
////            }
////        }
////    }
