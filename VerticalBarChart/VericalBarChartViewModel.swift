//
//  File.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation
import SwiftUI

public class VerticalBarChartViewModel: ObservableObject {
	@Published public var title: String = ""
    @Published public var subtitle: String = ""
	@Published public var legend: String = ""
	@Published public var barColor: Color = Color("nyc_blue")
    @Published public var selectedBarColor = Color("nyc_gold")
	@Published var data: [ChartData] = []

	@Published var currentValue = ""
	@Published var currentLabel = ""

	var dataCount: Int {
		data.count
	}

	func resetValues() {
		currentLabel = ""
		currentValue = ""
	}

	func normalizedValue(index: Int) -> Double {
		let allValues = data.map(\.value)
		guard let max = allValues.max() else {
			return 1
		}
		if max != 0 {
			return Double(data[index].value) / Double(max)
		} else {
			return 1
		}
	}

	func updateCurrentValue(touchLocation: CGFloat) {
		let index = Int(touchLocation * CGFloat(data.count))
		guard index < data.count, index >= 0 else {
			currentValue = ""
			currentLabel = ""
			return
		}
		currentValue = data[index].value.formatted(.number)
		currentLabel = data[index].title
	}
}
