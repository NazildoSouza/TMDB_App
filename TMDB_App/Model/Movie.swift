//
//  Movie.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 10/08/20.
//

import Foundation

struct MovieResponse: Decodable {

    let page: Int
    let results: [Movie]
    let totalResults, totalPages: Int?
}

struct Movie: Decodable, Identifiable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

//    let id: Int
//    let title: String?
//    let name: String?
//    let backdropPath: String?
//    let posterPath: String?
//    let overview: String?
//    let voteAverage: Double?
//    let voteCount: Int?
//    let runtime: Int?
//    let releaseDate: String?
//    let episodeRunTime: [Int]?
//    let firstAirDate: String?
    
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
    
    
    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let videos: MovieVideoResponse?

    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
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
        genres?.first?.name ?? "n/a"
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
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }

    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }

    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var yearTextSerie: String {
        guard let firstAirDate = self.firstAirDate, let date = Utils.dateFormatter.date(from: firstAirDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }

    var durationTextSerie: String {
        guard let episodeRunTime = self.episodeRunTime?.first, episodeRunTime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(episodeRunTime) * 60) ?? "n/a"
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

struct MovieGenre: Decodable {

    let name: String
}

struct MovieCredit: Decodable {

    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let profilePath: String?

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath ?? "")")!
    }
}

struct MovieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
    let profilePath: String?

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath ?? "")")!
    }
}

struct MovieVideoResponse: Decodable {

    let results: [MovieVideo]
}

struct MovieVideo: Decodable, Identifiable {

    let id: String
    let key: String
    let name: String
    let site: String

    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}

enum MediaType: String, CaseIterable, Decodable {
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

//enum OriginalLanguage: String, Decodable {
//    case en = "en"
//    case it = "it"
//}

