//
//  MDHomeListViewModel.swift
//  MovieDirectory
//
//  Created by IndianRenters on 29/06/24.
//

import Foundation

class MDHomeListViewModel {
    
    var movies = [MovieElement]()
    var yearList = [String]()
    var genreList = [String]()
    var directorList = [String]()
    var actorList = [String]()
    
    var filteredMovies = [MovieElement]()
    var dataLoaded: (() -> ())?
    
    var filteredMoviesCount: Int {
        return filteredMovies.count
    }
    
    var yearCount : Int {
        return yearList.count
    }
    
    var genreCount: Int {
        return genreList.count
    }
    
    var directorCount: Int {
        return directorList.count
    }
    
    var actorCount: Int {
        return actorList.count
    }
    
    var moviesCount: Int {
        return movies.count
    }
    
    func getMovies() {
        loadJSONData()
    }
    
    
    func loadJSONData() {
            if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    movies = try JSONDecoder().decode([MovieElement].self, from: data)
                    
                    
                    yearList = Array(Set(movies.map{$0.year}))
                    
                    
                    
                    let genres = movies.flatMap { $0.genre.components(separatedBy: ", ") }
                    genreList = Array(Set(genres.map({$0})))
                    
                    
                    let directors = movies.flatMap({ $0.director.components(separatedBy: ", ")})
                    directorList = Array(Set(directors.map({$0}).filter({$0 != "N/A"})))
                    
                    
                    let actors = movies.flatMap { $0.actors.components(separatedBy: ", ") }
                    actorList = Array(Set(actors.map({$0}).filter({$0 != "N/A"})))
                    
                    dataLoaded?()
                } catch {
                    print("Error loading JSON data: \(error)")
                }
            }
        }
    
    
    
    func getListFor(item: String,element: FilterCategory) -> [MovieElement]{
        switch element {
        case .year:
            
            let currentYear = Calendar.current.component(.year, from: Date())
                    var items: [String] = []

                    if item.contains("–") {
                        let parts = item.split(separator: "–").map { String($0) }
                        if parts.count == 2 {
                            let startYear = Int(parts[0]) ?? 0
                            let endYear = (parts[1].isEmpty) ? currentYear : (Int(parts[1]) ?? currentYear)
                            
                            for year in startYear...endYear {
                                items.append("\(year)")
                            }
                        } else {
                            let startYear = Int(parts[0]) ?? 0
                            
                            for year in startYear...currentYear {
                                items.append("\(year)")
                            }
                        }
                    } else {
                        items.append(item)
                    }
            return movies.filter {
                items.contains($0.year)
            }
        case .genre:
            return movies.filter({$0.genre.components(separatedBy: ", ").contains(item)})
        case .directors:
            return movies.filter({$0.director.components(separatedBy: ", ").contains(item)})
        case .actors:
            return movies.filter({$0.actors.components(separatedBy: ", ").contains(item)})
        case .movies:
            return []
        }
    }
    
    func filterLists(_ text: String)  {
        let lowercasedItem = text.lowercased()
        filteredMovies = movies.filter {
            $0.title.lowercased().contains(lowercasedItem) ||
            $0.genre.lowercased().contains(lowercasedItem) ||
            $0.director.lowercased().contains(lowercasedItem) ||
            $0.actors.lowercased().contains(lowercasedItem)
        }
        
        dataLoaded?()
    }
}
