//
//  View.swift
//  MyLockedDiary
//
//  Created by apple on 03.08.2024.
//

import SwiftUI

import SwiftUI

extension View {
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    var halfScreenWidth: CGFloat {
        screenWidth / 2
    }

    var thirdScreenWidth: CGFloat {
        screenWidth / 3
    }

    var quarterScreenWidth: CGFloat {
        screenWidth / 4
    }

    var halfScreenHeight: CGFloat {
        screenHeight / 2
    }

    var thirdScreenHeight: CGFloat {
        screenHeight / 3
    }

    var quarterScreenHeight: CGFloat {
        screenHeight / 4
    }
}

