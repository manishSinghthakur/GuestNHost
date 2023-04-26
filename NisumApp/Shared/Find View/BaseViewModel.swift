//
//  BaseViewModel.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 11/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import SwiftUI

enum LoadingState {
    case loading, success, failed, none
}

class BaseViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .none
}
