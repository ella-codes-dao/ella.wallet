//
//  TokenBalanceCardView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/27/23.
//

import SwiftUI

struct TokenBalanceCardView: View {
    @State var token: SupportedToken
    @State var amount: Double
    @State var value: Double
    
    var body: some View {
        HStack {
            Image(token.image)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(token.name)
                Text(String(format: "$%.3f", value))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(String(format: "%.3f", amount)) \(token.symbol)")
                Text(String(format: "$%.3f", amount * value))
            }
        }
    }
}
