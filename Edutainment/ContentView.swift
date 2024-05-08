//
//  ContentView.swift
//  Edutainment
//
//  Created by Leo Torres Neyra on 4/1/24.
//

import SwiftUI

struct AppTextStyle: ViewModifier {
    let font: Font
    let modifyTextColor: Bool
    
    func body(content: Content) -> some View {
        content
            .font(font.bold())
            //.foregroundColor(Color(red: 0.50, green: 0.60, blue: 1.0)) // Old look
            .foregroundStyle(modifyTextColor ? .black : .white)
            .shadow(color: .gray, radius: modifyTextColor ? 0 : 1, x: 0, y: modifyTextColor ? 0 : 1)
            
    }
}

struct BackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }
}

struct ButtonStyle: ViewModifier {
    let modifyColor: Bool
    
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.title3)
            .frame(width: 110, height: 50)
            .background(modifyColor ?
                        LinearGradient(colors: [Color(red: 0.50, green: 0.60, blue: 1.0)], startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            
                )
            .foregroundStyle(.white)
            .shadow(color: .gray, radius: 2, x: 0, y:2)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func withTextStyle (_ modifyTextColor: Bool, _ font: Font = .headline) -> some View {
        modifier(AppTextStyle(font: font, modifyTextColor: modifyTextColor))
    }
    
    func withBackgroundStyle () -> some View {
        modifier(BackgroundStyle())
    }
    
    func withButtonStyle (_ modifyColor: Bool = true) -> some View {
        modifier(ButtonStyle(modifyColor: modifyColor))
    }
}

struct ContentView: View {
    @State private var gameOption = "easy ☺️"
    @State private var multiplyTables = 2
    @State private var selectedNumberOfQuestions = 5
    
    @State private var multiple1 = Int()
    @State private var multiple2 = Int()
    @State private var answers = Set<Int> ()
    @State private var correctAnswer = 0
    
    @State private var score = 0
    @State private var count = 0
    
    @State private var messageTitle = ""
    
    @State private var showOptions = true
    @State private var showAlert = false
    @State private var showLeoncitoOrGatito = true
    
    @State private var animationAmount = 0.0
    @State private var rotationAmount = 0.0
    
    @State private var dragAmount = CGSize.zero
    
    let numberOfQuestions = [5, 10, 20]
    let difficulties = ["easy ☺️", "normal 😄", "hard 🥵"]
    @State private var animals = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"].shuffled()
    
