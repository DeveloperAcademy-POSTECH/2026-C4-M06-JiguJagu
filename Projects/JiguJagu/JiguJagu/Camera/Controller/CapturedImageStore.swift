//
//  CapturedImageStore.swift
//  JiguJagu
//
//  Created by SIA on 7/23/26.
//

import UIKit

final class CapturedImageStore {
    static let shared = CapturedImageStore()
    private init() {}

    private(set) var lastCutoutImage: UIImage?

    func store(_ image: UIImage?) {
        lastCutoutImage = image
    }

    func clear() {
        lastCutoutImage = nil
    }
}
