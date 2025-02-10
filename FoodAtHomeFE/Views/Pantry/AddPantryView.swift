//
//  AddPantryView.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/10/25.
//

import SwiftUI
//
struct AddPantryView: View {
    @Binding var pantryItem: String
    @Binding var expirationDate: Date?  // Change to optional
    let onSave: () -> Void
    
    @State private var showDatePicker = false
    
    var body: some View {
        VStack {
            TextField("Enter pantry item", text: $pantryItem)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            HStack {
                Text("Expiration Date:")
                Spacer()
                if let expirationDate = expirationDate {
                    Text("\(expirationDate, formatter: dateFormatter)")
                } else {
                    Text("None")
                }
                Button(action: { showDatePicker.toggle() }) {
                    Image(systemName: "calendar")
                }
            }
            .padding()
            
            if showDatePicker {
                DatePicker(
                    "Select Date",
                    selection: Binding(
                        get: { expirationDate ?? Date() },
                        set: { expirationDate = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                
                Button("Clear Date") {
                    expirationDate = nil
                }
            }
            
            Button("Save", action: onSave)
                .buttonStyle(SaveButtonStyle())
        }
        .padding()
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
