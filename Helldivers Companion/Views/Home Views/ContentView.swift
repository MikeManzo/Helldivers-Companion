//
//  ContentView.swift
//  Helldivers Companion
//
//  Created by James Poole on 14/03/2024.
//

import SwiftUI
import UIKit
import StoreKit
#if os(iOS)
import SwiftUIIntrospect
#endif
import Haptics

struct ContentView: View {
    
    @EnvironmentObject var viewModel: PlanetsViewModel
    
    @EnvironmentObject var navPather: NavigationPather

    #if os(iOS)
    @Environment(\.requestReview) var requestReview
    #endif
    
    let appUrl = URL(string: "https://apps.apple.com/us/app/war-monitor-for-helldivers-2/id6479404407")
    
    var body: some View {
        
        NavigationStack(path: $navPather.navigationPath) {
            
            ScrollView {
                
                //     Text("Current war season: \(viewModel.currentSeason)")
                
                LazyVStack(spacing: 20) {
                    
                    if let alert = viewModel.configData.prominentAlert {
                        
                        AlertView(alert: alert)
                            .padding(.horizontal)
                    }
                    
                    
                    ForEach(Array(viewModel.updatedCampaigns.enumerated()), id: \.element) { (index, campaign) in
                        
                        UpdatedPlanetView(planetIndex: campaign.planet.index)
                            .id(index)
                            .padding(.horizontal)
                      
                    }
                    
                }
                #if os(iOS)
                .scrollTargetLayoutiOS17()
                #endif
                
                if let failedFetchTimeRemaining = viewModel.nextFetchTime {
                    VStack(spacing: 0) {
                        
                        Text("Failed to connect to Super Earth High Command. Retrying in:")
                            .opacity(0.5)
                            .foregroundStyle(.gray)
                            .font(Font.custom("FSSinclair", size: smallFont))
                            .multilineTextAlignment(.center)
                       
                        Text(failedFetchTimeRemaining, style: .timer)
                            .opacity(0.5)
                            .foregroundStyle(.gray)
                            .font(Font.custom("FSSinclair", size: largeFont))
                            .padding()
                        
                    }      .padding()
                }
                
                Text("Pull to Refresh").textCase(.uppercase)
                    .opacity(0.5)
                    .foregroundStyle(.gray)
                    .font(Font.custom("FSSinclair-Bold", size: smallFont))
                    .padding()
                
                
                Spacer(minLength: 30)
                
            } 
#if os(iOS)
            .scrollPositioniOS17($navPather.scrollPosition)
            #endif
            
            .scrollContentBackground(.hidden)
            
                .refreshable {
                    viewModel.refresh()
                }
            
            
                .sheet(isPresented: $viewModel.showInfo) {
                    
                    AboutView()
                    
                        .presentationDragIndicator(.visible)
                        .customSheetBackground(ultraThin: false)
                    
                }
            
#if os(iOS)
                .background {
                    if viewModel.darkMode {
                        Color.black.ignoresSafeArea()
                    } else {
                        Image("BackgroundImage").blur(radius: 10).ignoresSafeArea()
                    }
                }
#endif
            
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            viewModel.showInfo.toggle()
                        }){
                            Image(systemName: "gearshape.fill")
                        }.foregroundStyle(.white)
                            .bold()
                    }
                 /*   if let appUrl = appUrl {
                    ToolbarItem(placement: .topBarLeading) {
                        
                    
                            
                            ShareLink(item: appUrl) {
                                Image(systemName: "square.and.arrow.up.fill")
                            }
                            
                        }
                        
                    }*/
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        PlayerCountView().environmentObject(viewModel)
                    }
        
                    
                    
                    
                    
                    ToolbarItem(placement: .principal) {
                        Group {
                            Text("UPDATED: ")
                            + Text(viewModel.lastUpdatedDate, style: .relative)
                            + Text(" ago")
                        }
                        .font(Font.custom("FSSinclair", size: 20)).bold()
                        
                                .dynamicTypeSize(.small)
                        
                    }
                    
#endif
                    
#if os(watchOS)
                    ToolbarItem(placement: .topBarLeading) {
                        Text("WAR").textCase(.uppercase)  .font(Font.custom("FSSinclair", size: largeFont)).bold()
                    }
#endif
                    
                }
            
            
                .navigationBarTitleDisplayMode(.inline)
            
                .navigationDestination(for: Int.self) { index in
                    PlanetInfoView(planetIndex: index)
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
        
        
    
        .onAppear {
            viewModel.viewCount += 1
            
            if viewModel.viewCount == 3 {
                requestReview()
            }
        }
        #endif
        
    }
    
    
    
    
}


extension View {
    
    var isIpad: Bool {
#if !os(watchOS)
        UIDevice.current.userInterfaceIdiom == .pad
#else
        
        return false
        
#endif
    }
    
}


