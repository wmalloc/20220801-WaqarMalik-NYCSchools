//
//  SchoolViewModel.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import Combine
import Foundation
import os.log
import SODA
import SwiftUI

class SchoolViewModel: ObservableObject, Identifiable {
	@Injected(\.sodaClient) var sodaClient: SODAClient
	@Published var isShowingHUD: Bool = false

	@Published var error: Error? {
		didSet {
			isErrorPresented = error != nil
		}
	}

	@Published var isErrorPresented: Bool = false

	let school: School
	@Published var score: SATAverageScore = .init() {
		didSet {
			let viewModel = VerticalBarChartViewModel()
			viewModel.title = name
            viewModel.subtitle = NSLocalizedString("NYC_NUMBER_OF_TEST_TAKERS", comment: "Number of test takers") + ": " + numberOfTestTakers
			viewModel.legend = NSLocalizedString("NYC_AVERAGE_SAT_SCORES", comment: "Average SAT Scores")
            viewModel.barColor = Color("nyc_blue")
			viewModel.data = score.chartData
			chartViewModel = viewModel
		}
	}

	@Published var chartViewModel: VerticalBarChartViewModel = .init()

	init(school: School) {
		self.school = school
	}

	var id: String {
		school.id
	}

	var name: String {
		school.schoolName ?? NSLocalizedString("NYC_UNKNOWN_SCHOOL", comment: "Unkown School")
	}

	var showChartView: Bool {
		!isShowingHUD
	}

	var numberOfTestTakers: String {
		school.studentCount?.formatted(.number) ?? "0"
	}

	func fetchScores() {
		Task.detached { [weak self] in
			guard let self = self else {
				return
			}
			await MainActor.run { [weak self] in
				self?.isShowingHUD = true
				self?.error = nil
			}
			do {
				let query = SODAQuery().filter(column: "dbn", value: self.school.id)
				let scores = try await self.sodaClient.scores(query: query)
				if let score = scores.first {
					await MainActor.run { [weak self] in
						self?.score = score
					}
				} else {
					throw SODAError.notFound("Unable to fetch SAT scores for school \(self.name)")
				}
			} catch {
				await MainActor.run { [weak self] in
					self?.error = error
				}
				os_log(.error, "Unable to fetch scores %@", error as NSError)
			}
			await MainActor.run { [weak self] in
				self?.isShowingHUD = false
			}
		}
	}
}
