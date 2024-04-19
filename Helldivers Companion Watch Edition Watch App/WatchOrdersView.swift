//
//  WatchOrdersView.swift
//  Helldivers Companion Watch Edition Watch App
//
//  Created by James Poole on 21/03/2024.
//

import SwiftUI

struct WatchOrdersView: View {
    
    @EnvironmentObject var viewModel: PlanetsViewModel
    
    var body: some View {
        NavigationStack {

            ScrollView {
                VStack(spacing: 12) {
                    Text(viewModel.majorOrder?.setting.taskDescription ?? "Stand by.").bold()
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(Font.custom("FSSinclair", size: 18))
                        .foregroundStyle(.yellow)
                    
                    Text(viewModel.majorOrder?.setting.overrideBrief ?? "Await further orders from Super Earth High Command.").bold()
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(Font.custom("FSSinclair", size: 16))

                    if !viewModel.updatedTaskPlanets.isEmpty {
                        TasksView(taskPlanets: viewModel.updatedTaskPlanets)
                    } else if let isEradication = viewModel.majorOrder?.isEradicateType, let eradicationProgress = viewModel.majorOrder?.eradicationProgress, let barColor = viewModel.majorOrder?.faction.color, let progressString = viewModel.majorOrder?.progressString {
                        
                        
                        // eradicate campaign
                        ZStack {
                            RectangleProgressBar(value: eradicationProgress, primaryColor: .cyan, secondaryColor: barColor)
                                .frame(height: 16)
                            
                            Text("\(progressString)").font(Font.custom("FSSinclair", size: 10)).foregroundStyle(.black)
                            
                            
                        }.padding(.bottom, 10)
                            .padding(.horizontal, 14)
                    }
                    
                }.frame(maxHeight: .infinity)
                if let majorOrderRewardValue = viewModel.majorOrder?.setting.reward.amount, majorOrderRewardValue > 0 {
                    RewardView(rewardType: viewModel.majorOrder?.setting.reward.type, rewardValue: majorOrderRewardValue)
                    
                }
                
                if let majorOrderTimeRemaining = viewModel.majorOrder?.expiresIn,  majorOrderTimeRemaining > 0 {
                    MajorOrderTimeView(timeRemaining: majorOrderTimeRemaining)
                }
                
                
                Spacer()
            }.scrollContentBackground(.hidden)
            

            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("MAJOR ORDER").textCase(.uppercase)  .font(Font.custom("FSSinclair-Bold", size: largeFont))
                }
            }
       
            
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    WatchOrdersView()
}
