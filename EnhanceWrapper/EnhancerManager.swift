//
//  EnhancerManager.swift
//  EnhanceWrapper
//
//  Created by Kostiantyn Gorbunov on 01/07/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Foundation

enum EnhancerManagerError: Error {
    case noFreeEnhancer // possible throw in case if semaphore initial value bigger than enhancer Pool size
}

class EnhancerManager {
    
    private enum Constants {
        static let enhancerPoolSize: Int = 8
    }
    
    static let shared = EnhancerManager() // initialization is atomic
    
    private var enhancerPool: [EnhancerProtocol]
    private let enhancerPoolLock = NSLock()
    private let busyEnhancerPool = NSHashTable<EnhancerProtocol>.weakObjects()
    private let semaphore = DispatchSemaphore(value: Constants.enhancerPoolSize)
    
    private init() {
        var enhancerPool: [EnhancerProtocol] = []
        for _ in 1...Constants.enhancerPoolSize {
            enhancerPool.append(Enhancer())
        }
        self.enhancerPool = enhancerPool
    }
    
    func execute(withInputString inputStr: String) throws -> String {
        defer {
            semaphore.signal()
        }

        semaphore.wait()
        
        let enhancer = try retainEnhancer()
        
        print("Execute \(Thread.current.name ?? "noname")")
        
        return try execute(enhancer, withInputString: inputStr)
    }
    
    private func execute(_ enhancer: EnhancerProtocol, withInputString inputStr: String) throws -> String {
        defer {
            releaseEnhancer(enhancer)
        }
        do {
            return try enhancer.execute(withInputString: inputStr)
        } catch {
            let errorCode = (error as NSError).code
            if errorCode == 2 {
                if let index = enhancerPool.firstIndex(where: { $0 === enhancer }) {
                    enhancerPoolLock.lock()
                    enhancerPool[index] = Enhancer()
                    enhancerPoolLock.unlock()
                }
            }
            throw error
        }
    }
    
    private func retainEnhancer() throws -> EnhancerProtocol {
        defer {
            enhancerPoolLock.unlock()
        }
        enhancerPoolLock.lock()
        guard let enhancer = enhancerPool.first(where: { busyEnhancerPool.contains($0) == false }) else {
            throw EnhancerManagerError.noFreeEnhancer
        }
        busyEnhancerPool.add(enhancer)
        return enhancer
    }
    
    private func releaseEnhancer(_ enhancer: EnhancerProtocol) {
        enhancerPoolLock.lock()
        busyEnhancerPool.remove(enhancer)
        enhancerPoolLock.unlock()
    }
}
