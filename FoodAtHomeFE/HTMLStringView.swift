//
//  HTMLStringView.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/3/25.
//

import WebKit
import SwiftUI


struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

//#Preview {
//    HTMLStringView()
//}
