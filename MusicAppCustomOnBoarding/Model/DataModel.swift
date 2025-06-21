//
//  DataModel.swift
//  MusicAppCustomOnBoarding
//
//  Created by Hakob Ghlijyan on 20.06.2025.
//

import SwiftUI

struct DataModel: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var detail: String
    var video: String
}
