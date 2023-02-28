//
//  QRCodeView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/26/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView<T: Encodable>: View {
    let data: T
    
    var body: some View {
        Image(uiImage: generateQRCode(from: data))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
    }
    
    private func generateQRCode(from data: T) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        let data = try! JSONEncoder().encode(data)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            return UIImage(ciImage: outputImage)
        } else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
    }
}
