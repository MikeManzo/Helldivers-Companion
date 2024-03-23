//
//  OrderView.swift
//  Helldivers Companion
//
//  Created by James Poole on 16/03/2024.
//

import SwiftUI

struct OrderView: View {
    
    @EnvironmentObject var viewModel: PlanetsViewModel
    
    
    var body: some View {
        
   
        VStack(spacing: 12) {
                
            VStack(spacing: 12) {
                Text(viewModel.majorOrder?.setting.taskDescription ?? "Stand by.").font(Font.custom("FS Sinclair", size: 24))
                    .foregroundStyle(Color.yellow).textCase(.uppercase)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.majorOrder?.setting.overrideBrief ?? "Await further orders from Super Earth High Command.").font(Font.custom("FS Sinclair", size: 18))
                    .foregroundStyle(Color.cyan)
                    .padding(5)
                
                if !viewModel.taskPlanets.isEmpty {
                    TasksView(taskPlanets: viewModel.taskPlanets)
                }
                
                
            }.frame(maxHeight: .infinity)
            if let majorOrderRewardValue = viewModel.majorOrder?.setting.reward.amount, majorOrderRewardValue > 0 {
                RewardView(rewardType: viewModel.majorOrder?.setting.reward.type, rewardValue: majorOrderRewardValue)
            }
            
            if let majorOrderTimeRemaining = viewModel.majorOrder?.expiresIn,  majorOrderTimeRemaining > 0 {
                MajorOrderTimeView(timeRemaining: majorOrderTimeRemaining)
            }
            
            }  .frame(maxWidth: .infinity) .padding()  .background {
                Color.black
            }
          //  .padding(.horizontal)
          
            .border(Color.white)
            .padding(4)
            .border(Color.gray)
     
        
        
    }
}

#Preview {
    OrderView().environmentObject(PlanetsViewModel())
}


struct TasksView: View {
    
    var taskPlanets: [PlanetStatus]
    
    var isWidget = false
    
    let columns = [
           GridItem(.flexible(maximum: 150)),
           GridItem(.flexible(maximum: 150)),
       ]
    
    var nameSize: CGFloat {
        return isWidget ? 14 : mediumFont
    }
    
    var boxSize: CGFloat {
        return isWidget ? 7 : 10
    }
    
    var body: some View {
        
        
        LazyVGrid(columns: columns) {
            ForEach(taskPlanets, id: \.self) { planetStatus in
                
         
                    HStack {
                        Rectangle().frame(width: boxSize, height: boxSize).foregroundStyle(planetStatus.liberation == 100 ? Color.yellow : Color.black)
                            .border(planetStatus.liberation == 100 ? Color.black : Color.yellow)
                        Text(planetStatus.planet.name).font(Font.custom("FS Sinclair", size: nameSize))
                    }
                              
                
                
                
                
            }
            
        }
        
    }
}
