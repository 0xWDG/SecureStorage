//
//  SecureStorage.swift
//  SecureStorage
//
//  Created by Wesley de Groot on 2025-01-24.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SecureStorage
//  MIT License
//

#if canImport(SwiftUI) || canImport(Security)
import Foundation
import SwiftUI
import Security

/// A property wrapper that reads and writes to the keychain.
///
/// Example:
/// ```
/// @SecureStorage("key") var value: String?
/// ```
@propertyWrapper
public struct SecureStorage: DynamicProperty {
    /// The key to read and write to.
    let key: String

    /// Get service name (if not overwritten)
    var service: String

    /// Should delete when asked?
    var shouldDeleteWhenAsked: Bool = false

    /// Creates an `SecureStorage` property.
    ///
    /// - Parameter key: The key to read and write to.
    /// - Parameter service: Custom service identifier
    public init(
        wrappedValue: String? = nil,
        _ key: String,
        service: String = Bundle.main.bundleIdentifier ?? "nl.wesleydegroot.SecureStorage"
    ) {
        self.key = key
        self.service = service
        self.wrappedValue = wrappedValue
        self.shouldDeleteWhenAsked = true
    }

    /// The value of the key in the keychain.
    public var wrappedValue: String? {
        get {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: key,
                kSecClass: kSecClassGenericPassword,
                kSecReturnData: true
            ] as CFDictionary

            var result: AnyObject?
            SecItemCopyMatching(query, &result)

            if let data = result as? Data,
               let string = String(data: data, encoding: .utf8) {
                return string
            }

            return nil
        }

        // This needs to be nonmutating because we're setting a property on a struct.
        nonmutating set {
            if let newValue {
                let data = Data(newValue.utf8)
                let query = [
                    kSecValueData: data,
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrService: service,
                    kSecAttrAccount: key,
                    kSecAttrSynchronizable: kSecAttrSynchronizableAny
                ] as CFDictionary

                // Add data in query to keychain
                let status = SecItemAdd(query, nil)

                if status == errSecDuplicateItem {
                    // Item already exist, update it.
                    let query = [
                        kSecAttrService: service,
                        kSecAttrAccount: key,
                        kSecClass: kSecClassGenericPassword
                    ] as CFDictionary

                    let attributesToUpdate = [kSecValueData: data] as CFDictionary

                    SecItemUpdate(query, attributesToUpdate)
                } else if status != errSecSuccess {
                    fatalError("Error: \(status)")
                }
            } else {
                // Wait until we are initialized before deleting items
                if shouldDeleteWhenAsked {
                    let query = [
                        kSecAttrService: service,
                        kSecAttrAccount: key,
                        kSecClass: kSecClassGenericPassword
                    ] as CFDictionary

                    SecItemDelete(query)
                }
            }
        }
    }

    /// A binding to the value of the key in iCloud.
    public var projectedValue: Binding<String?> {
        Binding {
            return self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
        }
    }

    /// Delete the item from the keychain.
    public func delete() {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny
        ] as CFDictionary

        SecItemDelete(query)
    }

    /// Delete all items from the keychain.
    public func deleteAll() {
        let query = [
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemDelete(query)
    }
}
#endif
