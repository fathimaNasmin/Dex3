//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Fathima Nasmin on 12/31/24.


// Purpose: Processing the fetch pokemon and ready for the view
// @Published: Notifies the View who observers this view model of any changes to status property will trigger for UI update.


import Foundation

@MainActor
class PokemonViewModel: ObservableObject {

	enum Status {
		case notStarted
		case fetching
		case success
		case failed(error: Error)
	}
	
	// Purpose of status property is to update the view when the status property changes
	@Published private(set) var status = Status.notStarted
	
	private let controller: FetchController
	
	init(controller: FetchController){
		self.controller = controller
		Task {
			await getPokemon()
		}
	}
	
	private func getPokemon() async {
		status = .fetching
		
		do {
			var pokedex = try await controller.fetchAllPokemon()
			pokedex.sort { $0.id < $1.id }
			
			for pokemon in pokedex {
				let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
				newPokemon.id = Int16(pokemon.id)
				newPokemon.name = pokemon.name
				
				newPokemon.types = pokemon.types
				newPokemon.organiseType()
				
				newPokemon.hp = Int16(pokemon.hp)
				newPokemon.defense = Int16(pokemon.defense)
				newPokemon.specialDefence = Int16(pokemon.specialDefense)
				newPokemon.attack = Int16(pokemon.attack)
				newPokemon.specialAttack = Int16(pokemon.specialAttack)
				newPokemon.speed = Int16(pokemon.speed)
				newPokemon.shiny = pokemon.shiny
				newPokemon.sprite = pokemon.sprite
				newPokemon.favorite = false
				
				try PersistenceController.shared.container.viewContext.save()
			}
			status = .success
		}catch{
			status = .failed(error: error)
		}
	}
}
