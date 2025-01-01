//
//  ContentView.swift
//  Dex3
//
//  Created by Fathima Nasmin on 12/29/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
	
    private var pokedex: FetchedResults<Pokemon>

    var body: some View {
        NavigationStack {
			List(pokedex) { pokemon in
				NavigationLink(value: pokemon) {
					AsyncImage(url: pokemon.sprite) { image in
						image.resizable()
							.scaledToFit()
					} placeholder: {
						ProgressView()
					}
					.frame(width: 100, height: 100)

					
					Text(pokemon.name!.capitalized)
				}
			}
			.navigationTitle("Pokedox")
			.navigationDestination(for: Pokemon.self) { pokemon in
				AsyncImage(url: pokemon.sprite) { image in
					image.resizable()
						.scaledToFit()
				} placeholder: {
					ProgressView()
				}
				.frame(width: 200, height: 200)
			}
			.toolbar{
				ToolbarItem(placement: .topBarTrailing) {
					EditButton()
				}
			}
        }
    }

}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
