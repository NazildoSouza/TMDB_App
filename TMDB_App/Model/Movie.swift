//
//  Movie.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 10/08/20.
//

import Foundation

struct MovieResponse: Codable {

    let page: Int
    let results: [Movie]
    let totalResults, totalPages: Int?
}

struct Movie: Codable, Identifiable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let posterPath: String?
    let popularity: Double?
    let id: Int
    let overview: String?
    let backdropPath: String?
    let voteAverage: Double?
    let mediaType: MediaType?
    let firstAirDate: String?
    let originCountry: [String]?
    let genreIDS: [Int]?
  //  let originalLanguage: OriginalLanguage?
    let voteCount: Int?
    let name, originalName: String?
    let adult: Bool?
    let releaseDate, originalTitle, title: String?
    let video: Bool?
    let profilePath: String?
    let knownFor: [Movie]?
    let episodeRunTime: [Int]?
    let runtime: Int?
    let birthday, knownForDepartment, biography: String?
    let placeOfBirth: String?
    let gender: Int?
    let budget: Int?
    let revenue: Int?
    var onHover: Bool?
    
    
    var genres: [MovieGenre]?
    var credits: MovieCredit?
    var videos: MovieVideoResponse?

    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    static private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()

    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var profileURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath ?? "")")!
    }

    var genreText: String {
        //  genres?.first?.name ?? "n/a"
        let genresString = genres?.map { $0.name }.joined(separator: ", ") ?? "-"
        return genresString
    }

    var ratingText: String {
        let rating = Int(voteAverage ?? 0)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }

    var scoreText: String {
        guard ratingText.count > 0 else {
            return "-"
        }
        return "\(ratingText.count)/10"
    }

    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "-"
        }
        return Movie.yearFormatter.string(from: date)
    }

    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "-"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "-"
    }
    
    var yearTextSerie: String {
        guard let firstAirDate = self.firstAirDate, let date = Utils.dateFormatter.date(from: firstAirDate) else {
            return "-"
        }
        return Movie.yearFormatter.string(from: date)
    }

    var durationTextSerie: String {
        guard let episodeRunTime = self.episodeRunTime?.first, episodeRunTime > 0 else {
            return "-"
        }
        return Movie.durationFormatter.string(from: TimeInterval(episodeRunTime) * 60) ?? "-"
    }
    
    var budgetText: String {
        guard let budget = self.budget, budget > 0 else {
            return "-"
        }
        return Movie.currencyFormatter.string(from: NSNumber(value: budget)) ?? "-"
    }
    
    var revenueText: String {
        guard let revenue = self.revenue, revenue > 0 else {
            return "-"
        }
        return Movie.currencyFormatter.string(from: NSNumber(value: revenue)) ?? "-"
    }

    var cast: [MovieCast]? {
        credits?.cast
    }

    var crew: [MovieCrew]? {
        credits?.crew
    }

    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }

    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }

    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }

    var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }

}

struct MovieGenre: Codable {

    let name: String
}

struct MovieCredit: Codable {

    var cast: [MovieCast]
    var crew: [MovieCrew]
}

struct MovieCast: Codable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let profilePath: String?
    var onHover: Bool?

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath ?? "")")!
    }
}

struct MovieCrew: Codable, Identifiable {
    let id: Int
    let job: String
    let name: String
    let profilePath: String?
    var onHover: Bool?

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath ?? "")")!
    }
}

struct MovieVideoResponse: Codable {

    var results: [MovieVideo]
}

struct MovieVideo: Codable, Identifiable {

    let id: String
    let key: String
    let name: String
    let site: String
    var onHover: Bool?

    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}

enum MediaType: String, CaseIterable, Codable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
    
    var description: String {
        switch self {
        case .movie: return "Filmes"
        case .tv: return "Séries"
        case .person: return "Pessoas"
        }
    }
}

enum PersonLink {
    case navigation, sheet
}


//enum OriginalLanguage: String, Decodable {
//    case en = "en"
//    case it = "it"
//}

