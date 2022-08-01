//
//  ContentView.swift
//  WaqarMalik-NYCSchools
//
//  Created by Waqar Malik on 7/29/22.
//

import SODA
import SwiftUI
import TTProgressHUD

struct SchoolListView: View {
	@EnvironmentObject var viewModel: SchoolListViewModel
	@State var hudConfiguration = TTProgressHUDConfig()
    @State private var searchString: String = ""
    
	var body: some View {
		NavigationView {
			ZStack {
				List(viewModel.schools(matching: searchString)) { school in
					NavigationLink(destination: SchoolDetailView().environmentObject(school)) {
						SchoolListItem()
							.environmentObject(school)
					}
				}
				.listStyle(.plain)
                .searchable(text: $searchString, prompt: "NYC_SEARCH_SCHOOL_NAME")
                .refreshable {
                    viewModel.refreshData()
                }
				TTProgressHUD($viewModel.isShowingHUD, config: hudConfiguration)
			}
			.navigationTitle(viewModel.title)
			.onAppear {
                if !viewModel.haveData {
                    viewModel.fetchSchools()
                }
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var schools: [School] {
		let url = Bundle.main.url(forResource: "schools", withExtension: "json")
		let data = try? Data(contentsOf: url!)
		let school = try? JSONDecoder().decode([School].self, from: data!)
		return school!
	}

	static var viewModel: SchoolListViewModel {
		let viewModel = SchoolListViewModel()
		viewModel.schools = schools.map { school in
			SchoolViewModel(school: school)
		}
		return viewModel
	}

	static var previews: some View {
		SchoolListView()
			.environmentObject(viewModel)
	}
}
