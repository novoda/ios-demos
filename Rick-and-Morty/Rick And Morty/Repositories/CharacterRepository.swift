import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(completion: @escaping (([Character]) -> Void))
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private var characterPageURL: URL? = RickAndMortyService.baseURL.appendingPathComponent("character")
    
    private let rickAndMortyService: RickAndMortyServiceProtocol = RickAndMortyService()
    
    func getCharacters(completion: @escaping (([Character]) -> Void)) {
        
        if let url = characterPageURL {
            rickAndMortyService.fetchData(url: url) { (characterList: CharactersList) in
                if let nextURLString = characterList.info.next {
                    self.characterPageURL = URL(string: nextURLString)!
                } else {
                    self.characterPageURL = nil
                }
                
                completion(characterList.results)
            } error: { error in
                print(error.debugDescription)
                return
            }
        }
    }
}
