import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(completion: @escaping (([Character]) -> Void))
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private var characterPageURL: URL? = RickAndMortyService.baseURL.appendingPathComponent("character")
    
    private let rickAndMortyService: RickAndMortyServiceProtocol = RickAndMortyService()
    
    func getCharacters(completion: @escaping (([Character]) -> Void)) {
        if let url = characterPageURL {
            rickAndMortyService.fetchData(url: url) { (characterList: CharactersResponse) in
                if let nextURLString = characterList.info.next {
                    if let nextURL = URL(string: nextURLString) {
                        self.characterPageURL = nextURL
                    }
                } else {
                    self.characterPageURL = nil
                }
                
                completion(characterList.characters)
            } error: { error in
                print(error.debugDescription)
                return
            }
        }
    }
}


