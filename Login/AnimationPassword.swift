//
//  AnimationPassword.swift
//  Login
//
//  Created by Dima on 1/29/21.
//  Copyright © 2021 Dima. All rights reserved.
//

 import SwiftUI
struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}
