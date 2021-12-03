import Foundation

let fileName = "input2"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
var readString = "" // Used to store the file contents

do {
    // Read the file contents
    readString = try String(contentsOf: fileURL)
} catch let error as NSError {
    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
}

let inputStrArray = Array(readString.split(separator: "\n"))

// Part 1
/*var depth = 0
var horizontalPosition = 0

for i in 0 ..< inputStrArray.count {
    let instructions = inputStrArray[i].split(separator: " ")
    if instructions[0] == "up" {
        depth -= Int(instructions[1])!
    } else if instructions[0] == "down" {
        depth += Int(instructions[1])!
    } else if instructions[0] == "forward" {
        horizontalPosition += Int(instructions[1])!
    }
}

print(depth * horizontalPosition)
*/

// Part 2

var depth = 0
var horizontalPosition = 0
var aim = 0

for i in 0 ..< inputStrArray.count {
    let instructions = inputStrArray[i].split(separator: " ")
    if instructions[0] == "up" {
        aim -= Int(instructions[1])!
    } else if instructions[0] == "down" {
        aim += Int(instructions[1])!
    } else if instructions[0] == "forward" {
        horizontalPosition += Int(instructions[1])!
        depth += Int(instructions[1])! * aim
    }
}

print(depth * horizontalPosition)
