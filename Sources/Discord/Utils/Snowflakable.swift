//
//  File.swift
//  
//
//  Created by Jari (LotU) on 01/12/2019.
//

/// Protocol that allows the conforming type to transform into a Snowflake
public protocol Snowflakable {
    /// Snowflake value
    var snowflakeDescription: Snowflake { get }
}

extension Snowflakable {
    /// Returns the snowflake as a string
    var asString: String {
        return "\(self.snowflakeDescription)"
    }
}

extension Array where Element: Snowflakable {
    /// Gets or sets an element based on a Snowflake subscript
    ///
    ///     let userList: [User] = [...]
    ///     let me = userList[mySnowflake]
    public subscript (flake: Snowflake) -> Element? {
        get {
            return self.first { $0.snowflakeDescription == flake }
        }
        set {
            guard let index = self.firstIndex(where: { $0.snowflakeDescription == flake }) else { return }
            self.remove(at: index)
            if let val = newValue {
                self.append(val)
            }
        }
    }
    
    /// Contains method using snowflake
    public func sContains(_ flake: Snowflake) -> Bool {
        return self.map { $0.snowflakeDescription }.contains(flake)
    }
    
    /// Contains using snowflakable
    public func sContains(_ flake: Snowflakable) -> Bool {
        return self.map { $0.snowflakeDescription }.contains(flake.snowflakeDescription)
    }
}

