import SwiftUI

struct ContentView: View {
    @State private var showRevealScreen = false
    @State private var askForCount = true
    @State private var numberOfPlayers = ""
    @State private var NBAPlayers = ["Lebron James","Steph Curry", "Kevin Durant", "Bol Bol", "Victor Wembanyama"]
    @State private var Pokemon = ["Pikachu", "Snorlax", "Charizard"]
    @State private var categories: [String : [String]] = [:]
    @State private var showGameStartScreen = false
    @State private var startingPlayer: String = ""

    @State private var currentPlayerIndex = 0
    @State private var selectedCategory: String = ""

    @State private var playerCountConfirmed = false
    @State private var impostorCountConfirmed = false
    @State private var showCategoryScreen = false
    @State private var selectedResult: String? = nil
    @State private var playerNames: [String] = []
    @State private var inputNames: [String] = []
    @State private var ImposterCount = ""
    @State private var imposterList: [String] = []
    var body: some View {
        VStack(spacing: 20) {
            
            if showGameStartScreen {
                gameStartView
            } else if showCategoryScreen {
                if showRevealScreen {
                    playerRevealView
                } else {
                    categorySelectionView
                }
            } else {
                playerSetupView
            }

        }
                .padding()
    }
    var playerSetupView: some View {
        VStack(spacing: 20) {

            // STEP 1: Ask for number of players
            if !playerCountConfirmed {
                VStack {
                    Text("How many players do you want?")
                        .foregroundColor(.white)

                    TextField("Enter a number", text: $numberOfPlayers)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Confirm") {
                        if let count = Int(numberOfPlayers), count > 0 {
                            inputNames = Array(repeating: "", count: count)
                            playerCountConfirmed = true
                        }
                    }
                }
            }

            // STEP 2: Ask for number of impostors
            if playerCountConfirmed && !impostorCountConfirmed {
                VStack {
                    Text("How many Impostors do you want?")
                        .foregroundColor(.white)

                    TextField("Enter a number", text: $ImposterCount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Confirm") {
                        if let playerCount = Int(numberOfPlayers),
                           let impostorCount = Int(ImposterCount),
                           impostorCount > 0,
                           impostorCount <= playerCount {
                            impostorCountConfirmed = true
                        }
                    }
                }
            }

            // STEP 3: Enter player names and save
            if impostorCountConfirmed {
                ForEach(inputNames.indices, id: \.self) { index in
                    TextField("Player \(index + 1) name", text: $inputNames[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                if !inputNames.isEmpty {
                    Button("Save Players") {
                        playerNames = inputNames.filter { !$0.isEmpty }

                        // Assign impostors now that player names exist
                        if let impostorCount = Int(ImposterCount),
                           impostorCount > 0,
                           impostorCount <= playerNames.count {
                            imposterList = playerNames.shuffled().prefix(impostorCount).map { $0 }
                        }

                        showCategoryScreen = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }

            Spacer()
        }
        .onAppear {
            categories["NBA Players"] = NBAPlayers
            categories["Pokemon"] = Pokemon
        }
    }

    var categorySelectionView: some View {
        VStack(spacing: 20) {
            Text("Choose a Category")
                .font(.title)
                .foregroundColor(.white)
            
            ForEach(categories.keys.sorted(), id: \.self) { category in
                Button(category) {
                    if let items = categories[category], !items.isEmpty {
                        selectedCategory = category
                        selectedResult = items.randomElement()
                        showRevealScreen = true
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
    var gameStartView: some View {
        VStack(spacing: 40) {
            
            Text("Starting Player:")
                .font(.title)
                .foregroundColor(.white)
            
            Text(startingPlayer)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.yellow)
            
            // BUTTON: NEW CATEGORY
            Button("Select New Category") {
                showGameStartScreen = false
                showCategoryScreen = true      // go back to category screen
                showRevealScreen = false
                currentPlayerIndex = 0         // reset reveal order
            }
            Button("Edit players") {
                // Go back to setup screen
                showGameStartScreen = false
                showCategoryScreen = false
                showRevealScreen = false

                // Reset player flow
                playerCountConfirmed = false
                impostorCountConfirmed = false

                numberOfPlayers = ""
                ImposterCount = ""

                inputNames = []
                playerNames = []
                imposterList = []

                currentPlayerIndex = 0
                selectedCategory = ""
                selectedResult = nil
            }
            .padding()
            .frame(width: 250)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)

            Spacer()
        }
    }
    var playerRevealView: some View {
        VStack {
            if currentPlayerIndex < playerNames.count {
                PlayerRevealCard(
                    playerName: playerNames[currentPlayerIndex],
                    category: selectedCategory,
                    word: selectedResult ?? "",
                    isImpostor: imposterList.contains(playerNames[currentPlayerIndex])
                )

                // BUTTON CHANGES ON LAST PLAYER
                Button(currentPlayerIndex == playerNames.count - 1 ? "Start Game" : "Next Player") {

                    if currentPlayerIndex < playerNames.count - 1 {
                        // move to next player
                        currentPlayerIndex += 1
                    } else {
                        // START GAME ACTION
                        // (Add whatever you want to happen next)
                        startingPlayer = playerNames.randomElement() ?? ""
                        showRevealScreen = false
                        showGameStartScreen = true
                        // e.g. navigate to game screen later
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

            } else {
                Text("All Players Have Seen Their Word")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }

    }


  
    struct PlayerRevealCard: View {
        let playerName: String
        let category: String
        let word: String
        let isImpostor: Bool
        
        @State private var revealed = false   // ← toggles on tap
        
        var body: some View {
            VStack(spacing: 30) {
                Text(playerName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("Category: \(category)")
                    .font(.title2)
                    .foregroundColor(.white)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray)
                        .frame(width: 250, height: 150)

                    // SHOW TEXT ONLY WHEN REVEALED
                    if revealed {
                        Text(isImpostor ? "IMPOSTOR" : word)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            revealed = true       // finger / mouse is down
                        }
                        .onEnded { _ in
                            revealed = false      // released
                        }
                )



                Spacer()
            }
            .padding()
        }
    }

    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }

