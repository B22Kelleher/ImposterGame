import SwiftUI

struct ContentView: View {
    @State private var showRevealScreen = false
    @State private var askForCount = true
    @State private var numberOfPlayers = "2"
    @State private var NBAPlayers = [
        "Lebron James","Steph Curry","Kevin Durant","Bol Bol","Victor Wembanyama",
        "Scottie Barnes","Vince Carter","Dwight Howard","Kareem Abdul-Jabbar",
        "Kobe Bryant","Chris Paul","Zion Williamson","Kyle Kuzma","Dikembe Mutombo",

        // Added 20 more players
        "Giannis Antetokounmpo","Luka Doncic","Nikola Jokic","Joel Embiid",
        "Jayson Tatum","Jaylen Brown","Damian Lillard","Devin Booker",
        "Kyrie Irving","Ja Morant","Anthony Davis","Shai Gilgeous-Alexander",
        "Jimmy Butler","Paul George","Kawhi Leonard","Trae Young",
        "LaMelo Ball","Jalen Brunson","Donovan Mitchell","Karl-Anthony Towns"
    ]

    @State private var NBATeams = [
        "Atlanta Hawks","Boston Celtics","Brooklyn Nets","Charlotte Hornets",
        "Chicago Bulls","Cleveland Cavaliers","Dallas Mavericks","Denver Nuggets",
        "Detroit Pistons","Golden State Warriors","Houston Rockets","Indiana Pacers",
        "LA Clippers","Los Angeles Lakers","Memphis Grizzlies","Miami Heat",
        "Milwaukee Bucks","Minnesota Timberwolves","New Orleans Pelicans",
        "New York Knicks","Oklahoma City Thunder","Orlando Magic","Philadelphia 76ers",
        "Phoenix Suns","Portland Trail Blazers","Sacramento Kings","San Antonio Spurs",
        "Toronto Raptors","Utah Jazz","Washington Wizards"]
    @State private var NFLPlayers = [
        "Tom Brady", "Rob Gronkowski", "LaDainian Tomlinson",

        // Added 30 players
        "Patrick Mahomes", "Travis Kelce", "Josh Allen", "Joe Burrow",
        "Aaron Rodgers", "Davante Adams", "Tyreek Hill", "Derrick Henry",
        "Christian McCaffrey", "Justin Jefferson", "Cooper Kupp", "Stefon Diggs",
        "Lamar Jackson", "Jalen Hurts", "Micah Parsons", "Nick Bosa",
        "T.J. Watt", "Myles Garrett", "George Kittle", "Saquon Barkley",
        "Justin Herbert", "Dak Prescott", "Deebo Samuel", "A.J. Brown",
        "CeeDee Lamb", "Nick Chubb", "Maxx Crosby", "Calvin Johnson",
        "Kirk Cousins", "Brock Purdy", "Drake Maye", "Stefon Diggs", "Mack Hollins"
    ]
    @State private var NFLTeams = [
        "Arizona Cardinals", "Atlanta Falcons", "Baltimore Ravens", "Buffalo Bills",
        "Carolina Panthers", "Chicago Bears", "Cincinnati Bengals", "Cleveland Browns",
        "Dallas Cowboys", "Denver Broncos", "Detroit Lions", "Green Bay Packers",
        "Houston Texans", "Indianapolis Colts", "Jacksonville Jaguars", "Kansas City Chiefs",
        "Las Vegas Raiders", "Los Angeles Chargers", "Los Angeles Rams", "Miami Dolphins",
        "Minnesota Vikings", "New England Patriots", "New Orleans Saints", "New York Giants",
        "New York Jets", "Philadelphia Eagles", "Pittsburgh Steelers", "San Francisco 49ers",
        "Seattle Seahawks", "Tampa Bay Buccaneers", "Tennessee Titans", "Washington Commanders"
    ]
    @State private var VideoGames = [
        "Minecraft",
        "Fortnite",
        "Call of Duty",
        "Grand Theft Auto V",
        "Super Mario Bros",
        "Mario Kart",
        "The Legend of Zelda: Breath of the Wild",
        "Super Smash Bros",
        "Roblox",
        "Among Us",
        "Pokémon",
        "Tetris",
        "Halo",
        "FIFA",
        "NBA 2K",
        "Madden NFL",
        "Rocket League",
        "Elden Ring",
        "Red Dead Redemption 2",
        "Overwatch",
        "League of Legends",
        "Valorant",
        "Apex Legends",
        "The Sims",
        "Animal Crossing",
        "Fall Guys",
        "Counter-Strike",
        "Skyrim",
        "Cyberpunk 2077",
        "God of War"
    ]


    @State private var categories: [String : [String]] = [:]
    @State private var showGameStartScreen = false
    @State private var startingPlayer: String = ""

    @State private var currentPlayerIndex = 0
    @State private var selectedCategory: String = ""

