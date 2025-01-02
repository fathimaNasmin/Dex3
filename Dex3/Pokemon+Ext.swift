//
//  Pokemon+Ext.swift
//  Dex3
//
//  Created by Fathima Nasmin on 1/1/25.
//

import Foundation

extension Pokemon {
	var background: String {
		switch self.types![0] {
		case "normal", "grass", "electric", "poison", "fairy":
			return "normalgrasselectricpoisonfairy"
		case "rock", "ground", "steel" ,"fighting", "ghost", "dark", "psychic":
			return "rockgroundsteelfightingghostdarkpsychic"
		case "fire", "dragon":
			return "firedragon"
		case "flying", "bug":
			return "flyingbug"
		case "ice":
			return "ice"
		case "water":
			return "water"
		default:
			return "hi"
		}
	}
	
	var stats: [Stat] {
		[
			Stat(id: 1, label: "HP", value: self.hp),
			Stat(id: 2, label: "Defense", value: self.defense),
			Stat(id: 3, label: "Special Defense", value: self.specialDefence),
			Stat(id: 4, label: "Attack", value: self.attack),
			Stat(id: 5, label: "Special Attack", value: self.specialAttack),
			Stat(id: 6, label: "Speed", value: self.speed),
		]
	}
	
	var highest: Stat {
		stats.max { $0.value < $1.value }!
	}
	
	func organiseType() {
		if self.types!.count == 2 && self.types![0] == "normal"{
			self.types!.swapAt(0, 1)
		}
	}
}

struct Stat: Identifiable {
	let id: Int
	let label: String
	let value: Int16
}
