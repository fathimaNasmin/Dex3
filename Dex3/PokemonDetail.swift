//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Fathima Nasmin on 12/31/24.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@EnvironmentObject var pokemon: Pokemon
	@State var showShiny = false
	
	var body: some View {
		ScrollView {
			ZStack {
				Image(pokemon.background)
					.resizable()
					.scaledToFit()
					.shadow(color: .black, radius: 6)
				
				AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
					image.resizable()
						.scaledToFit()
						.padding(.top, 70)
						.shadow(color: .black, radius: 6)
				} placeholder: {
					ProgressView()
				}

			}
			
			HStack {
				ForEach(pokemon.types!, id:\.self) { type in
					Text(type.capitalized)
						.font(.title2)
						.shadow(color: .white, radius: 1)
						.padding([.top, .bottom], 7)
						.padding([.leading, .trailing])
						.background(Color(type.capitalized))
						.cornerRadius(50)
				}
				Spacer()
				
				Button {
					pokemon.favorite.toggle()
					// save to the persistance data(db)
					do {
						try viewContext.save()
					} catch {
						let nsError = error as NSError
						fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
					}
					
				} label: {
					Image(systemName: pokemon.favorite ? "star.fill" : "star")
						
				}
				.font(.title)
				.foregroundColor(.yellow)
			}
			.padding()
			
			Text("Stats")
				.font(.title)
				.padding(.bottom, -7)
			
			Stats()
				.environmentObject(pokemon)
			
		}
		.navigationTitle(pokemon.name!.capitalized)
		.toolbar {
			ToolbarItem(placement:.navigationBarTrailing) {
				Button {
					showShiny.toggle()
				} label: {
					if showShiny {
						Image(systemName: "wand.and.stars")
							.foregroundColor(.yellow)
					} else {
						Image(systemName: "wand.and.stars.inverse")
					}
				}
				
			}
		}
		
	}
}

#Preview {
	PokemonDetail()
		.environmentObject(
			SamplePokemon.samplePokemon
		)
}
