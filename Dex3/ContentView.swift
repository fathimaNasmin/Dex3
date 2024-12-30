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
        NavigationView {
            List {
				ForEach(pokedex) { pokemon in
                    NavigationLink {
						Text("\(pokemon.id): \(pokemon.name!)")
                    } label: {
						Text("\(pokemon.id): \(pokemon.name!)")
                    }
                }
                
            }
        }
    }

}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
