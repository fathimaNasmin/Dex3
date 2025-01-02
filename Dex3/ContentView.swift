//
//  ContentView.swift
//  Dex3
//
//  Created by Fathima Nasmin on 12/29/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default) private var pokedex: FetchedResults<Pokemon>
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
		predicate: NSPredicate(format: "favorite = %d", true),
		animation: .default) private var favorites: FetchedResults<Pokemon>
	
	@StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
	
	@State var filterByFavorites = false

    var body: some View {
		switch pokemonVM.status {
		case .success:
			NavigationStack {
				List(filterByFavorites ? favorites : pokedex) { pokemon in
					NavigationLink(value: pokemon) {
						AsyncImage(url: pokemon.sprite) { image in
							image.resizable()
								.scaledToFit()
						} placeholder: {
							ProgressView()
						}
						.frame(width: 100, height: 100)
						
						
						Text(pokemon.name!.capitalized)
						
						if pokemon.favorite {
							Image(systemName: "star.fill")
								.foregroundColor(.yellow)
						}
					}
				}
				.navigationTitle("Pokedox")
				.navigationDestination(for: Pokemon.self) { pokemon in
					PokemonDetail()
						.environmentObject(pokemon)
				}
				.toolbar{
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							withAnimation {
								filterByFavorites.toggle()
							}
							
						}label: {
							Label("Filter By  Favorite", systemImage: filterByFavorites ? "star.fill" : "star")
						}
						.font(.largeTitle)
						.tint(.yellow)
					}
				}
			}
		default:
			ProgressView()
		}
    }

}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
