//
//  ContentView.swift
//  Slot Machine
//
//  Created by Hasan Basri Öztürk on 7.10.2022.
//
import SwiftUI

struct ContentView: View {
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatinSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    //MARK: - FUNCTIONS
    
    func spinReels() {
        //MARK: - MANUEL WAY
//        reels[0] = Int.random(in: 0...symbols.count-1)
//        reels[1] = Int.random(in: 0...symbols.count-1)
//        reels[2] = Int.random(in: 0...symbols.count-1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count-1)
        })
        playSound(sound: "spin", type: "mp3")
    }
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            playerWins()
        
            if coins > highScore{
                newHighScore()
                
            } else {
                playSound(sound: "win", type: "mp3")
            }
             
        } else {
            playerLoses()
        }
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playSound(sound: "highscore", type: "mp3")
    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    func activateBet20(){
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func activateBet10(){
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func isGameOver() {
      if coins <= 0 {
        showingModal = true
        playSound(sound: "game-over", type: "mp3")
      }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    

 
    //GAME IS OVER
    
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]),startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            //MARK: - INTERFACE
            VStack (alignment: .center, spacing: 5) {
                //MARK: - HEADER
                LogoView()
                Spacer()
                
                //MARK: - SCORE
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                }
                //MARK: - SLOT MACHINE
                
                VStack(alignment: .center, spacing: 0) {
                    //MARK: - REEL1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatinSymbol ? 1 : 0)
                            .offset(y: animatinSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear {
                                animatinSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //MARK: - REEL2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatinSymbol ? 1 : 0)
                                .offset(y: animatinSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear {
                                    animatinSymbol.toggle()
                                }
                        }
                        
                        Spacer()
                        //MARK: - REEL3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatinSymbol ? 1 : 0)
                                .offset(y: animatinSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear {
                                    animatinSymbol.toggle()
                                }
                        }
                        
                        
                    }
                    

                    
                    //MARK: - SPIN BUTTON
                    Button {
                        
                        spinReels()
                        
                        checkWinning()
                        
                        isGameOver()
                    } label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }

                }
                //MARK: - FOOTER
                Spacer()
                HStack {
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            activateBet20()
                        } label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color.yellow : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())

                    }
                    
                    HStack(alignment: .center, spacing: 10) {
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button {
                            activateBet10()
                        } label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color.yellow : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            //MARK: - BUTTONS
            .overlay(
                //RESET
                Button(action: {
                    resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                //RESET
                Button(action: {
                    showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0 , opaque: false)
            //MARK: - POPUP
            
            if $showingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all of the coins. \nLets play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button {
                                showingModal = false
                                animatingModal = false
                                activateBet10()
                                 coins = 100
                            } label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body , design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundColor(Color("ColorPink"))
                                    )
                            }

                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center )
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear {
                        self.animatingModal = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
