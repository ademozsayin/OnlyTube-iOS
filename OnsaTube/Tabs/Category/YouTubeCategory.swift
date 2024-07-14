import Foundation
import SwiftUI
import Models

extension YouTubeCategory {
    func toDraft() -> Draft {
        return Draft(content: name)
    }
}

enum YouTubeCategory: Equatable, Hashable {
    case category(name: String, subcategories: [YouTubeCategory])
    
    var name: String  {
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
        .category(name: Localization.music.music, subcategories: [
            .category(name: Localization.music.pop.pop, subcategories: [
                .category(name: Localization.music.pop.indiePop, subcategories: []),
                .category(name: Localization.music.pop.synthPop, subcategories: []),
                .category(name: Localization.music.pop.kPop, subcategories: []),
                .category(name: Localization.music.pop.popRock, subcategories: []),
                .category(name: Localization.music.pop.popPunk, subcategories: [])
            ]),
            .category(name: Localization.music.rock.rock, subcategories: [
                .category(name: Localization.music.rock.classicRock, subcategories: []),
                .category(name: Localization.music.rock.hardRock, subcategories: []),
                .category(name: Localization.music.rock.alternativeRock, subcategories: []),
                .category(name: Localization.music.rock.punkRock, subcategories: []),
                .category(name: Localization.music.rock.indieRock, subcategories: [])
            ]),
            .category(name: Localization.music.hipHop.hipHop, subcategories: [
                .category(name: Localization.music.hipHop.rap, subcategories: []),
                .category(name: Localization.music.hipHop.trap, subcategories: []),
                .category(name: Localization.music.hipHop.loFiHipHop, subcategories: []),
                .category(name: Localization.music.hipHop.boomBap, subcategories: []),
                .category(name: Localization.music.hipHop.gangstaRap, subcategories: [])
            ]),
            .category(name: Localization.music.classical.classical, subcategories: [
                .category(name: Localization.music.classical.baroque, subcategories: []),
                .category(name: Localization.music.classical.romantic, subcategories: []),
                .category(name: Localization.music.classical.modernClassical, subcategories: []),
                .category(name: Localization.music.classical.chamberMusic, subcategories: []),
                .category(name: Localization.music.classical.opera, subcategories: [])
            ]),
            .category(name: Localization.music.jazz.jazz, subcategories: [
                .category(name: Localization.music.jazz.smoothJazz, subcategories: []),
                .category(name: Localization.music.jazz.bebop, subcategories: []),
                .category(name: Localization.music.jazz.vocalJazz, subcategories: []),
                .category(name: Localization.music.jazz.swing, subcategories: []),
                .category(name: Localization.music.jazz.freeJazz, subcategories: [])
            ]),
            .category(name: Localization.music.electronic.electronic, subcategories: [
                .category(name: Localization.music.electronic.house, subcategories: []),
                .category(name: Localization.music.electronic.techno, subcategories: []),
                .category(name: Localization.music.electronic.trance, subcategories: []),
                .category(name: Localization.music.electronic.dubstep, subcategories: []),
                .category(name: Localization.music.electronic.drumAndBass, subcategories: [])
            ]),
            .category(name: Localization.music.country.country, subcategories: [
                .category(name: Localization.music.country.classicCountry, subcategories: []),
                .category(name: Localization.music.country.countryPop, subcategories: []),
                .category(name: Localization.music.country.bluegrass, subcategories: []),
                .category(name: Localization.music.country.altCountry, subcategories: []),
                .category(name: Localization.music.country.countryRock, subcategories: [])
            ]),
            .category(name: Localization.music.reggae.reggae, subcategories: [
                .category(name: Localization.music.reggae.dancehall, subcategories: []),
                .category(name: Localization.music.reggae.rootsReggae, subcategories: []),
                .category(name: Localization.music.reggae.dub, subcategories: []),
                .category(name: Localization.music.reggae.reggaeton, subcategories: []),
                .category(name: Localization.music.reggae.ska, subcategories: [])
            ]),
            .category(name: Localization.music.latin.latin, subcategories: [
                .category(name: Localization.music.latin.salsa, subcategories: []),
                .category(name: Localization.music.latin.bachata, subcategories: []),
                .category(name: Localization.music.latin.merengue, subcategories: []),
                .category(name: Localization.music.latin.latinPop, subcategories: []),
                .category(name: Localization.music.latin.reggaeton, subcategories: [])
            ]),
            .category(name: Localization.music.blues.blues, subcategories: [
                .category(name: Localization.music.blues.deltaBlues, subcategories: []),
                .category(name: Localization.music.blues.chicagoBlues, subcategories: []),
                .category(name: Localization.music.blues.electricBlues, subcategories: []),
                .category(name: Localization.music.blues.bluesRock, subcategories: []),
                .category(name: Localization.music.blues.acousticBlues, subcategories: [])
            ])
        ]),
        .category(name: Localization.education.education, subcategories: [
            .category(name: Localization.education.mathematics.mathematics, subcategories: [
                .category(name: Localization.education.mathematics.algebra, subcategories: []),
                .category(name: Localization.education.mathematics.calculus, subcategories: []),
                .category(name: Localization.education.mathematics.geometry, subcategories: []),
                .category(name: Localization.education.mathematics.trigonometry, subcategories: []),
                .category(name: Localization.education.mathematics.statistics, subcategories: [])
            ]),
            .category(name: Localization.education.science.science, subcategories: [
                .category(name: Localization.education.science.physics, subcategories: []),
                .category(name: Localization.education.science.biology, subcategories: []),
                .category(name: Localization.education.science.chemistry, subcategories: []),
                .category(name: Localization.education.science.earthScience, subcategories: []),
                .category(name: Localization.education.science.environmentalScience, subcategories: [])
            ]),
            .category(name: Localization.education.history.history, subcategories: [
                .category(name: Localization.education.history.ancientHistory, subcategories: []),
                .category(name: Localization.education.history.modernHistory, subcategories: []),
                .category(name: Localization.education.history.medievalHistory, subcategories: []),
                .category(name: Localization.education.history.americanHistory, subcategories: []),
                .category(name: Localization.education.history.worldHistory, subcategories: [])
            ]),
            .category(name: Localization.education.languages.languages, subcategories: [
                .category(name: Localization.education.languages.english, subcategories: []),
                .category(name: Localization.education.languages.spanish, subcategories: []),
                .category(name: Localization.education.languages.french, subcategories: []),
                .category(name: Localization.education.languages.chinese, subcategories: []),
                .category(name: Localization.education.languages.german, subcategories: [])
            ]),
            .category(name: Localization.education.technology.technology, subcategories: [
                .category(name: Localization.education.technology.coding, subcategories: []),
                .category(name: Localization.education.technology.robotics, subcategories: []),
                .category(name: Localization.education.technology.webDevelopment, subcategories: []),
                .category(name: Localization.education.technology.dataScience, subcategories: []),
                .category(name: Localization.education.technology.cybersecurity, subcategories: [])
            ]),
            .category(name: Localization.education.arts.arts, subcategories: [
                .category(name: Localization.education.arts.drawing, subcategories: []),
                .category(name: Localization.education.arts.painting, subcategories: []),
                .category(name: Localization.education.arts.sculpting, subcategories: []),
                .category(name: Localization.education.arts.photography, subcategories: []),
                .category(name: Localization.education.arts.musicTheory, subcategories: [])
            ]),
            .category(name: Localization.education.health.health, subcategories: [
                .category(name: Localization.education.health.nutrition, subcategories: []),
                .category(name: Localization.education.health.physicalEducation, subcategories: []),
                .category(name: Localization.education.health.mentalHealth, subcategories: []),
                .category(name: Localization.education.health.medicalScience, subcategories: []),
                .category(name: Localization.education.health.firstAid, subcategories: [])
            ]),
            .category(name: Localization.education.literature.literature, subcategories: [
                .category(name: Localization.education.literature.classics, subcategories: []),
                .category(name: Localization.education.literature.contemporary, subcategories: []),
                .category(name: Localization.education.literature.poetry, subcategories: []),
                .category(name: Localization.education.literature.drama, subcategories: []),
                .category(name: Localization.education.literature.shortStories, subcategories: [])
            ]),
            .category(name: Localization.education.geography.geography, subcategories: [
                .category(name: Localization.education.geography.physicalGeography, subcategories: []),
                .category(name: Localization.education.geography.humanGeography, subcategories: []),
                .category(name: Localization.education.geography.cartography, subcategories: []),
                .category(name: Localization.education.geography.geopolitics, subcategories: []),
                .category(name: Localization.education.geography.culturalGeography, subcategories: [])
            ]),
            .category(name: Localization.education.economics.economics, subcategories: [
                .category(name: Localization.education.economics.microeconomics, subcategories: []),
                .category(name: Localization.education.economics.macroeconomics, subcategories: []),
                .category(name: Localization.education.economics.developmentEconomics, subcategories: []),
                .category(name: Localization.education.economics.behavioralEconomics, subcategories: []),
                .category(name: Localization.education.economics.internationalEconomics, subcategories: [])
            ])
        ]),
        .category(name: Localization.entertainment.entertainment, subcategories: [
            .category(name: Localization.entertainment.movies.movies, subcategories: [
                .category(name: Localization.entertainment.movies.action, subcategories: []),
                .category(name: Localization.entertainment.movies.comedy, subcategories: []),
                .category(name: Localization.entertainment.movies.drama, subcategories: []),
                .category(name: Localization.entertainment.movies.horror, subcategories: []),
                .category(name: Localization.entertainment.movies.sciFi, subcategories: [])
            ]),
            .category(name: Localization.entertainment.tvShows.tvShows, subcategories: [
                .category(name: Localization.entertainment.tvShows.sitcoms, subcategories: []),
                .category(name: Localization.entertainment.tvShows.dramas, subcategories: []),
                .category(name: Localization.entertainment.tvShows.realityTV, subcategories: []),
                .category(name: Localization.entertainment.tvShows.documentaries, subcategories: []),
                .category(name: Localization.entertainment.tvShows.cartoons, subcategories: [])
            ]),
            .category(name: Localization.entertainment.talkShows.talkShows, subcategories: [
                .category(name: Localization.entertainment.talkShows.lateNight, subcategories: []),
                .category(name: Localization.entertainment.talkShows.daytime, subcategories: []),
                .category(name: Localization.entertainment.talkShows.radioShows, subcategories: []),
                .category(name: Localization.entertainment.talkShows.podcasts, subcategories: []),
                .category(name: Localization.entertainment.talkShows.interviewShows, subcategories: [])
            ]),
            .category(name: Localization.entertainment.celebrityNews.celebrityNews, subcategories: [
                .category(name: Localization.entertainment.celebrityNews.gossip, subcategories: []),
                .category(name: Localization.entertainment.celebrityNews.interviews, subcategories: []),
                .category(name: Localization.entertainment.celebrityNews.redCarpetEvents, subcategories: []),
                .category(name: Localization.entertainment.celebrityNews.celebrityScandals, subcategories: []),
                .category(name: Localization.entertainment.celebrityNews.awardShows, subcategories: [])
            ]),
            .category(name: Localization.entertainment.musicVideos.musicVideos, subcategories: [
                .category(name: Localization.entertainment.musicVideos.popMusicVideos, subcategories: []),
                .category(name: Localization.entertainment.musicVideos.rockMusicVideos, subcategories: []),
                .category(name: Localization.entertainment.musicVideos.hipHopMusicVideos, subcategories: []),
                .category(name: Localization.entertainment.musicVideos.countryMusicVideos, subcategories: []),
                .category(name: Localization.entertainment.musicVideos.indieMusicVideos, subcategories: [])
            ]),
            .category(name: Localization.entertainment.comedy.comedy, subcategories: [
                .category(name: Localization.entertainment.comedy.standUp, subcategories: []),
                .category(name: Localization.entertainment.comedy.sketchComedy, subcategories: []),
                .category(name: Localization.entertainment.comedy.parodies, subcategories: []),
                .category(name: Localization.entertainment.comedy.improv, subcategories: []),
                .category(name: Localization.entertainment.comedy.satire, subcategories: [])
            ]),
            .category(name: Localization.entertainment.drama.drama, subcategories: [
                .category(name: Localization.entertainment.drama.crimeDrama, subcategories: []),
                .category(name: Localization.entertainment.drama.romanticDrama, subcategories: []),
                .category(name: Localization.entertainment.drama.legalDrama, subcategories: []),
                .category(name: Localization.entertainment.drama.medicalDrama, subcategories: []),
                .category(name: Localization.entertainment.drama.politicalDrama, subcategories: [])
            ]),
            .category(name: Localization.entertainment.sciFiFantasy.sciFiFantasy, subcategories: [
                .category(name: Localization.entertainment.sciFiFantasy.spaceOpera, subcategories: []),
                .category(name: Localization.entertainment.sciFiFantasy.cyberpunk, subcategories: []),
                .category(name: Localization.entertainment.sciFiFantasy.epicFantasy, subcategories: []),
                .category(name: Localization.entertainment.sciFiFantasy.urbanFantasy, subcategories: []),
                .category(name: Localization.entertainment.sciFiFantasy.timeTravel, subcategories: [])
            ]),
            .category(name: Localization.entertainment.romance.romance, subcategories: [
                .category(name: Localization.entertainment.romance.romanticComedy, subcategories: []),
                .category(name: Localization.entertainment.romance.romanticDrama, subcategories: []),
                .category(name: Localization.entertainment.romance.historicalRomance, subcategories: []),
                .category(name: Localization.entertainment.romance.paranormalRomance, subcategories: []),
                .category(name: Localization.entertainment.romance.eroticRomance, subcategories: [])
            ]),
            .category(name: Localization.entertainment.actionAdventure.actionAdventure, subcategories: [
                .category(name: Localization.entertainment.actionAdventure.superhero, subcategories: []),
                .category(name: Localization.entertainment.actionAdventure.spy, subcategories: []),
                .category(name: Localization.entertainment.actionAdventure.martialArts, subcategories: []),
                .category(name: Localization.entertainment.actionAdventure.western, subcategories: []),
                .category(name: Localization.entertainment.actionAdventure.war, subcategories: [])
            ])
        ]),
        .category(name: Localization.newsAndPolitics.newsAndPolitics, subcategories: [
            .category(name: Localization.newsAndPolitics.worldNews.worldNews, subcategories: [
                .category(name: Localization.newsAndPolitics.worldNews.internationalRelations, subcategories: []),
                .category(name: Localization.newsAndPolitics.worldNews.globalConflicts, subcategories: []),
                .category(name: Localization.newsAndPolitics.worldNews.foreignPolicy, subcategories: []),
                .category(name: Localization.newsAndPolitics.worldNews.unAffairs, subcategories: []),
                .category(name: Localization.newsAndPolitics.worldNews.diplomacy, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.localNews.localNews, subcategories: [
                .category(name: Localization.newsAndPolitics.localNews.communityEvents, subcategories: []),
                .category(name: Localization.newsAndPolitics.localNews.localCrime, subcategories: []),
                .category(name: Localization.newsAndPolitics.localNews.municipalPolitics, subcategories: []),
                .category(name: Localization.newsAndPolitics.localNews.localEconomy, subcategories: []),
                .category(name: Localization.newsAndPolitics.localNews.weather, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.politics.politics, subcategories: [
                .category(name: Localization.newsAndPolitics.politics.elections, subcategories: []),
                .category(name: Localization.newsAndPolitics.politics.legislation, subcategories: []),
                .category(name: Localization.newsAndPolitics.politics.politicalAnalysis, subcategories: []),
                .category(name: Localization.newsAndPolitics.politics.campaigns, subcategories: []),
                .category(name: Localization.newsAndPolitics.politics.politicalDebates, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.economics.economics, subcategories: [
                .category(name: Localization.newsAndPolitics.economics.marketTrends, subcategories: []),
                .category(name: Localization.newsAndPolitics.economics.economicPolicy, subcategories: []),
                .category(name: Localization.newsAndPolitics.economics.personalFinance, subcategories: []),
                .category(name: Localization.newsAndPolitics.economics.globalEconomy, subcategories: []),
                .category(name: Localization.newsAndPolitics.economics.cryptocurrency, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.investigativeJournalism.investigativeJournalism, subcategories: [
                .category(name: Localization.newsAndPolitics.investigativeJournalism.corruption, subcategories: []),
                .category(name: Localization.newsAndPolitics.investigativeJournalism.crime, subcategories: []),
                .category(name: Localization.newsAndPolitics.investigativeJournalism.corporateMalfeasance, subcategories: []),
                .category(name: Localization.newsAndPolitics.investigativeJournalism.whistleblowers, subcategories: []),
                .category(name: Localization.newsAndPolitics.investigativeJournalism.humanRights, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.opinion.opinion, subcategories: [
                .category(name: Localization.newsAndPolitics.opinion.editorials, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinion.opEds, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinion.lettersToTheEditor, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinion.columns, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinion.blogs, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.interviews.interviews, subcategories: [
                .category(name: Localization.newsAndPolitics.interviews.politicians, subcategories: []),
                .category(name: Localization.newsAndPolitics.interviews.experts, subcategories: []),
                .category(name: Localization.newsAndPolitics.interviews.journalists, subcategories: []),
                .category(name: Localization.newsAndPolitics.interviews.activists, subcategories: []),
                .category(name: Localization.newsAndPolitics.interviews.celebrities, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.documentaries.documentaries, subcategories: [
                .category(name: Localization.newsAndPolitics.documentaries.politicalHistory, subcategories: []),
                .category(name: Localization.newsAndPolitics.documentaries.economicIssues, subcategories: []),
                .category(name: Localization.newsAndPolitics.documentaries.socialIssues, subcategories: []),
                .category(name: Localization.newsAndPolitics.documentaries.environmentalIssues, subcategories: []),
                .category(name: Localization.newsAndPolitics.documentaries.humanRights, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.opinionAnalysis.opinionAnalysis, subcategories: [
                .category(name: Localization.newsAndPolitics.opinionAnalysis.policyAnalysis, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinionAnalysis.politicalStrategy, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinionAnalysis.economicForecasting, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinionAnalysis.socialCommentary, subcategories: []),
                .category(name: Localization.newsAndPolitics.opinionAnalysis.mediaCritique, subcategories: [])
            ]),
            .category(name: Localization.newsAndPolitics.publicServiceAnnouncements.publicServiceAnnouncements, subcategories: [
                .category(name: Localization.newsAndPolitics.publicServiceAnnouncements.healthAdvisories, subcategories: []),
                .category(name: Localization.newsAndPolitics.publicServiceAnnouncements.safetyAlerts, subcategories: []),
                .category(name: Localization.newsAndPolitics.publicServiceAnnouncements.governmentAnnouncements, subcategories: []),
                .category(name: Localization.newsAndPolitics.publicServiceAnnouncements.weatherAlerts, subcategories: []),
                .category(name: Localization.newsAndPolitics.publicServiceAnnouncements.communityNotices, subcategories: [])
            ])
        ]),
        .category(name: Localization.sports.sports, subcategories: [
            .category(name: Localization.sports.football.football, subcategories: [
                .category(name: Localization.sports.football.premierLeague, subcategories: []),
                .category(name: Localization.sports.football.laLiga, subcategories: []),
                .category(name: Localization.sports.football.bundesliga, subcategories: []),
                .category(name: Localization.sports.football.serieA, subcategories: []),
                .category(name: Localization.sports.football.ligue1, subcategories: [])
            ]),
            .category(name: Localization.sports.basketball.basketball, subcategories: [
                .category(name: Localization.sports.basketball.nba, subcategories: []),
                .category(name: Localization.sports.basketball.euroLeague, subcategories: []),
                .category(name: Localization.sports.basketball.collegeBasketball, subcategories: []),
                .category(name: Localization.sports.basketball.wnba, subcategories: []),
                .category(name: Localization.sports.basketball.fiba, subcategories: [])
            ]),
            .category(name: Localization.sports.tennis.tennis, subcategories: [
                .category(name: Localization.sports.tennis.grandSlam, subcategories: []),
                .category(name: Localization.sports.tennis.atpTour, subcategories: []),
                .category(name: Localization.sports.tennis.wtaTour, subcategories: []),
                .category(name: Localization.sports.tennis.davisCup, subcategories: []),
                .category(name: Localization.sports.tennis.fedCup, subcategories: [])
            ]),
            .category(name: Localization.sports.cricket.cricket, subcategories: [
                .category(name: Localization.sports.cricket.testMatches, subcategories: []),
                .category(name: Localization.sports.cricket.odi, subcategories: []),
                .category(name: Localization.sports.cricket.t20, subcategories: []),
                .category(name: Localization.sports.cricket.ipl, subcategories: []),
                .category(name: Localization.sports.cricket.bbl, subcategories: [])
            ]),
            .category(name: Localization.sports.golf.golf, subcategories: [
                .category(name: Localization.sports.golf.pgaTour, subcategories: []),
                .category(name: Localization.sports.golf.europeanTour, subcategories: []),
                .category(name: Localization.sports.golf.lpga, subcategories: []),
                .category(name: Localization.sports.golf.majors, subcategories: []),
                .category(name: Localization.sports.golf.amateurGolf, subcategories: [])
            ]),
            .category(name: Localization.sports.motorsport.motorsport, subcategories: [
                .category(name: Localization.sports.motorsport.formula1, subcategories: []),
                .category(name: Localization.sports.motorsport.motogp, subcategories: []),
                .category(name: Localization.sports.motorsport.nascar, subcategories: []),
                .category(name: Localization.sports.motorsport.wrc, subcategories: []),
                .category(name: Localization.sports.motorsport.indycar, subcategories: [])
            ]),
            .category(name: Localization.sports.athletics.athletics, subcategories: [
                .category(name: Localization.sports.athletics.trackEvents, subcategories: []),
                .category(name: Localization.sports.athletics.fieldEvents, subcategories: []),
                .category(name: Localization.sports.athletics.marathons, subcategories: []),
                .category(name: Localization.sports.athletics.olympics, subcategories: []),
                .category(name: Localization.sports.athletics.paralympics, subcategories: [])
            ]),
            .category(name: Localization.sports.boxing.boxing, subcategories: [
                .category(name: Localization.sports.boxing.professional, subcategories: []),
                .category(name: Localization.sports.boxing.amateur, subcategories: []),
                .category(name: Localization.sports.boxing.heavyweight, subcategories: []),
                .category(name: Localization.sports.boxing.middleweight, subcategories: []),
                .category(name: Localization.sports.boxing.lightweight, subcategories: [])
            ]),
            .category(name: Localization.sports.wrestling.wrestling, subcategories: [
                .category(name: Localization.sports.wrestling.wwe, subcategories: []),
                .category(name: Localization.sports.wrestling.aew, subcategories: []),
                .category(name: Localization.sports.wrestling.njpw, subcategories: []),
                .category(name: Localization.sports.wrestling.impactWrestling, subcategories: []),
                .category(name: Localization.sports.wrestling.roh, subcategories: [])
            ]),
            .category(name: Localization.sports.cycling.cycling, subcategories: [
                .category(name: Localization.sports.cycling.roadRacing, subcategories: []),
                .category(name: Localization.sports.cycling.mountainBiking, subcategories: []),
                .category(name: Localization.sports.cycling.trackCycling, subcategories: []),
                .category(name: Localization.sports.cycling.cyclocross, subcategories: []),
                .category(name: Localization.sports.cycling.bmx, subcategories: [])
            ])
        ]),
        .category(name: Localization.gaming.gaming, subcategories: [
            .category(name: Localization.gaming.action.action, subcategories: [
                .category(name: Localization.gaming.action.firstPersonShooter, subcategories: []),
                .category(name: Localization.gaming.action.thirdPersonShooter, subcategories: []),
                .category(name: Localization.gaming.action.platformer, subcategories: []),
                .category(name: Localization.gaming.action.hackAndSlash, subcategories: []),
                .category(name: Localization.gaming.action.fighting, subcategories: [])
            ]),
            .category(name: Localization.gaming.adventure.adventure, subcategories: [
                .category(name: Localization.gaming.adventure.openWorld, subcategories: []),
                .category(name: Localization.gaming.adventure.narrative, subcategories: []),
                .category(name: Localization.gaming.adventure.pointAndClick, subcategories: []),
                .category(name: Localization.gaming.adventure.visualNovel, subcategories: []),
                .category(name: Localization.gaming.adventure.survival, subcategories: [])
            ]),
            .category(name: Localization.gaming.rolePlaying.rolePlaying, subcategories: [
                .category(name: Localization.gaming.rolePlaying.actionRPG, subcategories: []),
                .category(name: Localization.gaming.rolePlaying.jrpg, subcategories: []),
                .category(name: Localization.gaming.rolePlaying.mmorpg, subcategories: []),
                .category(name: Localization.gaming.rolePlaying.tacticalRPG, subcategories: []),
                .category(name: Localization.gaming.rolePlaying.dungeonCrawler, subcategories: [])
            ]),
            .category(name: Localization.gaming.simulation.simulation, subcategories: [
                .category(name: Localization.gaming.simulation.lifeSimulation, subcategories: []),
                .category(name: Localization.gaming.simulation.vehicleSimulation, subcategories: []),
                .category(name: Localization.gaming.simulation.constructionAndManagement, subcategories: []),
                .category(name: Localization.gaming.simulation.farmingSimulation, subcategories: []),
                .category(name: Localization.gaming.simulation.flightSimulation, subcategories: [])
            ]),
            .category(name: Localization.gaming.strategy.strategy, subcategories: [
                .category(name: Localization.gaming.strategy.realTimeStrategy, subcategories: []),
                .category(name: Localization.gaming.strategy.turnBasedStrategy, subcategories: []),
                .category(name: Localization.gaming.strategy.towerDefense, subcategories: []),
                .category(name: Localization.gaming.strategy.fourXStrategy, subcategories: []),
                .category(name: Localization.gaming.strategy.tacticalStrategy, subcategories: [])
            ]),
            .category(name: Localization.gaming.sports.sports, subcategories: [
                .category(name: Localization.gaming.sports.football, subcategories: []),
                .category(name: Localization.gaming.sports.basketball, subcategories: []),
                .category(name: Localization.gaming.sports.racing, subcategories: []),
                .category(name: Localization.gaming.sports.golf, subcategories: []),
                .category(name: Localization.gaming.sports.tennis, subcategories: []),
            ]),
            .category(name: Localization.gaming.puzzle.puzzle, subcategories: [
                .category(name: Localization.gaming.puzzle.matchThree, subcategories: []),
                .category(name: Localization.gaming.puzzle.hiddenObject, subcategories: []),
                .category(name: Localization.gaming.puzzle.logicPuzzle, subcategories: []),
                .category(name: Localization.gaming.puzzle.physicsPuzzle, subcategories: []),
                .category(name: Localization.gaming.puzzle.wordGame, subcategories: []),
            ]),
            .category(name: Localization.gaming.party.party, subcategories: [
                .category(name: Localization.gaming.party.trivia, subcategories: []),
                .category(name: Localization.gaming.party.boardGames, subcategories: []),
                .category(name: Localization.gaming.party.cardGames, subcategories: []),
                .category(name: Localization.gaming.party.musicAndDance, subcategories: []),
                .category(name: Localization.gaming.party.miniGames, subcategories: [])
            ]),
            .category(name: Localization.gaming.casual.casual, subcategories: [
                .category(name: Localization.gaming.casual.idleGames, subcategories: []),
                .category(name: Localization.gaming.casual.clickerGames, subcategories: []),
                .category(name: Localization.gaming.casual.socialSimulation, subcategories: []),
                .category(name: Localization.gaming.casual.endlessRunner, subcategories: []),
                .category(name: Localization.gaming.casual.mobileGames, subcategories: [])
            ]),
            .category(name: Localization.educational.educational, subcategories: [
                .category(name: Localization.educational.mathGames, subcategories: []),
                .category(name: Localization.educational.languageLearning, subcategories: []),
                .category(name: Localization.educational.typingGames, subcategories: []),
                .category(name: Localization.educational.scienceGames, subcategories: []),
                .category(name: Localization.educational.historyGames, subcategories: [])
            ])
        ]),
        .category(name: Localization.kids.kids, subcategories: [
            .category(name: Localization.kids.cartoons, subcategories: []),
            .category(name: Localization.kids.educationalVideos, subcategories: []),
            .category(name: Localization.kids.toysReviews, subcategories: []),
            .category(name: Localization.kids.kidsSongs, subcategories: []),
            .category(name: Localization.kids.storyTime, subcategories: [])
        ]),
        .category(name: Localization.hobbies.hobbies, subcategories: [
            .category(name: Localization.hobbies.modelBuilding, subcategories: []),
            .category(name: Localization.hobbies.photography, subcategories: []),
            .category(name: Localization.hobbies.collecting, subcategories: []),
            .category(name: Localization.hobbies.gardening, subcategories: []),
            .category(name: Localization.hobbies.birdWatching, subcategories: [])
        ]),
        .category(name: Localization.automotive.automotive, subcategories: [
            .category(name: Localization.automotive.carReviews, subcategories: []),
            .category(name: Localization.automotive.maintenanceTips, subcategories: []),
            .category(name: Localization.automotive.carModifications, subcategories: []),
            .category(name: Localization.automotive.drivingTechniques, subcategories: []),
            .category(name: Localization.automotive.autoShows, subcategories: [])
        ])

    ]

}

extension YouTubeCategory {
   
    enum Localization {
        
        enum music {
            static let music = NSLocalizedString("youtube.category.Music", comment: "Music category name")
            
            enum pop {
                static let pop = NSLocalizedString("youtube.category.Pop", comment: "Pop category name")
                static let indiePop = NSLocalizedString("youtube.category.IndiePop", comment: "Indie Pop category name")
                static let synthPop = NSLocalizedString("youtube.category.SynthPop", comment: "Synth Pop category name")
                static let kPop = NSLocalizedString("youtube.category.KPop", comment: "K-Pop category name")
                static let popRock = NSLocalizedString("youtube.category.PopRock", comment: "Pop Rock category name")
                static let popPunk = NSLocalizedString("youtube.category.PopPunk", comment: "Pop Punk category name")
            }
            
            enum rock {
                static let rock = NSLocalizedString("youtube.category.Rock", comment: "Rock category name")
                static let classicRock = NSLocalizedString("youtube.category.ClassicRock", comment: "Classic Rock category name")
                static let hardRock = NSLocalizedString("youtube.category.HardRock", comment: "Hard Rock category name")
                static let alternativeRock = NSLocalizedString("youtube.category.AlternativeRock", comment: "Alternative Rock category name")
                static let punkRock = NSLocalizedString("youtube.category.PunkRock", comment: "Punk Rock category name")
                static let indieRock = NSLocalizedString("youtube.category.IndieRock", comment: "Indie Rock category name")
            }
            
            enum hipHop {
                static let hipHop = NSLocalizedString("youtube.category.HipHop", comment: "Hip-Hop category name")
                static let rap = NSLocalizedString("youtube.category.Rap", comment: "Rap category name")
                static let trap = NSLocalizedString("youtube.category.Trap", comment: "Trap category name")
                static let loFiHipHop = NSLocalizedString("youtube.category.LoFiHipHop", comment: "Lo-Fi Hip-Hop category name")
                static let boomBap = NSLocalizedString("youtube.category.BoomBap", comment: "Boom Bap category name")
                static let gangstaRap = NSLocalizedString("youtube.category.GangstaRap", comment: "Gangsta Rap category name")
            }
            
            enum classical {
                static let classical = NSLocalizedString("youtube.category.Classical", comment: "Classical category name")
                static let baroque = NSLocalizedString("youtube.category.Baroque", comment: "Baroque category name")
                static let romantic = NSLocalizedString("youtube.category.Romantic", comment: "Romantic category name")
                static let modernClassical = NSLocalizedString("youtube.category.ModernClassical", comment: "Modern Classical category name")
                static let chamberMusic = NSLocalizedString("youtube.category.ChamberMusic", comment: "Chamber Music category name")
                static let opera = NSLocalizedString("youtube.category.Opera", comment: "Opera category name")
            }
            
            enum jazz {
                static let jazz = NSLocalizedString("youtube.category.Jazz", comment: "Jazz category name")
                static let smoothJazz = NSLocalizedString("youtube.category.SmoothJazz", comment: "Smooth Jazz category name")
                static let bebop = NSLocalizedString("youtube.category.Bebop", comment: "Bebop category name")
                static let vocalJazz = NSLocalizedString("youtube.category.VocalJazz", comment: "Vocal Jazz category name")
                static let swing = NSLocalizedString("youtube.category.Swing", comment: "Swing category name")
                static let freeJazz = NSLocalizedString("youtube.category.FreeJazz", comment: "Free Jazz category name")
            }
            
            enum electronic {
                static let electronic = NSLocalizedString("youtube.category.Electronic", comment: "Electronic category name")
                static let house = NSLocalizedString("youtube.category.House", comment: "House category name")
                static let techno = NSLocalizedString("youtube.category.Techno", comment: "Techno category name")
                static let trance = NSLocalizedString("youtube.category.Trance", comment: "Trance category name")
                static let dubstep = NSLocalizedString("youtube.category.Dubstep", comment: "Dubstep category name")
                static let drumAndBass = NSLocalizedString("youtube.category.DrumAndBass", comment: "Drum and Bass category name")
            }
            
            enum country {
                static let country = NSLocalizedString("youtube.category.Country", comment: "Country category name")
                static let classicCountry = NSLocalizedString("youtube.category.ClassicCountry", comment: "Classic Country category name")
                static let countryPop = NSLocalizedString("youtube.category.CountryPop", comment: "Country Pop category name")
                static let bluegrass = NSLocalizedString("youtube.category.Bluegrass", comment: "Bluegrass category name")
                static let altCountry = NSLocalizedString("youtube.category.AltCountry", comment: "Alt-Country category name")
                static let countryRock = NSLocalizedString("youtube.category.CountryRock", comment: "Country Rock category name")
            }
            
            enum reggae {
                static let reggae = NSLocalizedString("youtube.category.Reggae", comment: "Reggae category name")
                static let dancehall = NSLocalizedString("youtube.category.Dancehall", comment: "Dancehall category name")
                static let rootsReggae = NSLocalizedString("youtube.category.RootsReggae", comment: "Roots Reggae category name")
                static let dub = NSLocalizedString("youtube.category.Dub", comment: "Dub category name")
                static let reggaeton = NSLocalizedString("youtube.category.Reggaeton", comment: "Reggaeton category name")
                static let ska = NSLocalizedString("youtube.category.Ska", comment: "Ska category name")
            }
            
            enum latin {
                static let latin = NSLocalizedString("youtube.category.Latin", comment: "Latin category name")
                static let salsa = NSLocalizedString("youtube.category.Salsa", comment: "Salsa category name")
                static let bachata = NSLocalizedString("youtube.category.Bachata", comment: "Bachata category name")
                static let merengue = NSLocalizedString("youtube.category.Merengue", comment: "Merengue category name")
                static let latinPop = NSLocalizedString("youtube.category.LatinPop", comment: "Latin Pop category name")
                static let reggaeton = NSLocalizedString("youtube.category.Reggaeton", comment: "Reggaeton category name")
            }
            
            enum blues {
                static let blues = NSLocalizedString("youtube.category.Blues", comment: "Blues category name")
                static let deltaBlues = NSLocalizedString("youtube.category.DeltaBlues", comment: "Delta Blues category name")
                static let chicagoBlues = NSLocalizedString("youtube.category.ChicagoBlues", comment: "Chicago Blues category name")
                static let electricBlues = NSLocalizedString("youtube.category.ElectricBlues", comment: "Electric Blues category name")
                static let bluesRock = NSLocalizedString("youtube.category.BluesRock", comment: "Blues Rock category name")
                static let acousticBlues = NSLocalizedString("youtube.category.AcousticBlues", comment: "Acoustic Blues category name")
            }
        }
        
        enum education {
            static let education = NSLocalizedString("youtube.category.Education", comment: "Education category name")
            
            enum mathematics {
                static let mathematics = NSLocalizedString("youtube.category.Mathematics", comment: "Mathematics category name")
                static let algebra = NSLocalizedString("youtube.category.Algebra", comment: "Algebra category name")
                static let calculus = NSLocalizedString("youtube.category.Calculus", comment: "Calculus category name")
                static let geometry = NSLocalizedString("youtube.category.Geometry", comment: "Geometry category name")
                static let trigonometry = NSLocalizedString("youtube.category.Trigonometry", comment: "Trigonometry category name")
                static let statistics = NSLocalizedString("youtube.category.Statistics", comment: "Statistics category name")
            }
            
            enum science {
                static let science = NSLocalizedString("youtube.category.Science", comment: "Science category name")
                static let physics = NSLocalizedString("youtube.category.Physics", comment: "Physics category name")
                static let biology = NSLocalizedString("youtube.category.Biology", comment: "Biology category name")
                static let chemistry = NSLocalizedString("youtube.category.Chemistry", comment: "Chemistry category name")
                static let earthScience = NSLocalizedString("youtube.category.EarthScience", comment: "Earth Science category name")
                static let environmentalScience = NSLocalizedString("youtube.category.EnvironmentalScience", comment: "Environmental Science category name")
            }
            
            enum history {
                static let history = NSLocalizedString("youtube.category.History", comment: "History category name")
                static let ancientHistory = NSLocalizedString("youtube.category.AncientHistory", comment: "Ancient History category name")
                static let modernHistory = NSLocalizedString("youtube.category.ModernHistory", comment: "Modern History category name")
                static let medievalHistory = NSLocalizedString("youtube.category.MedievalHistory", comment: "Medieval History category name")
                static let americanHistory = NSLocalizedString("youtube.category.AmericanHistory", comment: "American History category name")
                static let worldHistory = NSLocalizedString("youtube.category.WorldHistory", comment: "World History category name")
            }
            
            enum languages {
                static let languages = NSLocalizedString("youtube.category.Languages", comment: "Languages category name")
                static let english = NSLocalizedString("youtube.category.English", comment: "English category name")
                static let spanish = NSLocalizedString("youtube.category.Spanish", comment: "Spanish category name")
                static let french = NSLocalizedString("youtube.category.French", comment: "French category name")
                static let chinese = NSLocalizedString("youtube.category.Chinese", comment: "Chinese category name")
                static let german = NSLocalizedString("youtube.category.German", comment: "German category name")
            }
            
            enum technology {
                static let technology = NSLocalizedString("youtube.category.Technology", comment: "Technology category name")
                static let coding = NSLocalizedString("youtube.category.Coding", comment: "Coding category name")
                static let robotics = NSLocalizedString("youtube.category.Robotics", comment: "Robotics category name")
                static let webDevelopment = NSLocalizedString("youtube.category.WebDevelopment", comment: "Web Development category name")
                static let dataScience = NSLocalizedString("youtube.category.DataScience", comment: "Data Science category name")
                static let cybersecurity = NSLocalizedString("youtube.category.Cybersecurity", comment: "Cybersecurity category name")
            }
            
            enum arts {
                static let arts = NSLocalizedString("youtube.category.Arts", comment: "Arts category name")
                static let drawing = NSLocalizedString("youtube.category.Drawing", comment: "Drawing category name")
                static let painting = NSLocalizedString("youtube.category.Painting", comment: "Painting category name")
                static let sculpting = NSLocalizedString("youtube.category.Sculpting", comment: "Sculpting category name")
                static let photography = NSLocalizedString("youtube.category.Photography", comment: "Photography category name")
                static let musicTheory = NSLocalizedString("youtube.category.MusicTheory", comment: "Music Theory category name")
            }
            
            enum health {
                static let health = NSLocalizedString("youtube.category.Health", comment: "Health category name")
                static let nutrition = NSLocalizedString("youtube.category.Nutrition", comment: "Nutrition category name")
                static let physicalEducation = NSLocalizedString("youtube.category.PhysicalEducation", comment: "Physical Education category name")
                static let mentalHealth = NSLocalizedString("youtube.category.MentalHealth", comment: "Mental Health category name")
                static let medicalScience = NSLocalizedString("youtube.category.MedicalScience", comment: "Medical Science category name")
                static let firstAid = NSLocalizedString("youtube.category.FirstAid", comment: "First Aid category name")
            }
            
            enum literature {
                static let literature = NSLocalizedString("youtube.category.Literature", comment: "Literature category name")
                static let classics = NSLocalizedString("youtube.category.Classics", comment: "Classics category name")
                static let contemporary = NSLocalizedString("youtube.category.Contemporary", comment: "Contemporary category name")
                static let poetry = NSLocalizedString("youtube.category.Poetry", comment: "Poetry category name")
                static let drama = NSLocalizedString("youtube.category.Drama", comment: "Drama category name")
                static let shortStories = NSLocalizedString("youtube.category.ShortStories", comment: "Short Stories category name")
            }
            
            enum geography {
                static let geography = NSLocalizedString("youtube.category.Geography", comment: "Geography category name")
                static let physicalGeography = NSLocalizedString("youtube.category.PhysicalGeography", comment: "Physical Geography category name")
                static let humanGeography = NSLocalizedString("youtube.category.HumanGeography", comment: "Human Geography category name")
                static let cartography = NSLocalizedString("youtube.category.Cartography", comment: "Cartography category name")
                static let geopolitics = NSLocalizedString("youtube.category.Geopolitics", comment: "Geopolitics category name")
                static let culturalGeography = NSLocalizedString("youtube.category.CulturalGeography", comment: "Cultural Geography category name")
            }
            
            enum economics {
                static let economics = NSLocalizedString("youtube.category.Economics", comment: "Economics category name")
                static let microeconomics = NSLocalizedString("youtube.category.Microeconomics", comment: "Microeconomics category name")
                static let macroeconomics = NSLocalizedString("youtube.category.Macroeconomics", comment: "Macroeconomics category name")
                static let developmentEconomics = NSLocalizedString("youtube.category.DevelopmentEconomics", comment: "Development Economics category name")
                static let behavioralEconomics = NSLocalizedString("youtube.category.BehavioralEconomics", comment: "Behavioral Economics category name")
                static let internationalEconomics = NSLocalizedString("youtube.category.InternationalEconomics", comment: "International Economics category name")
            }
        }
        
        enum entertainment {
            static let entertainment = NSLocalizedString("youtube.category.Entertainment", comment: "Entertainment category name")
            
            enum movies {
                static let movies = NSLocalizedString("youtube.category.Movies", comment: "Movies category name")
                static let action = NSLocalizedString("youtube.category.Action", comment: "Action category name")
                static let comedy = NSLocalizedString("youtube.category.Comedy", comment: "Comedy category name")
                static let drama = NSLocalizedString("youtube.category.Drama", comment: "Drama category name")
                static let horror = NSLocalizedString("youtube.category.Horror", comment: "Horror category name")
                static let sciFi = NSLocalizedString("youtube.category.SciFi", comment: "Sci-Fi category name")
            }
            
            enum tvShows {
                static let tvShows = NSLocalizedString("youtube.category.TVShows", comment: "TV Shows category name")
                static let sitcoms = NSLocalizedString("youtube.category.Sitcoms", comment: "Sitcoms category name")
                static let dramas = NSLocalizedString("youtube.category.Dramas", comment: "Dramas category name")
                static let realityTV = NSLocalizedString("youtube.category.RealityTV", comment: "Reality TV category name")
                static let documentaries = NSLocalizedString("youtube.category.Documentaries", comment: "Documentaries category name")
                static let cartoons = NSLocalizedString("youtube.category.Cartoons", comment: "Cartoons category name")
            }
            
            enum talkShows {
                static let talkShows = NSLocalizedString("youtube.category.TalkShows", comment: "Talk Shows category name")
                static let lateNight = NSLocalizedString("youtube.category.LateNight", comment: "Late Night category name")
                static let daytime = NSLocalizedString("youtube.category.Daytime", comment: "Daytime category name")
                static let radioShows = NSLocalizedString("youtube.category.RadioShows", comment: "Radio Shows category name")
                static let podcasts = NSLocalizedString("youtube.category.Podcasts", comment: "Podcasts category name")
                static let interviewShows = NSLocalizedString("youtube.category.InterviewShows", comment: "Interview Shows category name")
            }
            
            enum celebrityNews {
                static let celebrityNews = NSLocalizedString("youtube.category.CelebrityNews", comment: "Celebrity News category name")
                static let gossip = NSLocalizedString("youtube.category.Gossip", comment: "Gossip category name")
                static let interviews = NSLocalizedString("youtube.category.Interviews", comment: "Interviews category name")
                static let redCarpetEvents = NSLocalizedString("youtube.category.RedCarpetEvents", comment: "Red Carpet Events category name")
                static let celebrityScandals = NSLocalizedString("youtube.category.CelebrityScandals", comment: "Celebrity Scandals category name")
                static let awardShows = NSLocalizedString("youtube.category.AwardShows", comment: "Award Shows category name")
            }
            
            enum musicVideos {
                static let musicVideos = NSLocalizedString("youtube.category.MusicVideos", comment: "Music Videos category name")
                static let popMusicVideos = NSLocalizedString("youtube.category.PopMusicVideos", comment: "Pop Music Videos category name")
                static let rockMusicVideos = NSLocalizedString("youtube.category.RockMusicVideos", comment: "Rock Music Videos category name")
                static let hipHopMusicVideos = NSLocalizedString("youtube.category.HipHopMusicVideos", comment: "Hip-Hop Music Videos category name")
                static let countryMusicVideos = NSLocalizedString("youtube.category.CountryMusicVideos", comment: "Country Music Videos category name")
                static let indieMusicVideos = NSLocalizedString("youtube.category.IndieMusicVideos", comment: "Indie Music Videos category name")
            }
            
            enum comedy {
                static let comedy = NSLocalizedString("youtube.category.Comedy", comment: "Comedy category name")
                static let standUp = NSLocalizedString("youtube.category.StandUp", comment: "Stand-Up category name")
                static let sketchComedy = NSLocalizedString("youtube.category.SketchComedy", comment: "Sketch Comedy category name")
                static let parodies = NSLocalizedString("youtube.category.Parodies", comment: "Parodies category name")
                static let improv = NSLocalizedString("youtube.category.Improv", comment: "Improv category name")
                static let satire = NSLocalizedString("youtube.category.Satire", comment: "Satire category name")
            }
            
            enum drama {
                static let drama = NSLocalizedString("youtube.category.Drama", comment: "Drama category name")
                static let crimeDrama = NSLocalizedString("youtube.category.CrimeDrama", comment: "Crime Drama category name")
                static let romanticDrama = NSLocalizedString("youtube.category.RomanticDrama", comment: "Romantic Drama category name")
                static let legalDrama = NSLocalizedString("youtube.category.LegalDrama", comment: "Legal Drama category name")
                static let medicalDrama = NSLocalizedString("youtube.category.MedicalDrama", comment: "Medical Drama category name")
                static let politicalDrama = NSLocalizedString("youtube.category.PoliticalDrama", comment: "Political Drama category name")
            }
            
            enum sciFiFantasy {
                static let sciFiFantasy = NSLocalizedString("youtube.category.SciFiFantasy", comment: "Sci-Fi & Fantasy category name")
                static let spaceOpera = NSLocalizedString("youtube.category.SpaceOpera", comment: "Space Opera category name")
                static let cyberpunk = NSLocalizedString("youtube.category.Cyberpunk", comment: "Cyberpunk category name")
                static let epicFantasy = NSLocalizedString("youtube.category.EpicFantasy", comment: "Epic Fantasy category name")
                static let urbanFantasy = NSLocalizedString("youtube.category.UrbanFantasy", comment: "Urban Fantasy category name")
                static let timeTravel = NSLocalizedString("youtube.category.TimeTravel", comment: "Time Travel category name")
            }
            
            enum romance {
                static let romance = NSLocalizedString("youtube.category.Romance", comment: "Romance category name")
                static let romanticComedy = NSLocalizedString("youtube.category.RomanticComedy", comment: "Romantic Comedy category name")
                static let romanticDrama = NSLocalizedString("youtube.category.RomanticDrama", comment: "Romantic Drama category name")
                static let historicalRomance = NSLocalizedString("youtube.category.HistoricalRomance", comment: "Historical Romance category name")
                static let paranormalRomance = NSLocalizedString("youtube.category.ParanormalRomance", comment: "Paranormal Romance category name")
                static let eroticRomance = NSLocalizedString("youtube.category.EroticRomance", comment: "Erotic Romance category name")
            }
            
            enum actionAdventure {
                static let actionAdventure = NSLocalizedString("youtube.category.ActionAdventure", comment: "Action & Adventure category name")
                static let superhero = NSLocalizedString("youtube.category.Superhero", comment: "Superhero category name")
                static let spy = NSLocalizedString("youtube.category.Spy", comment: "Spy category name")
                static let martialArts = NSLocalizedString("youtube.category.MartialArts", comment: "Martial Arts category name")
                static let western = NSLocalizedString("youtube.category.Western", comment: "Western category name")
                static let war = NSLocalizedString("youtube.category.War", comment: "War category name")
            }
        }
        
        enum newsAndPolitics {
            static let newsAndPolitics = NSLocalizedString("youtube.category.NewsAndPolitics", comment: "News & Politics category name")
            
            enum worldNews {
                static let worldNews = NSLocalizedString("youtube.category.WorldNews", comment: "World News category name")
                static let internationalRelations = NSLocalizedString("youtube.category.InternationalRelations", comment: "International Relations category name")
                static let globalConflicts = NSLocalizedString("youtube.category.GlobalConflicts", comment: "Global Conflicts category name")
                static let foreignPolicy = NSLocalizedString("youtube.category.ForeignPolicy", comment: "Foreign Policy category name")
                static let unAffairs = NSLocalizedString("youtube.category.UNAffairs", comment: "UN Affairs category name")
                static let diplomacy = NSLocalizedString("youtube.category.Diplomacy", comment: "Diplomacy category name")
            }
            
            enum localNews {
                static let localNews = NSLocalizedString("youtube.category.LocalNews", comment: "Local News category name")
                static let communityEvents = NSLocalizedString("youtube.category.CommunityEvents", comment: "Community Events category name")
                static let localCrime = NSLocalizedString("youtube.category.LocalCrime", comment: "Local Crime category name")
                static let municipalPolitics = NSLocalizedString("youtube.category.MunicipalPolitics", comment: "Municipal Politics category name")
                static let localEconomy = NSLocalizedString("youtube.category.LocalEconomy", comment: "Local Economy category name")
                static let weather = NSLocalizedString("youtube.category.Weather", comment: "Weather category name")
            }
            
            enum politics {
                static let politics = NSLocalizedString("youtube.category.Politics", comment: "Politics category name")
                static let elections = NSLocalizedString("youtube.category.Elections", comment: "Elections category name")
                static let legislation = NSLocalizedString("youtube.category.Legislation", comment: "Legislation category name")
                static let politicalAnalysis = NSLocalizedString("youtube.category.PoliticalAnalysis", comment: "Political Analysis category name")
                static let campaigns = NSLocalizedString("youtube.category.Campaigns", comment: "Campaigns category name")
                static let politicalDebates = NSLocalizedString("youtube.category.PoliticalDebates", comment: "Political Debates category name")
            }
            
            enum economics {
                static let economics = NSLocalizedString("youtube.category.Economics", comment: "Economics category name")
                static let marketTrends = NSLocalizedString("youtube.category.MarketTrends", comment: "Market Trends category name")
                static let economicPolicy = NSLocalizedString("youtube.category.EconomicPolicy", comment: "Economic Policy category name")
                static let personalFinance = NSLocalizedString("youtube.category.PersonalFinance", comment: "Personal Finance category name")
                static let globalEconomy = NSLocalizedString("youtube.category.GlobalEconomy", comment: "Global Economy category name")
                static let cryptocurrency = NSLocalizedString("youtube.category.Cryptocurrency", comment: "Cryptocurrency category name")
            }
            
            enum investigativeJournalism {
                static let investigativeJournalism = NSLocalizedString("youtube.category.InvestigativeJournalism", comment: "Investigative Journalism category name")
                static let corruption = NSLocalizedString("youtube.category.Corruption", comment: "Corruption category name")
                static let crime = NSLocalizedString("youtube.category.Crime", comment: "Crime category name")
                static let corporateMalfeasance = NSLocalizedString("youtube.category.CorporateMalfeasance", comment: "Corporate Malfeasance category name")
                static let whistleblowers = NSLocalizedString("youtube.category.Whistleblowers", comment: "Whistleblowers category name")
                static let humanRights = NSLocalizedString("youtube.category.HumanRights", comment: "Human Rights category name")
            }
            
            enum opinion {
                static let opinion = NSLocalizedString("youtube.category.Opinion", comment: "Opinion category name")
                static let editorials = NSLocalizedString("youtube.category.Editorials", comment: "Editorials category name")
                static let opEds = NSLocalizedString("youtube.category.OpEds", comment: "Op-Eds category name")
                static let lettersToTheEditor = NSLocalizedString("youtube.category.LettersToTheEditor", comment: "Letters to the Editor category name")
                static let columns = NSLocalizedString("youtube.category.Columns", comment: "Columns category name")
                static let blogs = NSLocalizedString("youtube.category.Blogs", comment: "Blogs category name")
            }
            
            enum interviews {
                static let interviews = NSLocalizedString("youtube.category.Interviews", comment: "Interviews category name")
                static let politicians = NSLocalizedString("youtube.category.Politicians", comment: "Politicians category name")
                static let experts = NSLocalizedString("youtube.category.Experts", comment: "Experts category name")
                static let journalists = NSLocalizedString("youtube.category.Journalists", comment: "Journalists category name")
                static let activists = NSLocalizedString("youtube.category.Activists", comment: "Activists category name")
                static let celebrities = NSLocalizedString("youtube.category.Celebrities", comment: "Celebrities category name")
            }
            
            enum documentaries {
                static let documentaries = NSLocalizedString("youtube.category.Documentaries", comment: "Documentaries category name")
                static let politicalHistory = NSLocalizedString("youtube.category.PoliticalHistory", comment: "Political History category name")
                static let economicIssues = NSLocalizedString("youtube.category.EconomicIssues", comment: "Economic Issues category name")
                static let socialIssues = NSLocalizedString("youtube.category.SocialIssues", comment: "Social Issues category name")
                static let environmentalIssues = NSLocalizedString("youtube.category.EnvironmentalIssues", comment: "Environmental Issues category name")
                static let humanRights = NSLocalizedString("youtube.category.HumanRights", comment: "Human Rights category name")
            }
            
            enum opinionAnalysis {
                static let opinionAnalysis = NSLocalizedString("youtube.category.OpinionAnalysis", comment: "Opinion Analysis category name")
                static let policyAnalysis = NSLocalizedString("youtube.category.PolicyAnalysis", comment: "Policy Analysis category name")
                static let politicalStrategy = NSLocalizedString("youtube.category.PoliticalStrategy", comment: "Political Strategy category name")
                static let economicForecasting = NSLocalizedString("youtube.category.EconomicForecasting", comment: "Economic Forecasting category name")
                static let socialCommentary = NSLocalizedString("youtube.category.SocialCommentary", comment: "Social Commentary category name")
                static let mediaCritique = NSLocalizedString("youtube.category.MediaCritique", comment: "Media Critique category name")
            }
            
            enum publicServiceAnnouncements {
                static let publicServiceAnnouncements = NSLocalizedString("youtube.category.PublicServiceAnnouncements", comment: "Public Service Announcements category name")
                static let healthAdvisories = NSLocalizedString("youtube.category.HealthAdvisories", comment: "Health Advisories category name")
                static let safetyAlerts = NSLocalizedString("youtube.category.SafetyAlerts", comment: "Safety Alerts category name")
                static let governmentAnnouncements = NSLocalizedString("youtube.category.GovernmentAnnouncements", comment: "Government Announcements category name")
                static let weatherAlerts = NSLocalizedString("youtube.category.WeatherAlerts", comment: "Weather Alerts category name")
                static let communityNotices = NSLocalizedString("youtube.category.CommunityNotices", comment: "Community Notices category name")
            }
        }
        
        enum sports {
            static let sports = NSLocalizedString("youtube.category.Sports", comment: "Sports category name")
            
            enum football {
                static let football = NSLocalizedString("youtube.category.Football", comment: "Football category name")
                static let premierLeague = NSLocalizedString("youtube.category.PremierLeague", comment: "Premier League category name")
                static let laLiga = NSLocalizedString("youtube.category.LaLiga", comment: "La Liga category name")
                static let bundesliga = NSLocalizedString("youtube.category.Bundesliga", comment: "Bundesliga category name")
                static let serieA = NSLocalizedString("youtube.category.SerieA", comment: "Serie A category name")
                static let ligue1 = NSLocalizedString("youtube.category.Ligue1", comment: "Ligue 1 category name")
            }
            
            enum basketball {
                static let basketball = NSLocalizedString("youtube.category.Basketball", comment: "Basketball category name")
                static let nba = NSLocalizedString("youtube.category.NBA", comment: "NBA category name")
                static let euroLeague = NSLocalizedString("youtube.category.EuroLeague", comment: "EuroLeague category name")
                static let collegeBasketball = NSLocalizedString("youtube.category.CollegeBasketball", comment: "College Basketball category name")
                static let wnba = NSLocalizedString("youtube.category.WNBA", comment: "WNBA category name")
                static let fiba = NSLocalizedString("youtube.category.FIBA", comment: "FIBA category name")
            }
            
            enum tennis {
                static let tennis = NSLocalizedString("youtube.category.Tennis", comment: "Tennis category name")
                static let grandSlam = NSLocalizedString("youtube.category.GrandSlam", comment: "Grand Slam category name")
                static let atpTour = NSLocalizedString("youtube.category.ATPTour", comment: "ATP Tour category name")
                static let wtaTour = NSLocalizedString("youtube.category.WTATour", comment: "WTA Tour category name")
                static let davisCup = NSLocalizedString("youtube.category.DavisCup", comment: "Davis Cup category name")
                static let fedCup = NSLocalizedString("youtube.category.FedCup", comment: "Fed Cup category name")
            }
            
            enum cricket {
                static let cricket = NSLocalizedString("youtube.category.Cricket", comment: "Cricket category name")
                static let testMatches = NSLocalizedString("youtube.category.TestMatches", comment: "Test Matches category name")
                static let odi = NSLocalizedString("youtube.category.ODI", comment: "ODI category name")
                static let t20 = NSLocalizedString("youtube.category.T20", comment: "T20 category name")
                static let ipl = NSLocalizedString("youtube.category.IPL", comment: "IPL category name")
                static let bbl = NSLocalizedString("youtube.category.BBL", comment: "BBL category name")
            }
            
            enum golf {
                static let golf = NSLocalizedString("youtube.category.Golf", comment: "Golf category name")
                static let pgaTour = NSLocalizedString("youtube.category.PGATour", comment: "PGA Tour category name")
                static let europeanTour = NSLocalizedString("youtube.category.EuropeanTour", comment: "European Tour category name")
                static let lpga = NSLocalizedString("youtube.category.LPGA", comment: "LPGA category name")
                static let majors = NSLocalizedString("youtube.category.Majors", comment: "Majors category name")
                static let amateurGolf = NSLocalizedString("youtube.category.AmateurGolf", comment: "Amateur Golf category name")
            }
            
            enum motorsport {
                static let motorsport = NSLocalizedString("youtube.category.Motorsport", comment: "Motorsport category name")
                static let formula1 = NSLocalizedString("youtube.category.Formula1", comment: "Formula 1 category name")
                static let motogp = NSLocalizedString("youtube.category.MotoGP", comment: "MotoGP category name")
                static let nascar = NSLocalizedString("youtube.category.NASCAR", comment: "NASCAR category name")
                static let wrc = NSLocalizedString("youtube.category.WRC", comment: "WRC category name")
                static let indycar = NSLocalizedString("youtube.category.IndyCar", comment: "IndyCar category name")
            }
            
            enum athletics {
                static let athletics = NSLocalizedString("youtube.category.Athletics", comment: "Athletics category name")
                static let trackEvents = NSLocalizedString("youtube.category.TrackEvents", comment: "Track Events category name")
                static let fieldEvents = NSLocalizedString("youtube.category.FieldEvents", comment: "Field Events category name")
                static let marathons = NSLocalizedString("youtube.category.Marathons", comment: "Marathons category name")
                static let olympics = NSLocalizedString("youtube.category.Olympics", comment: "Olympics category name")
                static let paralympics = NSLocalizedString("youtube.category.Paralympics", comment: "Paralympics category name")
            }
            
            enum boxing {
                static let boxing = NSLocalizedString("youtube.category.Boxing", comment: "Boxing category name")
                static let professional = NSLocalizedString("youtube.category.Professional", comment: "Professional category name")
                static let amateur = NSLocalizedString("youtube.category.Amateur", comment: "Amateur category name")
                static let heavyweight = NSLocalizedString("youtube.category.Heavyweight", comment: "Heavyweight category name")
                static let middleweight = NSLocalizedString("youtube.category.Middleweight", comment: "Middleweight category name")
                static let lightweight = NSLocalizedString("youtube.category.Lightweight", comment: "Lightweight category name")
            }
            
            enum wrestling {
                static let wrestling = NSLocalizedString("youtube.category.Wrestling", comment: "Wrestling category name")
                static let wwe = NSLocalizedString("youtube.category.WWE", comment: "WWE category name")
                static let aew = NSLocalizedString("youtube.category.AEW", comment: "AEW category name")
                static let njpw = NSLocalizedString("youtube.category.NJPW", comment: "NJPW category name")
                static let impactWrestling = NSLocalizedString("youtube.category.ImpactWrestling", comment: "Impact Wrestling category name")
                static let roh = NSLocalizedString("youtube.category.ROH", comment: "ROH category name")
            }
            
            enum cycling {
                static let cycling = NSLocalizedString("youtube.category.Cycling", comment: "Cycling category name")
                static let roadRacing = NSLocalizedString("youtube.category.RoadRacing", comment: "Road Racing category name")
                static let mountainBiking = NSLocalizedString("youtube.category.MountainBiking", comment: "Mountain Biking category name")
                static let trackCycling = NSLocalizedString("youtube.category.TrackCycling", comment: "Track Cycling category name")
                static let cyclocross = NSLocalizedString("youtube.category.Cyclocross", comment: "Cyclocross category name")
                static let bmx = NSLocalizedString("youtube.category.BMX", comment: "BMX category name")
            }
        }
       
        enum gaming {
            static let gaming = NSLocalizedString("youtube.category.Gaming", comment: "Gaming category name")
            
            enum action {
                static let action = NSLocalizedString("youtube.category.Action", comment: "Action category name")
                static let firstPersonShooter = NSLocalizedString("youtube.category.FirstPersonShooter", comment: "First-Person Shooter category name")
                static let thirdPersonShooter = NSLocalizedString("youtube.category.ThirdPersonShooter", comment: "Third-Person Shooter category name")
                static let platformer = NSLocalizedString("youtube.category.Platformer", comment: "Platformer category name")
                static let hackAndSlash = NSLocalizedString("youtube.category.HackAndSlash", comment: "Hack and Slash category name")
                static let fighting = NSLocalizedString("youtube.category.Fighting", comment: "Fighting category name")
            }
            
            enum adventure {
                static let adventure = NSLocalizedString("youtube.category.Adventure", comment: "Adventure category name")
                static let openWorld = NSLocalizedString("youtube.category.OpenWorld", comment: "Open World category name")
                static let narrative = NSLocalizedString("youtube.category.Narrative", comment: "Narrative category name")
                static let pointAndClick = NSLocalizedString("youtube.category.PointAndClick", comment: "Point-and-Click category name")
                static let visualNovel = NSLocalizedString("youtube.category.VisualNovel", comment: "Visual Novel category name")
                static let survival = NSLocalizedString("youtube.category.Survival", comment: "Survival category name")
            }
            
            enum rolePlaying {
                static let rolePlaying = NSLocalizedString("youtube.category.RolePlaying", comment: "Role-Playing category name")
                static let actionRPG = NSLocalizedString("youtube.category.ActionRPG", comment: "Action RPG category name")
                static let jrpg = NSLocalizedString("youtube.category.JRPG", comment: "JRPG category name")
                static let mmorpg = NSLocalizedString("youtube.category.MMORPG", comment: "MMORPG category name")
                static let tacticalRPG = NSLocalizedString("youtube.category.TacticalRPG", comment: "Tactical RPG category name")
                static let dungeonCrawler = NSLocalizedString("youtube.category.DungeonCrawler", comment: "Dungeon Crawler category name")
            }
            
            enum simulation {
                static let simulation = NSLocalizedString("youtube.category.Simulation", comment: "Simulation category name")
                static let lifeSimulation = NSLocalizedString("youtube.category.LifeSimulation", comment: "Life Simulation category name")
                static let vehicleSimulation = NSLocalizedString("youtube.category.VehicleSimulation", comment: "Vehicle Simulation category name")
                static let constructionAndManagement = NSLocalizedString("youtube.category.ConstructionAndManagementSimulation", comment: "Construction and Management Simulation category name")
                static let farmingSimulation = NSLocalizedString("youtube.category.FarmingSimulation", comment: "Farming Simulation category name")
                static let flightSimulation = NSLocalizedString("youtube.category.FlightSimulation", comment: "Flight Simulation category name")
            }
            
            enum strategy {
                static let strategy = NSLocalizedString("youtube.category.Strategy", comment: "Strategy category name")
                static let realTimeStrategy = NSLocalizedString("youtube.category.RealTimeStrategy", comment: "Real-Time Strategy category name")
                static let turnBasedStrategy = NSLocalizedString("youtube.category.TurnBasedStrategy", comment: "Turn-Based Strategy category name")
                static let towerDefense = NSLocalizedString("youtube.category.TowerDefense", comment: "Tower Defense category name")
                static let fourXStrategy = NSLocalizedString("youtube.category.FourXStrategy", comment: "4X Strategy category name")
                static let tacticalStrategy = NSLocalizedString("youtube.category.TacticalStrategy", comment: "Tactical Strategy category name")
            }
            
            enum sports {
                static let sports = NSLocalizedString("youtube.category.Sports", comment: "Sports category name")
                static let football = NSLocalizedString("youtube.category.Football", comment: "Football category name")
                static let basketball = NSLocalizedString("youtube.category.Basketball", comment: "Basketball category name")
                static let racing = NSLocalizedString("youtube.category.Racing", comment: "Racing category name")
                static let golf = NSLocalizedString("youtube.category.Golf", comment: "Golf category name")
                static let tennis = NSLocalizedString("youtube.category.Tennis", comment: "Tennis category name")
            }
            
            enum puzzle {
                static let puzzle = NSLocalizedString("youtube.category.Puzzle", comment: "Puzzle category name")
                static let matchThree = NSLocalizedString("youtube.category.MatchThree", comment: "Match-Three category name")
                static let hiddenObject = NSLocalizedString("youtube.category.HiddenObject", comment: "Hidden Object category name")
                static let logicPuzzle = NSLocalizedString("youtube.category.LogicPuzzle", comment: "Logic Puzzle category name")
                static let physicsPuzzle = NSLocalizedString("youtube.category.PhysicsPuzzle", comment: "Physics Puzzle category name")
                static let wordGame = NSLocalizedString("youtube.category.WordGame", comment: "Word Game category name")
            }
            
            enum party {
                static let party = NSLocalizedString("youtube.category.Party", comment: "Party category name")
                static let trivia = NSLocalizedString("youtube.category.Trivia", comment: "Trivia category name")
                static let boardGames = NSLocalizedString("youtube.category.BoardGames", comment: "Board Games category name")
                static let cardGames = NSLocalizedString("youtube.category.CardGames", comment: "Card Games category name")
                static let musicAndDance = NSLocalizedString("youtube.category.MusicAndDance", comment: "Music and Dance category name")
                static let miniGames = NSLocalizedString("youtube.category.MiniGames", comment: "Mini-Games category name")
            }
            
            enum casual {
                static let casual = NSLocalizedString("youtube.category.Casual", comment: "Casual category name")
                static let idleGames = NSLocalizedString("youtube.category.IdleGames", comment: "Idle Games category name")
                static let clickerGames = NSLocalizedString("youtube.category.ClickerGames", comment: "Clicker Games category name")
                static let socialSimulation = NSLocalizedString("youtube.category.SocialSimulation", comment: "Social Simulation category name")
                static let endlessRunner = NSLocalizedString("youtube.category.EndlessRunner", comment: "Endless Runner category name")
                static let mobileGames = NSLocalizedString("youtube.category.MobileGames", comment: "Mobile Games category name")
            }
        }
        
        enum educational {
            
            static let educational = NSLocalizedString("youtube.category.Educational", comment: "Educational category name")
            static let mathGames = NSLocalizedString("youtube.category.MathGames", comment: "Math Games category name")
            static let languageLearning = NSLocalizedString("youtube.category.LanguageLearning", comment: "Language Learning category name")
            static let typingGames = NSLocalizedString("youtube.category.TypingGames", comment: "Typing Games category name")
            static let scienceGames = NSLocalizedString("youtube.category.ScienceGames", comment: "Science Games category name")
            static let historyGames = NSLocalizedString("youtube.category.HistoryGames", comment: "History Games category name")
        }
        
        enum kids {
            static let kids = NSLocalizedString("youtube.category.Kids", comment: "")
            static let cartoons = NSLocalizedString("youtube.category.Cartoons", comment: "")
            static let educationalVideos = NSLocalizedString("youtube.category.EducationalVideos", comment: "")
            static let toysReviews = NSLocalizedString("youtube.category.ToysReviews", comment: "")
            static let kidsSongs = NSLocalizedString("youtube.category.KidsSongs", comment: "")
            static let storyTime = NSLocalizedString("youtube.category.StoryTime", comment: "")
        }
        
        enum hobbies {
            static let hobbies = NSLocalizedString("youtube.category.Hobbies", comment: "Hobbies category name")
            static let modelBuilding = NSLocalizedString("youtube.category.ModelBuilding", comment: "Model Building category name")
            static let photography = NSLocalizedString("youtube.category.Photography", comment: "Photography category name")
            static let collecting = NSLocalizedString("youtube.category.Collecting", comment: "Collecting category name")
            static let gardening = NSLocalizedString("youtube.category.Gardening", comment: "Gardening category name")
            static let birdWatching = NSLocalizedString("youtube.category.BirdWatching", comment: "Bird Watching category name")
        }
        
        enum automotive {
            static let automotive = NSLocalizedString("youtube.category.Automotive", comment: "Automotive category name")
            static let carReviews = NSLocalizedString("youtube.category.CarReviews", comment: "Car Reviews category name")
            static let maintenanceTips = NSLocalizedString("youtube.category.MaintenanceTips", comment: "Maintenance Tips category name")
            static let carModifications = NSLocalizedString("youtube.category.CarModifications", comment: "Car Modifications category name")
            static let drivingTechniques = NSLocalizedString("youtube.category.DrivingTechniques", comment: "Driving Techniques category name")
            static let autoShows = NSLocalizedString("youtube.category.AutoShows", comment: "Auto Shows category name")
        }
    }
}

