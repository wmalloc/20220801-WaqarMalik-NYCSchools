//
//  SchoolListItem.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/30/22.
//

import SODA
import SwiftUI

struct SchoolListItem: View {
	@EnvironmentObject var viewModel: SchoolViewModel

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(viewModel.name)
				.fontWeight(.medium)
				.multilineTextAlignment(.leading)
			HStack(spacing: 16) {
				Text(NSLocalizedString("NYC_TOTAL_STUDENTS", comment: "Total Students"))
					.foregroundColor(Color.gray)
				Spacer()
				Text(viewModel.numberOfTestTakers)
					.fontWeight(.bold)
			}
		}
	}
}

struct SchoolListItem_Previews: PreviewProvider {
	static var school: School {
		let url = Bundle.main.url(forResource: "school", withExtension: "json")
		let data = try? Data(contentsOf: url!)
		let school = try? JSONDecoder().decode(School.self, from: data!)
		return school!
	}

	static var viewModel: SchoolViewModel {
		SchoolViewModel(school: school)
	}

	static var previews: some View {
		SchoolListItem()
			.environmentObject(viewModel)
	}
}