    init() {
        // Sets the background color of the Picker
        // UISegmentedControl.appearance().backgroundColor = .red.withAlphaComponent(0.15)
        // Disappears the divider
        //   UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // Changes the color for the selected item
        //  UISegmentedControl.appearance().selectedSegmentTintColor = .white
        // Changes the text color for the selected item
        //   UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .topLeading) {
                if showLeoncitoOrGatito{
                    RadialGradient(stops: [
                        .init(color: Color (red: 0.7, green: 1.0, blue: 1.0), location: 0.3),
                        .init(color: Color (red: 0.71, green: 0.59, blue: 1.0), location: 0.9),
                        .init(color: Color (red: 0.71, green: 0.21, blue: 1.0), location: 1.6)
                    ], center: .topLeading, startRadius: 200, endRadius: 700)
                    .ignoresSafeArea()
                }else {
                    LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                        .blur(radius: 3.0)
                }
                
                VStack (alignment: .leading) {
                    Text("Let's multiply! 🤩")
                        .withTextStyle(showLeoncitoOrGatito, .largeTitle)
                        .padding(.top, showOptions ? 8 : 0) //When Options disappear
                        .padding([.leading], 15)

                    if showOptions {
                        /*
                        VStack (alignment: .leading){
                            Text("Choose the difficulty level:")
                                .padding()
                            
                            Picker("Difficulties", selection: $gameOption) {
                                ForEach(difficulties, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            
                            HStack {
                                Spacer()
                                Button ("Aceptar") {
                                    showOptions = false
                                }
                                .frame(width: 100, height: 40)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                Spacer()
                            }
                            .padding()
                        }
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                         */
                        
                        VStack (alignment: .leading) {
                            VStack {
                                Stepper("How many multiply tables do you want?", value: $multiplyTables, in: 2...12)
                                    .withTextStyle(showLeoncitoOrGatito, .title3)
                                
                                Text("\(multiplyTables)")
                                    .withTextStyle(showLeoncitoOrGatito, .system(size: 30))
                                    .withButtonStyle(showLeoncitoOrGatito)
                                    .padding(.bottom, 40)
                                    .animation(.default, value: multiplyTables)
                            }
                            
                            Section {
                                Picker("How many questions? 🤔", selection: $selectedNumberOfQuestions) {
                                    ForEach(numberOfQuestions, id: \.self) {
                                        Text("\($0)")
                                    }
                                } 
                                .pickerStyle(.segmented)
                                
                            } header: {
                                Text("How many questions? 🤔")
                                    .withTextStyle(showLeoncitoOrGatito, .title3)
                            }
                            
                            HStack {
                                Spacer()
                                
                                Button {
                                    showOptions = false
                                    generateAnswers()
                                } label: {
                                    Text("Aceptar")                                .withTextStyle(showLeoncitoOrGatito)
                                }
                                .withButtonStyle(showLeoncitoOrGatito)
                                .padding()
                                
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Button {
                                    showLeoncitoOrGatito.toggle()
                                    withAnimation (.spring(duration: 1, bounce: 0.5)) {
                                        rotationAmount += 360
                                    }
                                } label: {
                                    Image(showLeoncitoOrGatito ? "Leoncito" : "Gatito")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: 250, height: 240)
                                .padding()
                                .rotation3DEffect(.degrees(Double(rotationAmount)), axis: (x: 0.0, y: 0.0, z: 1.0))
                                Spacer()
                            }
                        }
                        .withBackgroundStyle()
                        .onAppear {
                            withAnimation {
                                animationAmount += 1
                            }
                        }
                        .animation(.easeIn(duration: 1), value: animationAmount)
                        //.transition(.asymmetric(insertion: .scale, removal: .opacity))
                        
                    }
                    
                    else {
                        VStack (alignment: .center) {
                            
                            Text("Question \(count)")
                                .withTextStyle(showLeoncitoOrGatito, .title)
                                .padding([.bottom])
                            
                            HStack {
                                Spacer()

                                Image(animals[0])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 140)
                                    .offset(dragAmount)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { dragAmount = $0.translation }
                                            .onEnded { _ in
                                                withAnimation(.spring()) {
                                                    dragAmount = .zero
                                                }
                                            }
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(duration: 1.5, bounce: 0.5)) {
                                            rotationAmount += 360
                                            
                                        }
                                    }
                                    .animation(.easeIn(duration: 0.5), value: answers)
                                    .rotation3DEffect(.degrees(Double(rotationAmount)),
                                                      axis: (x: 1.0, y: 1.0, z: -1.0))
                                    
                                
                                Spacer()
                            }
                            
                            Text("What is? \(multiple1) x \(multiple2)")
                                .withTextStyle(showLeoncitoOrGatito, .title)
                                .padding(.bottom)
                        
                           // List{
                            VStack{
                                ForEach(Array(answers), id: \.self) { num in
                                    HStack{
                                        Spacer()
                                        
                                        Button {
                                            score += correctAnswer == num ? 1 : 0
                                            generateAnswers()
                                        } label: {
                                            Text("\(num)")
                                                .withTextStyle(showLeoncitoOrGatito, .title)
                                        }
                                        .withButtonStyle(showLeoncitoOrGatito)
                                        
                                        Spacer()
                                    }
                                }
                           }
                           // .frame(height: CGFloat(answers.count) * CGFloat(44.0))
                            //.edgesIgnoringSafeArea(.all)
                            //.listStyle(.plain)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))

                            Text("Score: \(score)")
                                .withTextStyle(showLeoncitoOrGatito, .title3)
                                .padding()
                        }
                        //.onAppear(perform: generateAnswers)
                        .withBackgroundStyle()

                    }
                }
                
            }
            .toolbar {
                if !showOptions {
                    Button ("Options") {
                        showOptions = true
                        newGame()
                    }
                    .withTextStyle(showLeoncitoOrGatito)
                }
            }
            .alert(messageTitle, isPresented: $showAlert) {
                Button ("Ok") {
                    newGame()
                }
            } message: {
                Text("Your score is: \(score)")
            }
        }
    }
    
    func generateAnswers () {
        answers.removeAll()
        animals.shuffle()
        
        repeat {
            multiple1 = Int.random(in: 2...multiplyTables)
            multiple2 = Int.random(in: 1...12)
            
            correctAnswer = multiple1 * multiple2
            answers.insert(correctAnswer)
            
        } while answers.count < 5
        
        if count >= selectedNumberOfQuestions {
            if count == score {
                messageTitle = "PERFECT! You're awesome 🥳🤩"
            } else{
                messageTitle = "End of the game! 🥺😔"
            }
            
            showAlert = true
            
            return
        }
        
        count += 1
    }
    
    func newGame () {
        count = 0
        score = 0
        multiplyTables = 2
        selectedNumberOfQuestions = 5
        showOptions = true
    }
}

#Preview {
    ContentView()
}
