import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(completion: @escaping (([Character]) -> Void), error: @escaping ((NSError?) -> Void))
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private var characterPageURL: URL? = RickAndMortyService.baseURL.appendingPathComponent("character")
    
    private let rickAndMortyService: RickAndMortyServiceProtocol = RickAndMortyService()
    
    func getCharacters(completion: @escaping (([Character]) -> Void), error: @escaping ((NSError?) -> Void)) {
        if let url = characterPageURL {
            rickAndMortyService.fetchData(url: url) { (charactersResponse: CharacterResponse) in
                if let nextURLString = charactersResponse.info.next {
                    if let nextURL = URL(string: nextURLString) {
                        self.characterPageURL = nextURL
                    }
                } else {
                    self.characterPageURL = nil
                }
                
                completion(charactersResponse.characters)
            } error: { (err: NSError?) in
                error(err)
            }
        }
    }
}

