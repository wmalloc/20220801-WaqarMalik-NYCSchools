import CoreLocation
import Foundation
import os.log
@testable import SODA
import XCTest

final class SODATests: XCTestCase {
	func testAllSchools() throws {
		guard let url = Bundle.module.url(forResource: NYCResources.schools.rawValue, withExtension: "json", subdirectory: "TestData") else {
			throw URLError(.fileDoesNotExist)
		}
		let data = try Data(contentsOf: url)
		let schools = try JSONDecoder().decode([School].self, from: data)
		XCTAssertNotEqual(schools.count, 0)
		XCTAssertEqual(schools.count, 440)
	}

	func testSchool() throws {
		guard let url = Bundle.module.url(forResource: "school", withExtension: "json", subdirectory: "TestData") else {
			throw URLError(.fileDoesNotExist)
		}
		let data = try Data(contentsOf: url)

		let school = try JSONDecoder().decode(School.self, from: data)
		XCTAssertEqual(school.dbn, "02M260")
		XCTAssertEqual(school.boro, "M")
		XCTAssertEqual(school.email, "admissions@theclintonschool.net")
		XCTAssertEqual(school.website, "www.theclintonschool.net")
		XCTAssertEqual(school.studentCount, 376)
		XCTAssertEqual(school.borough, "MANHATTAN")
		XCTAssertEqual(school.nta, "Hudson Yards-Chelsea-Flatiron-Union Square")
		XCTAssertEqual(school.latitude, 40.73653)
		XCTAssertEqual(school.longitude, -73.9927)
		XCTAssertEqual(school.location.coordinate.latitude, 40.73653)
		XCTAssertEqual(school.location.coordinate.longitude, -73.9927)
	}

	func testErrorResponse() throws {
		guard let url = Bundle.module.url(forResource: "errorResponse", withExtension: "json", subdirectory: "TestData") else {
			throw URLError(.fileDoesNotExist)
		}

		let data = try Data(contentsOf: url)
		let errorObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
		XCTAssertNotNil(errorObject)
		let error = SODAError(dictionary: errorObject!)
		XCTAssertNotNil(error)
		let nsError = error! as NSError
		let description = nsError.localizedDescription
		XCTAssertEqual(description, "Could not parse SoQL query \"select * where string_column > 42\"")
	}

	func testAllScores() throws {
		guard let url = Bundle.module.url(forResource: NYCResources.satScores.rawValue, withExtension: "json", subdirectory: "TestData") else {
			throw URLError(.fileDoesNotExist)
		}
		let data = try Data(contentsOf: url)
		let scores = try JSONDecoder().decode([SATAverageScore].self, from: data)
		XCTAssertNotEqual(scores.count, 0)
		XCTAssertEqual(scores.count, 478)

		let score = scores.first
		XCTAssertNotNil(score)
		XCTAssertEqual(score?.dbn, "01M292")
		XCTAssertEqual(score?.schoolName, "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES")
		XCTAssertEqual(score?.numberOfTestTakers, 29)
		XCTAssertEqual(score?.criticalReadingScore, 355)
		XCTAssertEqual(score?.mathScore, 404)
		XCTAssertEqual(score?.writingScore, 363)
	}

	func testQuery() throws {
		var query = SODAQuery(rawValue: [:])
		XCTAssertNotNil(query)
		query = query!.limit(10)
		XCTAssertEqual(query?.rawValue.count, 1)
		XCTAssertEqual(query?["$limit"], "10")

		query = query!.offset(100)
		XCTAssertEqual(query?.rawValue.count, 2)
		XCTAssertEqual(query?["$offset"], "100")

		query = query!.filter(column: "dbn", value: "01M292")
		XCTAssertEqual(query?.rawValue.count, 3)
		XCTAssertEqual(query?["dbn"], "01M292")

		query = query!.order(column: "dbn", by: .ascending)
		XCTAssertEqual(query?.rawValue.count, 4)
		XCTAssertEqual(query?["$order"], "dbn ASC")

		let queryItems = query?.urlQueryItems
		XCTAssertEqual(queryItems?.count, query?.count)
	}
}
