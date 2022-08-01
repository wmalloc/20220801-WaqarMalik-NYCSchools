//
//  NYCResources.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import Foundation

public enum NYCResources: String, Hashable, CaseIterable {
	case schools = "s3k6-pzi2"
	case satScores = "f9bf-2cp4"
}

extension NYCResources: CustomStringConvertible {
	public var description: String {
		switch self {
		case .schools:
			return "Schools"
		case .satScores:
			return "SAT Scores"
		}
	}
}

extension NYCResources: CustomDebugStringConvertible {
	public var debugDescription: String {
		"""
		{
		   \(description) = \(rawValue)
		}
		"""
	}
}
