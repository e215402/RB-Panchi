//
//  Explain.swift
//  BarrierVison
//
//  Created by e215402 on 2023/10/03.
//

import SwiftUI


struct ExplainView: View{
    var body: some View{
        VStack(spacing: 10){
            Text("このアプリは車いす体験のできるARアプリです")
                .font(.title)  // タイトルのサイズを指定
                .fontWeight(.semibold)  // テキストの太さを指定
                .multilineTextAlignment(.center)  // テキストを中央揃えにする
                .padding()  // テキストの周りにスペースを追加
            
        }
        .padding()
    }
    
}
