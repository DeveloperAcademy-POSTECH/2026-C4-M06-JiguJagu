//
//  RegisterProductInputState.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import Foundation

struct RegisterProductInputState: Equatable {
    var productName: String = ""
    var brandName: String = ""

    var trimmedProductName: String {
        productName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedBrandName: String {
        brandName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var hasProductName: Bool {
        !trimmedProductName.isEmpty
    }
}
