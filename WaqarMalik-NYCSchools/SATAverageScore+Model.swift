//
//  SATScores+Model.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation
import SODA

extension SATAverageScore {
	var formattedReadingScore: String {
		criticalReadingScore.formatted(.number)
	}

	var formattedMathScore: String {
		mathScore.formatted(.number)
	}

	var formattedWritingScore: String {
		writingScore.formatted(.number)
	}
}

extension SATAverageScore {
	var chartData: [ChartData] {
		[ChartData(title: NSLocalizedString("NYC_CRITICAL_READING", comment: "Critical Reading"), value: Double(criticalReadingScore)),
		 ChartData(title: NSLocalizedString("NYC_MATH", comment: "Math"), value: Double(mathScore)),
		 ChartData(title: NSLocalizedString("NYC_WRITING", comment: "Writing"), value: Double(writingScore))]
	}
}
