//
//  WebDappCardView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import SwiftUI

struct WebDappCardView: View {
    @State var name: String
    @State var desc: String
    @State var image: String
    @State var url: String
    @State var showWebView: Bool = false
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 10) {
                Image(image)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.title3)
                    
                    Text(desc)
                        .font(.subheadline)
                        .lineLimit(2)
                }
                
                Image(systemName: "greaterthan.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 22, height: 22)
            }
//            .navigationDestination(isPresented: $showWebView) {
//                SwiftUIWebView(webview: WebViewModel(url))
//            }
        }
    }
}
