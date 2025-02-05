//
//  HTMLStringView.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/3/25.
//

import SwiftUI
import WebKit

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let styledHTML = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: -apple-system, Helvetica, Arial, sans-serif;
                        font-size: 17px;
                        color: #000;
                        margin: 0;
                        padding: 0;
                    }
                </style>
            </head>
            <body>
                \(htmlContent)
            </body>
        </html>
        """
        uiView.loadHTMLString(styledHTML, baseURL: nil)
    }
}


//import WebKit
//import SwiftUI
//
//
//struct HTMLStringView: UIViewRepresentable {
//    let htmlContent: String
//
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.loadHTMLString(htmlContent, baseURL: nil)
//    }
//}

//#Preview {
//    HTMLStringView()
//}
