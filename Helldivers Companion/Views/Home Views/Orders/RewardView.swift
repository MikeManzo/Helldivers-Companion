//
//  RewardView.swift
//  Helldivers Companion
//
//  Created by James Poole on 21/03/2024.
//

import SwiftUI

struct RewardView: View {
    
    var rewardType: Int = 1
    var rewardValue: Int = 0
    
    var body: some View {
        VStack(spacing: 6) {
            Text("Reward").textCase(.uppercase).font(Font.custom("FS Sinclair", size: 18))
            
            HStack(spacing: 4) {
                
                if rewardType == 1 {
                    Image("medalSymbol").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                } else {
                    VStack(spacing: 2){
                        Text("R").font(Font.custom("FS Sinclair", size: smallFont)).padding(.horizontal, 4).foregroundStyle(Color.black).background(Color.yellow)
                        Rectangle().frame(width: 18, height: 4)
                            .foregroundStyle(Color.yellow)
                    }
                }
                
                Text("\(rewardValue)").font(Font.custom("FS Sinclair", size: 26))
                    .foregroundStyle(rewardType == 1 ? .white : .yellow)
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            // Use the custom shape as a pattern
            AngledLinesShape()
                .stroke(lineWidth: 3)
                .foregroundColor(.white) // or any color you prefer
                .opacity(0.2) // Adjust for desired line opacity
                .clipped() // Ensure the pattern does not extend beyond the view bounds
        )
        .padding(.horizontal, 20)
        
    }
    
    
    
}

#Preview {
    RewardView()
}