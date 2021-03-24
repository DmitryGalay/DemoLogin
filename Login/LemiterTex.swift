//
//  LemiterTex.swift
//  Login
//
//  Created by Dima on 1/29/21.
//  Copyright © 2021 Dima. All rights reserved.
//

import SwiftUI
class LimiterText:ObservableObject {
    private let limit : Int
    init(limit:Int){
        self.limit = limit
    }
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.isLimit = true
            } else {
                self.isLimit = false
            }
        }
    }
    @Published var isLimit: Bool = false
    
}
