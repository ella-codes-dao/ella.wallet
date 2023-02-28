//
//  SendCryptoView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/27/23.
//

import SwiftUI

enum SendCryptoViewSelector: String, CaseIterable {
    case recent = "Recent"
    case addressBook = "Address Book"
}

struct SendCryptoView: View {
    @State var searchBarText = ""
    @State var selectedView: SendCryptoViewSelector = .recent
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "arrow.left")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 22.0, height: 22.0)
                .padding(.bottom, 20)
            
            Text("Send To")
                .font(.title)
            
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22.0, height: 22.0)
                    .foregroundColor(.walletPrimary)
                
                TextField("Search Bar", text: $searchBarText, prompt: Text("address(0x), or Find name"))
                
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22.0, height: 22.0)
                    .foregroundColor(.walletPrimary)
            }
            .padding(5)
            .backgroundStyle(Color.lightBackground)
            
            Picker("", selection: $selectedView) {
                ForEach(SendCryptoViewSelector.allCases, id: \.self) { view in
                    SendCryptoPickerView(selectedView: view)
                }
            }.pickerStyle(.segmented)
            
            Spacer()
            
            VStack(alignment: .center) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 122.0, height: 122.0)
                    .foregroundColor(.walletPrimary)
                    .padding(.bottom, 10)
                
                Text("Search by Find Name or enter an address")
            }
            
            Spacer()
        }
    }
}

struct SendCryptoPickerView: View {
    @State var selectedView: SendCryptoViewSelector
    
    var body: some View {
        Group {
            switch selectedView {
            case .recent:
                VStack {
//                    Image(systemName: "clock.fill")
//                        .resizable()
//                        .renderingMode(.template)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 44.0, height: 44.0)
//                        .foregroundColor(.walletPrimary)
                    Text(selectedView.rawValue)
                }
            case .addressBook:
                VStack {
//                    Image(systemName: "number.circle.fill")
//                        .resizable()
//                        .renderingMode(.template)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 44.0, height: 44.0)
//                        .foregroundColor(.walletPrimary)
                    Text(selectedView.rawValue)
                }
            }
        }
    }
}
