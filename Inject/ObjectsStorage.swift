//
//  ObjectsStorage.swift
//  Instruments
//
//  Created by Константин Богданов on 25.10.2020.
//  Copyright © 2020 Константин Богданов. All rights reserved.
//

import Foundation

public enum InjectError: Error {
	case unresolvedDependency
	case unresolvedScope
}

final class ObjectsStorage {
	
	private struct ObjectKey: Hashable {
		let id: ObjectIdentifier
		let key: Int
	}
	
	private var scopes = [String: [ObjectKey: WeakContainer<Any>]]()
	private var singletones: [ObjectKey: Any] = [:]
	
	private let queue = DispatchQueue(label: "com.Instruments.ObjectStorage", qos: .userInitiated)
	
	func store<DependencyType>(dependency: DependencyType, for scope: String, key: Int = 0) {
		queue.sync {
			let key = ObjectKey(id: .init(DependencyType.self), key: key)
			if var currentScope = scopes[scope] {
				currentScope[key] = WeakContainer(element: dependency)
				scopes[scope] = currentScope
			} else {
				scopes[scope] = [key: WeakContainer(element: dependency)]
			}
		}
	}
	
	func resolve<DependencyType>(scope: String, key: Int = 0) throws -> DependencyType {
		try queue.sync {
			guard let currentScope = scopes[scope] else {
				throw InjectError.unresolvedScope
			}
			let key = ObjectKey(id: .init(DependencyType.self), key: key)
			if let object = currentScope[key]?.value as? DependencyType {
				return object
			}
			throw InjectError.unresolvedDependency
		}
	}
	
	func createSingleObject<DependencyType>(dependency: DependencyType) {
		queue.sync {
			let key = ObjectKey(id: .init(DependencyType.self), key: 0)
			self.singletones[key] = dependency
		}
	}
	
	func resolveSingletone<DependencyType>() throws -> DependencyType {
		return try queue.sync {
			let key = ObjectKey(id: .init(DependencyType.self), key: 0)
			guard let object = self.singletones[key] as? DependencyType else {
				throw InjectError.unresolvedDependency
			}
			return object
		}
	}
	
	func resetStorage() {
		queue.sync {
			print("Scopes = \(self.scopes)")
			self.singletones = .init()
			self.scopes = .init()
			print("Scopes = \(self.scopes)")
		}
	}
}
