//
//  ExempleMatchHandler.swift
//  ios-app-color
//
//  Created by Wen on 09.03.18.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import Foundation
import AlpsSDK

class ExampleMatchHandler: MatchDelegate {
    var onMatch: OnMatchClosure?
    init(_ onMatch: @escaping OnMatchClosure) {
        self.onMatch = onMatch
    }
}

