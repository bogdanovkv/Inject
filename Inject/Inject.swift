//
//  Inject.swift
//  Instruments
//
//  Created by Константин Богданов on 25.10.2020.
//  Copyright © 2020 Константин Богданов. All rights reserved.
//

public protocol InjectFactoryProtocol {
	static var scope: String { get }
}

public struct Inject<FactoryType: InjectFactoryProtocol> {
	private let factory: FactoryType.Type
	
	public init(factory: FactoryType.Type) {
		self.factory = factory
	}
	
	public func create<T>(closure: (FactoryType.Type) -> T , strategy: Strategy) -> T {
		switch strategy {
		case .new:
			return closure(factory)
		case .scope(let key):
			do {
				let instance: T = try Container.shared.get(from: factory.scope, key: key)
				return instance
			} catch {
				let instance = closure(factory)
				Container.shared.add(dependency: instance, for: factory.scope, key: key)
				return instance
			}
		case .single:
			do {
				let instance: T = try Container.shared.getSingle()
				return instance
			} catch {
				let instance = closure(factory)
				Container.shared.addSingle(dependency: instance)
				return closure(factory)
			}
		}
	}
}
