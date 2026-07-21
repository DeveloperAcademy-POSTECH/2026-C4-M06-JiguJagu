//
//  ForegroundCutout.swift
//  JiguJagu
//
//  Created by SIA on 7/22/26.
//

import UIKit
import Vision
import CoreImage

// MARK: - Foreground Cutout

enum ForegroundCutout {
    static func extract(from image: UIImage) async -> UIImage? {
        
        guard let cgImage = image.cgImage else { return nil }
        let scale = image.scale
        
        return await Task.detached(priority: .userInitiated) {
            let request = VNGenerateForegroundInstanceMaskRequest()
            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
            
            do {
                try handler.perform([request])
                
                guard let observation = request.results?.first else {
                    return nil
                }
                
                let maskedBuffer = try observation.generateMaskedImage(
                    ofInstances: observation.allInstances,
                    from: handler,
                    croppedToInstancesExtent: false
                )
                
                let ciImage = CIImage(cvPixelBuffer: maskedBuffer)
                let context = CIContext()
                guard let outputCG = context.createCGImage(ciImage, from: ciImage.extent) else {
                    return nil
                }
                
                return UIImage(cgImage: outputCG, scale: scale, orientation: .up)
            } catch {
                return nil
            }
        }.value
    }
}

// MARK: - UIImage Orientation

extension UIImage {
    
    func normalizedUp() -> UIImage {
        guard imageOrientation != .up else { return self }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
