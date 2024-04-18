//
//  GalaxyStatsView.swift
//  Helldivers Companion
//
//  Created by James Poole on 28/03/2024.
//

import SwiftUI
#if os(iOS)
import SwiftUIIntrospect
#endif

struct GalaxyStatsView: View {
    
    @EnvironmentObject var viewModel: PlanetsViewModel
    @EnvironmentObject var navPather: NavigationPather
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $navPather.navigationPath) {
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    
              
                    #if os(iOS)
                    if searchText.isEmpty {
                        Section {
                            
                            GalaxyInfoView(galaxyStats: viewModel.galaxyStats, showIlluminate: viewModel.configData.showIlluminate)
                        }
                        
                        .id(0)
                    }
                    #endif
                    
                    
                    
                    // displays the planets grouped by sector
                    
                        // this isnt technically ordered, but it doesnt matter because index of 0 will be marked for the statistics at the top, so if scroll position has any value then bring us back to 0 at the top :-)
                    ForEach(viewModel.updatedSortedSectors.indices, id: \.self) { index in
                        
                     
                        
                        
                        let sector = viewModel.updatedSortedSectors[index]
                        let planets = viewModel.updatedGroupedBySectorPlanets[sector] ?? []
                        let filteredPlanets = planets.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
                        let isSectorMatch = sector.localizedCaseInsensitiveContains(searchText)
                     
                        // show all planets when no search term, show only search matching planets when there is and their respective sector heading
                        
                        if searchText.isEmpty || isSectorMatch || !filteredPlanets.isEmpty {
                        Section{
                            
                            ForEach(isSectorMatch ? planets : filteredPlanets, id: \.index) { planet in
                                
                                
                                NavigationLink(value: planet.index) {
                                    PlanetInfoDetailRow(planet: planet)
                                }.padding(.vertical, 8)
                                
                            }
                            
                            
                        } header: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(sector) Sector").font(Font.custom("FSSinclair-Bold", size: largeFont))
                                RoundedRectangle(cornerRadius: 25).frame(width: 250, height: 2)         .padding(.bottom, 4)
                            }.padding(.top)
                            
                        }.id(index + 1)
                        
                    }
                        
                    }
                    
                    
                    
                    
                }.padding(.horizontal)
                
                Spacer(minLength: 150)
                
                
                  //  .scrollTargetLayout()
                
            }//.scrollPosition(id: $navPather.scrollPosition)
            

            
            
#if os(iOS)
            // searching only on ios
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Planets").disableAutocorrection(true)

            // overlay conflicts with searchable
             /*   .overlay(
                    FactionImageView(faction: .human)

                        .padding(.trailing, 20)
                        .offset(x: 0, y: -45)
                    , alignment: .topTrailing)*/
            
            .background {
                if viewModel.darkMode {
                    Color.black.ignoresSafeArea()
                } else {
                    Image("BackgroundImage").blur(radius: 10).ignoresSafeArea()
                }
            }
            
                .inlineLargeTitleiOS17()
#endif
            
                .navigationTitle("Galaxy Statistics".uppercased())
            
                .navigationDestination(for: Int.self) { index in
                    PlanetInfoView(planetIndex: index)
                }
            
                .toolbar {
#if os(iOS)
                    
                    
              
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        FactionImageView(faction: "human")
                    }
                    
#endif
                }
            
            
            
        }
        
        
        
#if os(iOS)
        .introspect(.navigationStack, on: .iOS(.v16, .v17)) { controller in
            print("I am introspecting!")
            
            
            let largeFontSize: CGFloat = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
            let inlineFontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize
            
            // default to sf system font
            let largeFont = UIFont(name: "FSSinclair-Bold", size: largeFontSize) ?? UIFont.systemFont(ofSize: largeFontSize, weight: .bold)
            let inlineFont = UIFont(name: "FSSinclair-Bold", size: inlineFontSize) ?? UIFont.systemFont(ofSize: inlineFontSize, weight: .bold)
            
            
            let largeAttributes: [NSAttributedString.Key: Any] = [
                .font: largeFont
            ]
            
            let inlineAttributes: [NSAttributedString.Key: Any] = [
                .font: inlineFont
            ]
            
            controller.navigationBar.titleTextAttributes = inlineAttributes
            
            controller.navigationBar.largeTitleTextAttributes = largeAttributes
            
            
            
        }
        
#endif
        
        
    }
}

#Preview {
    GalaxyStatsView().environmentObject(PlanetsViewModel()).environmentObject(NavigationPather())
}

