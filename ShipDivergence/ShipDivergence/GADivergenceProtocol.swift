//
//  GADivergenceProtocol.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation

protocol GADivergenceProtocol {

	/// Скорость корабля
	var speed: Double  { get set }

	/// Радиус корабля
	var radius: Double  { get set }

	// массив потомков всех возможных путей
	var childrenRoads: [Road]   { get set }

	/// Лучший путь
	var bestRoad: Road?  { get set }

	/// Произвести селекцию особей
	func selection()

	/// Произвести мутацию рандомного числа особей
	func mutating()

	/// Произвести скрещивание - кроссинговер
	func crossing()

	/// Начать выполнение симуляции
	func start()
}
