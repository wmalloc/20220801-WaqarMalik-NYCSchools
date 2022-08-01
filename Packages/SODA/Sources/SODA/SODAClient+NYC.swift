//
//  SODAClient+NYC.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation

public extension SODAClient {
	func schools(query: SODAQuery?) async throws -> [School] {
		try await GET(resource: NYCResources.schools.rawValue, query: query)
	}

	func scores(query: SODAQuery?) async throws -> [SATAverageScore] {
		try await GET(resource: NYCResources.satScores.rawValue, query: query)
	}
}
