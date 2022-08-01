//
//  SATAverageScore.swift
//
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation

public struct SATAverageScore: Codable, Hashable, Identifiable {
	public let dbn: String
	public let schoolName: String?
	public let numberOfTestTakers: Int
	public let criticalReadingScore: Int
	public let mathScore: Int
	public let writingScore: Int

	public var id: String {
		dbn
	}

	public init(dbn: String = "", schoolName: String? = nil, numberOfTestTakers: Int = 0, criticalReadingScore: Int = 0, mathScore: Int = 0, writingScore: Int = 0) {
		self.dbn = dbn
		self.schoolName = schoolName
		self.numberOfTestTakers = numberOfTestTakers
		self.criticalReadingScore = criticalReadingScore
		self.mathScore = mathScore
		self.writingScore = writingScore
	}

	private enum CodingKeys: String, CodingKey {
		case dbn
		case schoolName = "school_name"
		case numberOfTestTakers = "num_of_sat_test_takers"
		case criticalReadingScore = "sat_critical_reading_avg_score"
		case mathScore = "sat_math_avg_score"
		case writingScore = "sat_writing_avg_score"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.dbn = try container.decode(String.self, forKey: .dbn)
		self.schoolName = try container.decodeIfPresent(String.self, forKey: .schoolName)
		var value = 0
		if let valueString = try container.decodeIfPresent(String.self, forKey: .numberOfTestTakers) {
			value = Int(valueString) ?? 0
		}
		self.numberOfTestTakers = value

		value = 0
		if let valueString = try container.decodeIfPresent(String.self, forKey: .criticalReadingScore) {
			value = Int(valueString) ?? 0
		}
		self.criticalReadingScore = value

		value = 0
		if let valueString = try container.decodeIfPresent(String.self, forKey: .mathScore) {
			value = Int(valueString) ?? 0
		}
		self.mathScore = value

		value = 0
		if let valueString = try container.decodeIfPresent(String.self, forKey: .writingScore) {
			value = Int(valueString) ?? 0
		}
		self.writingScore = value
	}
}

extension SATAverageScore: CustomStringConvertible {
	public var description: String {
		"""
		{
		dbn = \(dbn)
		schoolName = \(String(describing: schoolName))
		numberOfTestTakers = \(numberOfTestTakers)
		criticalReadingScore = \(criticalReadingScore)
		mathScore = \(mathScore)
		writingScore = \(writingScore)
		}
		"""
	}
}

extension SATAverageScore: CustomDebugStringConvertible {
	public var debugDescription: String {
		"""
		{
		\(CodingKeys.dbn.rawValue) = \(dbn)
		\(CodingKeys.schoolName.rawValue) = \(String(describing: schoolName))
		\(CodingKeys.numberOfTestTakers.rawValue) = \(numberOfTestTakers)
		\(CodingKeys.criticalReadingScore.rawValue) = \(criticalReadingScore)
		\(CodingKeys.mathScore.rawValue) = \(mathScore)
		\(CodingKeys.writingScore.rawValue) = \(writingScore)
		}
		"""
	}
}
