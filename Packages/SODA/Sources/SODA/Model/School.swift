//
//  School.swift
//
//
//  Created by Waqar Malik on 7/29/22.
//

import CoreLocation
import Foundation

public struct School: Codable, Hashable, Identifiable {
	public let dbn: String
	public let schoolName: String?
	public let boro: String?
	public let overview: String?
	public let neighborhood: String?
	public let campusName: String?
	public let phoneNumber: String?
	public let faxNumber: String?
	public let email: String?
	public let website: String?
	public let studentCount: Int?
	public let address: String?
	public let city: String?
	public let stateCode: String?
	public let zipCode: String?
	public let nta: String?
	public let borough: String?

	public var id: String {
		dbn
	}

	let latitude: CLLocationDegrees
	let longitude: CLLocationDegrees

	private enum CodingKeys: String, CodingKey {
		case dbn
		case schoolName = "school_name"
		case boro
		case overview = "overview_paragraph"
		case neighborhood
		case campusName = "campus_name"
		case phoneNumber = "phone_number"
		case faxNumber = "fax_number"
		case email = "school_email"
		case website
		case studentCount = "total_students"
		case address = "primary_address_line_1"
		case city
		case stateCode = "state_code"
		case zipCode = "zip"
		case nta
		case borough
		case latitude
		case longitude
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.dbn = try container.decode(String.self, forKey: .dbn)
		self.schoolName = try container.decodeIfPresent(String.self, forKey: .schoolName)
		self.boro = try container.decodeIfPresent(String.self, forKey: .boro)
		self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
		self.neighborhood = try container.decodeIfPresent(String.self, forKey: .neighborhood)
		self.campusName = try container.decodeIfPresent(String.self, forKey: .campusName)
		self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
		self.faxNumber = try container.decodeIfPresent(String.self, forKey: .faxNumber)
		self.email = try container.decodeIfPresent(String.self, forKey: .email)
		self.website = try container.decodeIfPresent(String.self, forKey: .website)
		if let studentCountString = try container.decodeIfPresent(String.self, forKey: .studentCount) {
			self.studentCount = Int(studentCountString)
		} else {
			self.studentCount = nil
		}
		self.address = try container.decodeIfPresent(String.self, forKey: .address)
		self.city = try container.decodeIfPresent(String.self, forKey: .city)
		self.stateCode = try container.decodeIfPresent(String.self, forKey: .stateCode)
		self.zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
		self.nta = try container.decodeIfPresent(String.self, forKey: .nta)?.trimmingCharacters(in: .whitespacesAndNewlines)
		self.borough = try container.decodeIfPresent(String.self, forKey: .borough)?.trimmingCharacters(in: .whitespacesAndNewlines)
		if let latitudeString = try container.decodeIfPresent(String.self, forKey: .latitude) {
			self.latitude = CLLocationDegrees(latitudeString) ?? 0.0
		} else {
			self.latitude = 0.0
		}
		if let longitudeString = try container.decodeIfPresent(String.self, forKey: .longitude) {
			self.longitude = CLLocationDegrees(longitudeString) ?? 0.0
		} else {
			self.longitude = 0.0
		}
	}
}

public extension School {
	var location: CLLocation {
		CLLocation(latitude: latitude, longitude: longitude)
	}
}