    @State private var playerCountConfirmed = false
    @State private var impostorCountConfirmed = false
    @State private var showCategoryScreen = false
    @State private var selectedResult: String? = nil
    @State private var playerNames: [String] = ["", ""]
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
        .onAppear {
            categories["NBA Players"] = NBAPlayers
            categories["NFL Players"] = NFLPlayers
            categories["NBA Teams"] = NBATeams
            categories["NFL Teams"] = NFLTeams
            categories["Video Games"] = VideoGames
        }
        .onAppear {
            let appearance = UISegmentedControl.appearance()

            // Background of the whole control
            appearance.backgroundColor = UIColor.white

            // Selected segment color
            appearance.selectedSegmentTintColor = UIColor.red

            // Text for selected segment
            appearance.setTitleTextAttributes(
                [.foregroundColor: UIColor.white], for: .selected)

            // Text for unselected segment
            appearance.setTitleTextAttributes(
                [.foregroundColor: UIColor.gray], for: .normal)

            // Add a gray border around the entire segmented control
            appearance.layer.borderWidth = 1
            appearance.layer.borderColor = UIColor.gray.cgColor

            // Match corners so border looks clean
            appearance.layer.cornerRadius = 8
            appearance.clipsToBounds = true
            
            UIButton.appearance(whenContainedInInstancesOf: [UIStepper.self])
                   .tintColor = .white        }

        
                .padding()
                .background(Color.black.ignoresSafeArea())
    }
    var playerSetupView: some View {
        VStack(spacing: 25) {

            // MARK: - PLAYER COUNT
            VStack {
                Text("Number of Players")
                    .foregroundColor(.white)

                Stepper(value: Binding(
                    get: { Int(numberOfPlayers) ?? 2 },
                    set: { newValue in
                        numberOfPlayers = String(newValue)
                        resizePlayerList(to: newValue)
                    }
                ), in: 2...8) {
                    Text(numberOfPlayers)
                        .foregroundColor(.white)
                }
                .foregroundStyle(.white)
            }

            // MARK: - PLAYER NAME FIELDS
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(playerNames.indices, id: \.self) { index in
                        TextField("Player \(index + 1) Name",
                                  text: Binding(
                                    get: { playerNames[index] },
                                    set: { playerNames[index] = $0 }
                                  ))
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .environment(\.colorScheme, .light)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
            .frame(maxHeight: 250)                              // prevents pushing screen

            // MARK: - IMPOSTOR COUNT
            VStack {
                Text("How many impostors?")
                    .foregroundColor(.white)

                Picker("Impostors", selection: $ImposterCount) {
                    ForEach(1..<(max(2, playerNames.count)), id: \.self) { i in
                        Text("\(i)").tag(String(i))
                    }
                    Text("Random").tag("random")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }

            // MARK: - SAVE BUTTON (VALIDATED)
            Button("Save Players") {
                savePlayers()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isFormValid ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(!isFormValid)

            Spacer()
        }
        .foregroundStyle(.white)
        
        .padding()
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
                showCategoryScreen = true
                showRevealScreen = false
                currentPlayerIndex = 0
                let impostorTotal: Int

                if ImposterCount == "random" {
                    impostorTotal = Int.random(in: 1..<playerNames.count)
                } else {
                    impostorTotal = Int(ImposterCount) ?? 1
                }

                imposterList = playerNames.shuffled()
                    .prefix(impostorTotal)
                    .map { $0 }


            }
            .padding()
            .frame(width: 250)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)

            Button("Edit players") {
                // Go back to setup screen
                showGameStartScreen = false
                showCategoryScreen = false
                showRevealScreen = false

                // Reset player flow
                playerCountConfirmed = false
                impostorCountConfirmed = false

                numberOfPlayers = "2"
                ImposterCount = ""

                inputNames = []
                playerNames = ["", ""]
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
            }
            .padding()
        }
    }
    // Resize the names array when player count changes
    func resizePlayerList(to newCount: Int) {
        if newCount > playerNames.count {
            playerNames.append(contentsOf: Array(repeating: "", count: newCount - playerNames.count))
        } else if newCount < playerNames.count {
            playerNames = Array(playerNames.prefix(newCount))
        }
    }

    // True only when form is complete
    var isFormValid: Bool {
        guard let countInt = Int(numberOfPlayers) else { return false }

        let impostorValid: Bool =
            ImposterCount == "random" ||
            (Int(ImposterCount) ?? 0) > 0

        return countInt > 0 &&
               !playerNames.contains(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) &&
               impostorValid &&
               (ImposterCount == "random" || (Int(ImposterCount) ?? 0) < countInt)
    }

    // Save and move to next screen
    func savePlayers() {
        imposterList = playerNames.shuffled().prefix(Int(ImposterCount) ?? 1).map { $0 }
        showCategoryScreen = true
    }

    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }

