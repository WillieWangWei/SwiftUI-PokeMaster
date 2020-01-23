//
//  LoadPokemonAbilitiesRequest.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/23.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation
import Combine

struct LoadPokemonAbilitiesRequest {
    let pokemon: Pokemon
    
    var publisher: AnyPublisher<[AbilityViewModel], AppError> {
        pokemon.abilities.map {
            URLSession
                .shared
                .dataTaskPublisher(for: $0.ability.url)
                .map { $0.data }
                .decode(type: Ability.self, decoder: appDecoder)
                .map { AbilityViewModel(ability: $0) }
                .mapError { AppError.networkingFailed($0) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }.zipAll
    }
}
