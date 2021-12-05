import Foundation

// Default aoc code
let fileName = "input4"
let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
var readString = ""

do {
    
    readString = try String(contentsOf: fileURL)
} catch let error as NSError {
    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
}

var inputStrArray = Array(readString.split(separator: "\n").map { String($0) })
// Figure out how to cast array correctly

// 1. Make sure to read data correctly and separate them in proper objects

// Random numbers
let randomNumbers: [Int] = inputStrArray.removeFirst().split(separator: ",").compactMap { Int($0) }

// Bingo board object?? where we have a method for marking a number passed as a parameter?

struct BingoCard: Equatable {
    // How to populate bingo cards?
    var board = [[Int]]()
    var id: Int

    // This might work when marking numbers
    var numbersMarked: [Int:Bool] = [11:false, 12:false, 13:false, 14:false, 15:false, 
                                     21:false, 22:false, 23:false, 24:false, 25:false, 
                                     31:false, 32:false, 33:false, 34:false, 35:false,
                                     41:false, 42:false, 43:false, 44:false, 45:false,
                                     51:false, 52:false, 53:false, 54:false, 55:false]

    init(board: [String], id: Int) {
        // Input must have 5 string elements, as every card is a 5x5 grid
        for i in 0 ..< 5 {
            let row: [Int] = board[i].split(separator: " ").compactMap { Int($0) }
            self.board.append(row)
        }
        self.id = id
    }

    var isWinner: Bool {
        if (numbersMarked[11]! == true && numbersMarked[12]! == true && numbersMarked[13]! == true && numbersMarked[14]! == true && numbersMarked[15]! == true) ||
            (numbersMarked[21]! == true && numbersMarked[22]! == true && numbersMarked[23]! == true && numbersMarked[24]! == true && numbersMarked[25]! == true) ||
            (numbersMarked[31]! == true && numbersMarked[32]! == true && numbersMarked[33]! == true && numbersMarked[34]! == true && numbersMarked[35]! == true) ||
            (numbersMarked[41]! == true && numbersMarked[42]! == true && numbersMarked[43]! == true && numbersMarked[44]! == true && numbersMarked[45]! == true) ||
            (numbersMarked[51]! == true && numbersMarked[52]! == true && numbersMarked[53]! == true && numbersMarked[54]! == true && numbersMarked[55]! == true) ||
            (numbersMarked[11]! == true && numbersMarked[21]! == true && numbersMarked[31]! == true && numbersMarked[41]! == true && numbersMarked[51]! == true) ||
            (numbersMarked[12]! == true && numbersMarked[22]! == true && numbersMarked[32]! == true && numbersMarked[42]! == true && numbersMarked[52]! == true) ||
            (numbersMarked[13]! == true && numbersMarked[23]! == true && numbersMarked[33]! == true && numbersMarked[43]! == true && numbersMarked[53]! == true) ||
            (numbersMarked[14]! == true && numbersMarked[24]! == true && numbersMarked[34]! == true && numbersMarked[44]! == true && numbersMarked[54]! == true) ||
            (numbersMarked[15]! == true && numbersMarked[25]! == true && numbersMarked[35]! == true && numbersMarked[45]! == true && numbersMarked[55]! == true) {
                return true
            }
        
        return false
    }

    mutating func mark(with number: Int) {
        for i in 0..<5 {
            for j in 0..<5 {
                if self.board[i][j] == number {
                    let position = "\(i + 1)" + "\(j + 1)"
                    let number = Int(position)!
                    numbersMarked[number] = true
                    return
                }
            }
        }
    }

    func sumOfUnmarkedNumbers() {
        var sum = 0
        var positions = [[Int]]()

        for (position, isMarked) in numbersMarked {
            var tempArray = [Int]()
            if !isMarked {
                let str = String(position - 11)
                tempArray.append(Int(String(str[str.startIndex]))!)
                tempArray.append(Int(String(str[str.index(before: str.endIndex)]))!)
                positions.append(tempArray)
            }
        }

        for position in positions {
            print(position)
            sum += board[position[0]][position[1]]
        }

        print(sum)
    }

    static func ==(lhs: BingoCard, rhs: BingoCard) -> Bool {
        return lhs.id == rhs.id
    }

}

var bingoCards = [BingoCard]()

var counter = 0
var tempBoard = [String]()
var id = 0

// Populate Bingo Cards
for i in 0..<inputStrArray.count {

    if counter == 5 {
        let newBingoCard = BingoCard(board: tempBoard, id: id)
        bingoCards.append(newBingoCard)
        counter = 0
        id += 1
        tempBoard.removeAll()
    }

    tempBoard.append(inputStrArray[i])
    counter += 1

    // Handle edge case where we were not adding the last bingo card

    if i == inputStrArray.count - 1 {
        let newBingoCard = BingoCard(board: tempBoard, id: id)
        bingoCards.append(newBingoCard)
    }
}

// 2. Mark every number from random numbers
func findWinner(randomNumbers: [Int], bingoCards: inout [BingoCard]) {
    for randomNumber in randomNumbers {
        for i in 0..<bingoCards.count {
            bingoCards[i].mark(with: randomNumber)
            if bingoCards[i].isWinner {
                print(bingoCards[i])
                print(randomNumber)
                bingoCards[i].sumOfUnmarkedNumbers()
                return
            }
        }
    }
}
// Part 2
func findLastWinner(randomNumbers: [Int], bingoCards: inout [BingoCard]) {
    var winners = [BingoCard]()

    for randomNumber in randomNumbers {
        for index in 0..<bingoCards.count {
            bingoCards[index].mark(with: randomNumber)
            
            if bingoCards[index].isWinner && !winners.contains(bingoCards[index]) {
                print("number that made card \(bingoCards[index].id) winner: \(randomNumber)")
                winners.append(bingoCards[index])
                
                if winners.count == bingoCards.count {
                    print(bingoCards[index])
                    return
                }
            }

            
        }
    }
}
// Test values
/*let numbers = [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1]
var cards = [
    BingoCard(board: ["22 13 17 11  0", "8  2 23  4 24", "21  9 14 16  7", "6 10  3 18  5", "1 12 20 15 19"], id: 0),
    BingoCard(board: ["3 15  0  2 22", "9 18 13 17  5", "19  8  7 25 23", "20 11 10 24  4", "14 21 16 12  6"], id: 1),
    BingoCard(board: ["14 21 17 24  4", "10 16 15  9 19", "18  8 23 26 20", "22 11 13  6  5", "2  0 12  3  7"], id: 2)
]*/

//findWinner(randomNumbers: randomNumbers, bingoCards: &bingoCards)
findLastWinner(randomNumbers: randomNumbers, bingoCards: &bingoCards)


