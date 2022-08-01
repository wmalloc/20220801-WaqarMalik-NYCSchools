//
//  SwiftUIView.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import SwiftUI

struct VerticalBarChart: View {
	@EnvironmentObject var viewModel: VerticalBarChartViewModel
	@State private var touchLocation: CGFloat = -1

	var body: some View {
		VStack(alignment: .leading) {
			Text(viewModel.title)
				.bold()
				.font(.title2)
            if !viewModel.subtitle.isEmpty {
                Text(viewModel.subtitle)
                    .font(.headline)
                    .foregroundColor(Color("nyc_gold"))
            }
			Divider()
			Text(NSLocalizedString("CHART_SELECTED_SCORE", comment: "Selected Score:") + " \(viewModel.currentValue)")
				.font(.headline)
                .opacity(!viewModel.data.isEmpty ? 1.0 : 0.0)
			GeometryReader { geometry in
				VStack {
					HStack {
						ForEach(0 ..< viewModel.dataCount, id: \.self) { index in
							VerticalBarView(value: viewModel.normalizedValue(index: index), color: barColor(index: index))
								.scaleEffect(scaleEffect(index: index), anchor: .bottom)
                                .animation(.spring())
								.padding(.top)
						}
					}
					.gesture(DragGesture(minimumDistance: 0)
						.onChanged { position in
							let touchPosition = position.location.x / geometry.frame(in: .local).width
							touchLocation = touchPosition
							viewModel.updateCurrentValue(touchLocation: touchLocation)
						}
						.onEnded { _ in
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
								withAnimation(Animation.easeOut(duration: 0.5)) {
									resetValues()
								}
							}
						}
					)
					if viewModel.currentLabel.isEmpty {
						Text(viewModel.legend)
							.bold()
							.foregroundColor(.black)
							.padding(5)
							.background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                            .opacity(!viewModel.data.isEmpty ? 1.0 : 0.0)
					} else {
						Text(viewModel.currentLabel)
							.bold()
							.foregroundColor(.black)
							.padding(5)
							.background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
							.offset(x: labelOffset(in: geometry.frame(in: .local).width))
                            .animation(.easeIn)
                            .opacity(!viewModel.data.isEmpty ? 1.0 : 0.0)
					}
				}
			}
		}
		.padding()
	}

    func barColor(index: Int) -> Color {
        barIsTouched(index: index) ? viewModel.selectedBarColor: viewModel.barColor
    }
    
    func scaleEffect(index: Int) -> CGSize {
        barIsTouched(index: index) ? CGSize(width: 1.05, height: 1) : CGSize(width: 1, height: 1)
    }
    
	func barIsTouched(index: Int) -> Bool {
		guard viewModel.dataCount > 0 else {
			return false
		}
		return touchLocation > CGFloat(index) / CGFloat(viewModel.dataCount) && touchLocation < CGFloat(index + 1) / CGFloat(viewModel.dataCount)
	}

	func resetValues() {
		touchLocation = -1
		viewModel.resetValues()
	}

	func labelOffset(in width: CGFloat) -> CGFloat {
		let currentIndex = Int(touchLocation * CGFloat(viewModel.dataCount))
		guard currentIndex < viewModel.dataCount, currentIndex >= 0 else {
			return 0
		}
		let cellWidth = width / CGFloat(viewModel.dataCount)
		let actualWidth = width - cellWidth
		let position = cellWidth * CGFloat(currentIndex) - actualWidth / 2
		return position
	}
}

struct VerticalBarChart_Previews: PreviewProvider {
	static var previews: some View {
		VerticalBarChart()
			.environmentObject(SchoolDetailView_Previews.viewModel.chartViewModel)
	}
}
