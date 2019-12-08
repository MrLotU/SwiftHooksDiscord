import Foundation

typealias Bytes = [UInt8]

let maxBuff = 0x10000

extension UnsafeMutableBufferPointer {
    mutating func realloc(size: Int) {
        let newBuffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: size)
        
        for index in indices {
            newBuffer[index] = self[index]
        }
        
        deallocate()
        
        self = newBuffer
    }
}
