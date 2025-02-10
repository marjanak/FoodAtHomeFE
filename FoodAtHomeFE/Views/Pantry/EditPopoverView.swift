//
//  editPopoverView.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/10/25.
//

import SwiftUI

struct EditPopoverView: View {
    @Binding var expirationDate: Date
    let onUpdate: () -> Void
    
    var body: some View {
        VStack {
            Text("Update Expiration Date")
                .font(.headline)
                .padding()
            
            DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                .padding()
            
            Button("Update") {
                onUpdate()
            }
            .buttonStyle(SaveButtonStyle())
        }
        .padding()
    }
}

#Preview {
    EditPopoverView(
        expirationDate: .constant(Date()),
        onUpdate: {}
    )
}
