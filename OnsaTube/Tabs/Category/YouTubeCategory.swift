import Foundation
import Models

extension YouTubeCategory {
    func toDraft() -> Draft {
        return Draft(content: name)
    }
}

enum YouTubeCategory: Equatable, Hashable {
    case category(name: String, subcategories: [YouTubeCategory])
    
    var name: String {
        switch self {
            case .category(let name, _):
                return name
        }
    }
    
    var subcategories: [YouTubeCategory] {
        switch self {
            case .category(_, let subcategories):
                return subcategories
        }
    }
    
    static func == (lhs: YouTubeCategory, rhs: YouTubeCategory) -> Bool {
        switch (lhs, rhs) {
            case (.category(let lhsName, let lhsSubcategories), .category(let rhsName, let rhsSubcategories)):
                return lhsName == rhsName && lhsSubcategories == rhsSubcategories
        }
    }
    
    // Custom hash function for hashing
    func hash(into hasher: inout Hasher) {
        switch self {
            case .category(let name, _):
                hasher.combine(name)
        }
    }
    
    public static let allCategories: [YouTubeCategory] = [
        .category(name: "Music", subcategories: [
            .category(name: "Pop", subcategories: [
                .category(name: "Indie Pop", subcategories: []),
                .category(name: "Synth Pop", subcategories: []),
                .category(name: "K-Pop", subcategories: []),
                .category(name: "Pop Rock", subcategories: []),
                .category(name: "Pop Punk", subcategories: [])
            ]),
            .category(name: "Rock", subcategories: [
                .category(name: "Classic Rock", subcategories: []),
                .category(name: "Hard Rock", subcategories: []),
                .category(name: "Alternative Rock", subcategories: []),
                .category(name: "Punk Rock", subcategories: []),
                .category(name: "Indie Rock", subcategories: [])
            ]),
            .category(name: "Hip-Hop", subcategories: [
                .category(name: "Rap", subcategories: []),
                .category(name: "Trap", subcategories: []),
                .category(name: "Lo-Fi Hip-Hop", subcategories: []),
                .category(name: "Boom Bap", subcategories: []),
                .category(name: "Gangsta Rap", subcategories: [])
            ]),
            .category(name: "Classical", subcategories: [
                .category(name: "Baroque", subcategories: []),
                .category(name: "Romantic", subcategories: []),
                .category(name: "Modern Classical", subcategories: []),
                .category(name: "Chamber Music", subcategories: []),
                .category(name: "Opera", subcategories: [])
            ]),
            .category(name: "Jazz", subcategories: [
                .category(name: "Smooth Jazz", subcategories: []),
                .category(name: "Bebop", subcategories: []),
                .category(name: "Vocal Jazz", subcategories: []),
                .category(name: "Swing", subcategories: []),
                .category(name: "Free Jazz", subcategories: [])
            ]),
            .category(name: "Electronic", subcategories: [
                .category(name: "House", subcategories: []),
                .category(name: "Techno", subcategories: []),
                .category(name: "Trance", subcategories: []),
                .category(name: "Dubstep", subcategories: []),
                .category(name: "Drum and Bass", subcategories: [])
            ]),
            .category(name: "Country", subcategories: [
                .category(name: "Classic Country", subcategories: []),
                .category(name: "Country Pop", subcategories: []),
                .category(name: "Bluegrass", subcategories: []),
                .category(name: "Alt-Country", subcategories: []),
                .category(name: "Country Rock", subcategories: [])
            ]),
            .category(name: "Reggae", subcategories: [
                .category(name: "Dancehall", subcategories: []),
                .category(name: "Roots Reggae", subcategories: []),
                .category(name: "Dub", subcategories: []),
                .category(name: "Reggaeton", subcategories: []),
                .category(name: "Ska", subcategories: [])
            ]),
            .category(name: "Latin", subcategories: [
                .category(name: "Salsa", subcategories: []),
                .category(name: "Bachata", subcategories: []),
                .category(name: "Merengue", subcategories: []),
                .category(name: "Latin Pop", subcategories: []),
                .category(name: "Reggaeton", subcategories: [])
            ]),
            .category(name: "Blues", subcategories: [
                .category(name: "Delta Blues", subcategories: []),
                .category(name: "Chicago Blues", subcategories: []),
                .category(name: "Electric Blues", subcategories: []),
                .category(name: "Blues Rock", subcategories: []),
                .category(name: "Acoustic Blues", subcategories: [])
            ])
        ]),
        .category(name: "Gaming", subcategories: [
            .category(name: "Action", subcategories: [
                .category(name: "FPS", subcategories: []),
                .category(name: "Platformer", subcategories: []),
                .category(name: "Beat 'em up", subcategories: []),
                .category(name: "Hack and Slash", subcategories: []),
                .category(name: "Shooter", subcategories: [])
            ]),
            .category(name: "Adventure", subcategories: [
                .category(name: "Graphic Adventure", subcategories: []),
                .category(name: "Interactive Story", subcategories: []),
                .category(name: "Text Adventure", subcategories: []),
                .category(name: "Visual Novel", subcategories: []),
                .category(name: "Walking Simulator", subcategories: [])
            ]),
            .category(name: "Strategy", subcategories: [
                .category(name: "RTS", subcategories: []),
                .category(name: "TBS", subcategories: []),
                .category(name: "Tower Defense", subcategories: []),
                .category(name: "4X", subcategories: []),
                .category(name: "MOBA", subcategories: [])
            ]),
            .category(name: "Role-Playing", subcategories: [
                .category(name: "Action RPG", subcategories: []),
                .category(name: "JRPG", subcategories: []),
                .category(name: "WRPG", subcategories: []),
                .category(name: "MMORPG", subcategories: []),
                .category(name: "Roguelike", subcategories: [])
            ]),
            .category(name: "Simulation", subcategories: [
                .category(name: "Life Simulation", subcategories: []),
                .category(name: "Vehicle Simulation", subcategories: []),
                .category(name: "City Building", subcategories: []),
                .category(name: "Flight Simulator", subcategories: []),
                .category(name: "Business Simulation", subcategories: [])
            ]),
            .category(name: "Sports", subcategories: [
                .category(name: "Football", subcategories: []),
                .category(name: "Basketball", subcategories: []),
                .category(name: "Baseball", subcategories: []),
                .category(name: "Racing", subcategories: []),
                .category(name: "Golf", subcategories: [])
            ]),
            .category(name: "Puzzle", subcategories: [
                .category(name: "Match-3", subcategories: []),
                .category(name: "Jigsaw Puzzle", subcategories: []),
                .category(name: "Logic Puzzle", subcategories: []),
                .category(name: "Trivia", subcategories: []),
                .category(name: "Word Game", subcategories: [])
            ]),
            .category(name: "Arcade", subcategories: [
                .category(name: "Classic Arcade", subcategories: []),
                .category(name: "Pinball", subcategories: []),
                .category(name: "Rhythm Games", subcategories: []),
                .category(name: "Bullet Hell", subcategories: []),
                .category(name: "Beat 'em up", subcategories: [])
            ]),
            .category(name: "Horror", subcategories: [
                .category(name: "Survival Horror", subcategories: []),
                .category(name: "Psychological Horror", subcategories: []),
                .category(name: "Jump Scare", subcategories: []),
                .category(name: "Gore", subcategories: []),
                .category(name: "Supernatural", subcategories: [])
            ]),
            .category(name: "Fighting", subcategories: [
                .category(name: "2D Fighting", subcategories: []),
                .category(name: "3D Fighting", subcategories: []),
                .category(name: "Platform Fighter", subcategories: []),
                .category(name: "Arena Fighter", subcategories: []),
                .category(name: "Sports Fighting", subcategories: [])
            ])
        ]),
        .category(name: "Education", subcategories: [
            .category(name: "Mathematics", subcategories: [
                .category(name: "Algebra", subcategories: []),
                .category(name: "Calculus", subcategories: []),
                .category(name: "Geometry", subcategories: []),
                .category(name: "Trigonometry", subcategories: []),
                .category(name: "Statistics", subcategories: [])
            ]),
            .category(name: "Science", subcategories: [
                .category(name: "Physics", subcategories: []),
                .category(name: "Biology", subcategories: []),
                .category(name: "Chemistry", subcategories: []),
                .category(name: "Earth Science", subcategories: []),
                .category(name: "Environmental Science", subcategories: [])
            ]),
            .category(name: "History", subcategories: [
                .category(name: "Ancient History", subcategories: []),
                .category(name: "Modern History", subcategories: []),
                .category(name: "Medieval History", subcategories: []),
                .category(name: "American History", subcategories: []),
                .category(name: "World History", subcategories: [])
            ]),
            .category(name: "Languages", subcategories: [
                .category(name: "English", subcategories: []),
                .category(name: "Spanish", subcategories: []),
                .category(name: "French", subcategories: []),
                .category(name: "Chinese", subcategories: []),
                .category(name: "German", subcategories: [])
            ]),
            .category(name: "Technology", subcategories: [
                .category(name: "Coding", subcategories: []),
                .category(name: "Robotics", subcategories: []),
                .category(name: "Web Development", subcategories: []),
                .category(name: "Data Science", subcategories: []),
                .category(name: "Cybersecurity", subcategories: [])
            ]),
            .category(name: "Arts", subcategories: [
                .category(name: "Drawing", subcategories: []),
                .category(name: "Painting", subcategories: []),
                .category(name: "Sculpting", subcategories: []),
                .category(name: "Photography", subcategories: []),
                .category(name: "Music Theory", subcategories: [])
            ]),
            .category(name: "Health", subcategories: [
                .category(name: "Nutrition", subcategories: []),
                .category(name: "Physical Education", subcategories: []),
                .category(name: "Mental Health", subcategories: []),
                .category(name: "Medical Science", subcategories: []),
                .category(name: "First Aid", subcategories: [])
            ]),
            .category(name: "Literature", subcategories: [
                .category(name: "Classics", subcategories: []),
                .category(name: "Contemporary", subcategories: []),
                .category(name: "Poetry", subcategories: []),
                .category(name: "Drama", subcategories: []),
                .category(name: "Short Stories", subcategories: [])
            ]),
            .category(name: "Geography", subcategories: [
                .category(name: "Physical Geography", subcategories: []),
                .category(name: "Human Geography", subcategories: []),
                .category(name: "Cartography", subcategories: []),
                .category(name: "Geopolitics", subcategories: []),
                .category(name: "Cultural Geography", subcategories: [])
            ]),
            .category(name: "Economics", subcategories: [
                .category(name: "Microeconomics", subcategories: []),
                .category(name: "Macroeconomics", subcategories: []),
                .category(name: "Development Economics", subcategories: []),
                .category(name: "Behavioral Economics", subcategories: []),
                .category(name: "International Economics", subcategories: [])
            ])
        ]),
        .category(name: "Entertainment", subcategories: [
            .category(name: "Movies", subcategories: [
                .category(name: "Action", subcategories: []),
                .category(name: "Comedy", subcategories: []),
                .category(name: "Drama", subcategories: []),
                .category(name: "Horror", subcategories: []),
                .category(name: "Sci-Fi", subcategories: [])
            ]),
            .category(name: "TV Shows", subcategories: [
                .category(name: "Sitcoms", subcategories: []),
                .category(name: "Dramas", subcategories: []),
                .category(name: "Reality TV", subcategories: []),
                .category(name: "Documentaries", subcategories: []),
                .category(name: "Cartoons", subcategories: [])
            ]),
            .category(name: "Talk Shows", subcategories: [
                .category(name: "Late Night", subcategories: []),
                .category(name: "Daytime", subcategories: []),
                .category(name: "Radio Shows", subcategories: []),
                .category(name: "Podcasts", subcategories: []),
                .category(name: "Interview Shows", subcategories: [])
            ]),
            .category(name: "Celebrity News", subcategories: [
                .category(name: "Gossip", subcategories: []),
                .category(name: "Interviews", subcategories: []),
                .category(name: "Red Carpet Events", subcategories: []),
                .category(name: "Celebrity Scandals", subcategories: []),
                .category(name: "Award Shows", subcategories: [])
            ]),
            .category(name: "Music Videos", subcategories: [
                .category(name: "Pop Music Videos", subcategories: []),
                .category(name: "Rock Music Videos", subcategories: []),
                .category(name: "Hip-Hop Music Videos", subcategories: []),
                .category(name: "Country Music Videos", subcategories: []),
                .category(name: "Indie Music Videos", subcategories: [])
            ]),
            .category(name: "Comedy", subcategories: [
                .category(name: "Stand-Up", subcategories: []),
                .category(name: "Sketch Comedy", subcategories: []),
                .category(name: "Parodies", subcategories: []),
                .category(name: "Improv", subcategories: []),
                .category(name: "Satire", subcategories: [])
            ]),
            .category(name: "Drama", subcategories: [
                .category(name: "Crime Drama", subcategories: []),
                .category(name: "Romantic Drama", subcategories: []),
                .category(name: "Legal Drama", subcategories: []),
                .category(name: "Medical Drama", subcategories: []),
                .category(name: "Political Drama", subcategories: [])
            ]),
            .category(name: "Sci-Fi & Fantasy", subcategories: [
                .category(name: "Space Opera", subcategories: []),
                .category(name: "Cyberpunk", subcategories: []),
                .category(name: "Epic Fantasy", subcategories: []),
                .category(name: "Urban Fantasy", subcategories: []),
                .category(name: "Time Travel", subcategories: [])
            ]),
            .category(name: "Romance", subcategories: [
                .category(name: "Romantic Comedy", subcategories: []),
                .category(name: "Romantic Drama", subcategories: []),
                .category(name: "Historical Romance", subcategories: []),
                .category(name: "Paranormal Romance", subcategories: []),
                .category(name: "Erotic Romance", subcategories: [])
            ]),
            .category(name: "Action & Adventure", subcategories: [
                .category(name: "Superhero", subcategories: []),
                .category(name: "Spy", subcategories: []),
                .category(name: "Martial Arts", subcategories: []),
                .category(name: "Western", subcategories: []),
                .category(name: "War", subcategories: [])
            ])
        ]),
        .category(name: "News & Politics", subcategories: [
            .category(name: "World News", subcategories: [
                .category(name: "International Relations", subcategories: []),
                .category(name: "Global Conflicts", subcategories: []),
                .category(name: "Foreign Policy", subcategories: []),
                .category(name: "UN Affairs", subcategories: []),
                .category(name: "Diplomacy", subcategories: [])
            ]),
            .category(name: "Local News", subcategories: [
                .category(name: "Community Events", subcategories: []),
                .category(name: "Local Crime", subcategories: []),
                .category(name: "Municipal Politics", subcategories: []),
                .category(name: "Local Economy", subcategories: []),
                .category(name: "Weather", subcategories: [])
            ]),
            .category(name: "Politics", subcategories: [
                .category(name: "Elections", subcategories: []),
                .category(name: "Legislation", subcategories: []),
                .category(name: "Political Analysis", subcategories: []),
                .category(name: "Campaigns", subcategories: []),
                .category(name: "Political Debates", subcategories: [])
            ]),
            .category(name: "Economics", subcategories: [
                .category(name: "Market Trends", subcategories: []),
                .category(name: "Economic Policy", subcategories: []),
                .category(name: "Personal Finance", subcategories: []),
                .category(name: "Global Economy", subcategories: []),
                .category(name: "Cryptocurrency", subcategories: [])
            ]),
            .category(name: "Investigative Journalism", subcategories: [
                .category(name: "Corruption", subcategories: []),
                .category(name: "Crime", subcategories: []),
                .category(name: "Corporate Malfeasance", subcategories: []),
                .category(name: "Whistleblowers", subcategories: []),
                .category(name: "Human Rights", subcategories: [])
            ]),
            .category(name: "Opinion", subcategories: [
                .category(name: "Editorials", subcategories: []),
                .category(name: "Op-Eds", subcategories: []),
                .category(name: "Letters to the Editor", subcategories: []),
                .category(name: "Columns", subcategories: []),
                .category(name: "Blogs", subcategories: [])
            ]),
            .category(name: "Interviews", subcategories: [
                .category(name: "Politicians", subcategories: []),
                .category(name: "Experts", subcategories: []),
                .category(name: "Journalists", subcategories: []),
                .category(name: "Activists", subcategories: []),
                .category(name: "Celebrities", subcategories: [])
            ]),
            .category(name: "Documentaries", subcategories: [
                .category(name: "Political History", subcategories: []),
                .category(name: "Economic Issues", subcategories: []),
                .category(name: "Social Issues", subcategories: []),
                .category(name: "Environmental Issues", subcategories: []),
                .category(name: "Human Rights", subcategories: [])
            ]),
            .category(name: "Opinion Analysis", subcategories: [
                .category(name: "Policy Analysis", subcategories: []),
                .category(name: "Political Strategy", subcategories: []),
                .category(name: "Economic Forecasting", subcategories: []),
                .category(name: "Social Commentary", subcategories: []),
                .category(name: "Media Critique", subcategories: [])
            ]),
            .category(name: "Public Service Announcements", subcategories: [
                .category(name: "Health Advisories", subcategories: []),
                .category(name: "Safety Alerts", subcategories: []),
                .category(name: "Government Announcements", subcategories: []),
                .category(name: "Weather Alerts", subcategories: []),
                .category(name: "Community Notices", subcategories: [])
            ])
        ]),
        .category(name: "Sports", subcategories: [
            .category(name: "Football", subcategories: [
                .category(name: "Premier League", subcategories: []),
                .category(name: "La Liga", subcategories: []),
                .category(name: "Bundesliga", subcategories: []),
                .category(name: "Serie A", subcategories: []),
                .category(name: "Ligue 1", subcategories: [])
            ]),
            .category(name: "Basketball", subcategories: [
                .category(name: "NBA", subcategories: []),
                .category(name: "EuroLeague", subcategories: []),
                .category(name: "College Basketball", subcategories: []),
                .category(name: "WNBA", subcategories: []),
                .category(name: "FIBA", subcategories: [])
            ]),
            .category(name: "Tennis", subcategories: [
                .category(name: "Grand Slam", subcategories: []),
                .category(name: "ATP Tour", subcategories: []),
                .category(name: "WTA Tour", subcategories: []),
                .category(name: "Davis Cup", subcategories: []),
                .category(name: "Fed Cup", subcategories: [])
            ]),
            .category(name: "Cricket", subcategories: [
                .category(name: "Test Matches", subcategories: []),
                .category(name: "ODI", subcategories: []),
                .category(name: "T20", subcategories: []),
                .category(name: "IPL", subcategories: []),
                .category(name: "BBL", subcategories: [])
            ]),
            .category(name: "Golf", subcategories: [
                .category(name: "PGA Tour", subcategories: []),
                .category(name: "European Tour", subcategories: []),
                .category(name: "LPGA", subcategories: []),
                .category(name: "Majors", subcategories: []),
                .category(name: "Amateur Golf", subcategories: [])
            ]),
            .category(name: "Motorsport", subcategories: [
                .category(name: "Formula 1", subcategories: []),
                .category(name: "MotoGP", subcategories: []),
                .category(name: "NASCAR", subcategories: []),
                .category(name: "WRC", subcategories: []),
                .category(name: "IndyCar", subcategories: [])
            ]),
            .category(name: "Athletics", subcategories: [
                .category(name: "Track Events", subcategories: []),
                .category(name: "Field Events", subcategories: []),
                .category(name: "Marathons", subcategories: []),
                .category(name: "Olympics", subcategories: []),
                .category(name: "Paralympics", subcategories: [])
            ]),
            .category(name: "Boxing", subcategories: [
                .category(name: "Professional", subcategories: []),
                .category(name: "Amateur", subcategories: []),
                .category(name: "Heavyweight", subcategories: []),
                .category(name: "Middleweight", subcategories: []),
                .category(name: "Lightweight", subcategories: [])
            ]),
            .category(name: "Wrestling", subcategories: [
                .category(name: "WWE", subcategories: []),
                .category(name: "AEW", subcategories: []),
                .category(name: "NJPW", subcategories: []),
                .category(name: "Impact Wrestling", subcategories: []),
                .category(name: "ROH", subcategories: [])
            ]),
            .category(name: "Cycling", subcategories: [
                .category(name: "Road Racing", subcategories: []),
                .category(name: "Mountain Biking", subcategories: []),
                .category(name: "Track Cycling", subcategories: []),
                .category(name: "Cyclocross", subcategories: []),
                .category(name: "BMX", subcategories: [])
            ])
        ]),
        .category(name: "Gaming", subcategories: [
            .category(name: "Action", subcategories: [
                .category(name: "First-Person Shooter", subcategories: []),
                .category(name: "Third-Person Shooter", subcategories: []),
                .category(name: "Platformer", subcategories: []),
                .category(name: "Hack and Slash", subcategories: []),
                .category(name: "Fighting", subcategories: [])
            ]),
            .category(name: "Adventure", subcategories: [
                .category(name: "Open World", subcategories: []),
                .category(name: "Narrative", subcategories: []),
                .category(name: "Point-and-Click", subcategories: []),
                .category(name: "Visual Novel", subcategories: []),
                .category(name: "Survival", subcategories: [])
            ]),
            .category(name: "Role-Playing", subcategories: [
                .category(name: "Action RPG", subcategories: []),
                .category(name: "JRPG", subcategories: []),
                .category(name: "MMORPG", subcategories: []),
                .category(name: "Tactical RPG", subcategories: []),
                .category(name: "Dungeon Crawler", subcategories: [])
            ]),
            .category(name: "Simulation", subcategories: [
                .category(name: "Life Simulation", subcategories: []),
                .category(name: "Vehicle Simulation", subcategories: []),
                .category(name: "Construction and Management Simulation", subcategories: []),
                .category(name: "Farming Simulation", subcategories: []),
                .category(name: "Flight Simulation", subcategories: [])
            ]),
            .category(name: "Strategy", subcategories: [
                .category(name: "Real-Time Strategy", subcategories: []),
                .category(name: "Turn-Based Strategy", subcategories: []),
                .category(name: "Tower Defense", subcategories: []),
                .category(name: "4X Strategy", subcategories: []),
                .category(name: "Tactical Strategy", subcategories: [])
            ]),
            .category(name: "Sports", subcategories: [
                .category(name: "Football", subcategories: []),
                .category(name: "Basketball", subcategories: []),
                .category(name: "Racing", subcategories: []),
                .category(name: "Golf", subcategories: []),
                .category(name: "Tennis", subcategories: [])
            ]),
            .category(name: "Puzzle", subcategories: [
                .category(name: "Match-Three", subcategories: []),
                .category(name: "Hidden Object", subcategories: []),
                .category(name: "Logic Puzzle", subcategories: []),
                .category(name: "Physics Puzzle", subcategories: []),
                .category(name: "Word Game", subcategories: [])
            ]),
            .category(name: "Party", subcategories: [
                .category(name: "Trivia", subcategories: []),
                .category(name: "Board Games", subcategories: []),
                .category(name: "Card Games", subcategories: []),
                .category(name: "Music and Dance", subcategories: []),
                .category(name: "Mini-Games", subcategories: [])
            ]),
            .category(name: "Casual", subcategories: [
                .category(name: "Idle Games", subcategories: []),
                .category(name: "Clicker Games", subcategories: []),
                .category(name: "Social Simulation", subcategories: []),
                .category(name: "Endless Runner", subcategories: []),
                .category(name: "Mobile Games", subcategories: [])
            ]),
            .category(name: "Educational", subcategories: [
                .category(name: "Math Games", subcategories: []),
                .category(name: "Language Learning", subcategories: []),
                .category(name: "Typing Games", subcategories: []),
                .category(name: "Science Games", subcategories: []),
                .category(name: "History Games", subcategories: [])
            ])
        ]),
        .category(name: "Kids", subcategories: [
            .category(name: "Cartoons", subcategories: []),
            .category(name: "Educational Videos", subcategories: []),
            .category(name: "Toys Reviews", subcategories: []),
            .category(name: "Kids Songs", subcategories: []),
            .category(name: "Story Time", subcategories: [])
        ]),
        .category(name: "Hobbies", subcategories: [
            .category(name: "Model Building", subcategories: []),
            .category(name: "Photography", subcategories: []),
            .category(name: "Collecting", subcategories: []),
            .category(name: "Gardening", subcategories: []),
            .category(name: "Bird Watching", subcategories: [])
        ]),
        .category(name: "Automotive", subcategories: [
            .category(name: "Car Reviews", subcategories: []),
            .category(name: "Maintenance Tips", subcategories: []),
            .category(name: "Car Modifications", subcategories: []),
            .category(name: "Driving Techniques", subcategories: []),
            .category(name: "Auto Shows", subcategories: [])
        ])

    ]

}

