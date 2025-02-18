//
//  TempPokemon.swift
//  Dex3
//
//  Created by Fathima Nasmin on 12/30/24.
//

import Foundation

struct TempPokemon: Codable {
	let id: Int
	let name: String
	let types: [String]
	var attack: Int = 0
	var defense: Int = 0
	var hp: Int = 0
	var specialAttack: Int = 0
	var specialDefense: Int = 0
	var speed: Int = 0
	let sprite: URL
	let shiny: URL
	
	enum PokemonKeys: String, CodingKey {
		case id
		case name
		case types
		case sprites
		case stats
		
		enum TypeDictionaryKeys: String, CodingKey {
			case type
			
			enum TypeKeys: String, CodingKey {
				case name
			}
		}
		
		enum StatDictionaryKeys: String, CodingKey {
			case value = "base_stat"
			case stat
			
			enum StatKeys: String, CodingKey {
				case name
			}
		}
		
		enum SpriteKeys: String, CodingKey {
			case sprite = "front_default"
			case shiny = "front_shiny"
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: PokemonKeys.self)
		
		id = try container.decode(Int.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		
		// types
		var decodedTypes: [String] = []
		var typesContainer = try container.nestedUnkeyedContainer(forKey: .types) // nestedUnkeyedContainer: types is array of dictionaries
		
		while !typesContainer.isAtEnd {
			let typeDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
			let typeContainer = try typeDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
			let type = try typeContainer.decode(String.self, forKey: .name)
			decodedTypes.append(type)
			
		}
		types = decodedTypes
		
		// Stat
		var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
		
		while !statsContainer.isAtEnd {
			let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
			let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
			
			switch try statContainer.decode(String.self, forKey: .name) {
			case "hp":
				hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "attack":
				attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "defense":
				defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "special-attack":
				specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "special-defense":
				specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
			case "speed":
				speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)

			default:
				print("It will never get here")
			}
		}
		
		// Sprites
		let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
		sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
		shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
	}
}
