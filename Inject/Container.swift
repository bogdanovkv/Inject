//
//  Container.swift
//  Instruments
//
//  Created by Константин Богданов on 25.10.2020.
//  Copyright © 2020 Константин Богданов. All rights reserved.
//

import Foundation

/// Контейнер с зависимостями
public class Container {
	
	public static let shared = Container()
	private init() {}
	
	private let storage: ObjectsStorage = .init()
	
	func get<DependecyType>(from scope: String, key: Int = 0) throws -> DependecyType {
		return try storage.resolve(scope: scope, key: key)
	}
	
	func add<DependecyType>(dependency: DependecyType, for scope: String, key: Int) {
		storage.store(dependency: dependency, for: scope, key: key)
	}
	
	func getSingle<DependecyType>() throws -> DependecyType {
		try storage.resolveSingletone()
	}

	func addSingle<DependecyType>(dependency: DependecyType) {
		storage.createSingleObject(dependency: dependency)
	}
		
	/// Сбрасывает все хранимые зависимости
	public func reset() {
		storage.resetStorage()
	}
}
