//
//  VerticalBarView.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import SwiftUI

struct VerticalBarView: View {
	var value: Double
	var color: Color

	var body: some View {
		RoundedRectangle(cornerRadius: 5)
			.fill(color)
			.scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
	}
}

struct VerticalBarView_Previews: PreviewProvider {
	static var previews: some View {
        VerticalBarView(value: 200, color: Color("nyc_gold"))
			.previewLayout(.sizeThatFits)
	}
}
