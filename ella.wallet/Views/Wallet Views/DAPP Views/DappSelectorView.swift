//
//  DappSelectorView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import SwiftUI

struct DappSelectorView: View {
    var body: some View {
        List {
            Section("Integrated DAPPS") {
                IntegratedDappCardView(name: ".find", desc: "A place to find people and things on the Flow Blockchain", image: "find")
                IntegratedDappCardView(name: "FLOAT", desc: "A Flow-enabled proof of attendance platform built by Emerald DAO", image: "float")
            }
            
            Section("Web Based DAPPS") {
                Text("Coming Soon!")
            }
        }.listStyle(.plain)
    }
}

struct DappSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        DappSelectorView()
    }
}
