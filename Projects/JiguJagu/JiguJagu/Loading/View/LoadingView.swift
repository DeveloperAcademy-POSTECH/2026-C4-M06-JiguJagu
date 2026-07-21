//
//  LoadingView.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var controller: LoadingController

    init(controller: LoadingController = LoadingController()) {
        _controller = State(initialValue: controller)
    }

    var body: some View {
        EmptyView()
    }
}

#Preview {
    LoadingView()
}
