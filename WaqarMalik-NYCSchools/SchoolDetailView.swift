//
//  SchoolDetailView.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import SODA
import SwiftUI
import TTProgressHUD

struct SchoolDetailView: View {
	@EnvironmentObject var viewModel: SchoolViewModel
	@Environment(\.presentationMode) var presentation
	@State var hudConfiguration = TTProgressHUDConfig()

	var body: some View {
		ZStack {
			VerticalBarChart()
				.environmentObject(viewModel.chartViewModel)
                .navigationTitle(NSLocalizedString("NYC_SCORES", comment: "Scores"))
                .navigationBarTitleDisplayMode(.inline)
				.opacity(viewModel.showChartView ? 1.0 : 0.0)
			TTProgressHUD($viewModel.isShowingHUD, config: hudConfiguration)
		}
		.alert(isPresented: $viewModel.isErrorPresented) {
			Alert(title: Text(NSLocalizedString("NYC_ERROR", comment: "Error")),
			      message: Text(viewModel.error?.localizedDescription ?? "Unknown Error"),
			      dismissButton: .default(Text(NSLocalizedString("NYC_OK", comment: "OK"))) {
			      	self.presentation.wrappedValue.dismiss()
			      })
		}
		.onAppear {
			viewModel.fetchScores()
		}
	}
}

struct SchoolDetailView_Previews: PreviewProvider {
	static var score: SATAverageScore {
		let url = Bundle.main.url(forResource: "score", withExtension: "json")
		let data = try? Data(contentsOf: url!)
		let score = try? JSONDecoder().decode(SATAverageScore.self, from: data!)
		return score!
	}

	static var viewModel: SchoolViewModel {
		let viewModel = SchoolViewModel(school: SchoolListItem_Previews.school)
		viewModel.score = score
		return viewModel
	}

	static var previews: some View {
		SchoolDetailView()
			.environmentObject(viewModel)
	}
}
