import Foundation

var str = "Hello, playground"


// Inheritance is one in which a new class is created that inherits the properties of the already exist class. It supports the concept of code reusability and reduces the length of the code in object-oriented programming.

// Polymorphism is that in which we can perform a task in multiple forms or ways. It is applied to the functions or methods. Polymorphism allows the object to decide which form of the function to implement at compile-time as well as run-time.


// Core Component
protocol Character {
    var hp: Int { get set }
    var mana: Int { get set }
    var def: Int { get set }
    var atk: Int { get set }
    func getHealth() -> Int
}



//MARK: - Heroes
// Concrete Components (RACES)
struct Orc: Character {
    
    var hp = 120
    var mana = 20
    var def = 5
    var atk = 20
    
    func getHealth() -> Int {
        return hp
    }
}

struct Elf: Character {
    
    var hp = 100
    var mana = 40
    var def = 10
    var atk = 15
    
    func getHealth() -> Int {
        return 5
    }
}

// Decorator
protocol CharacterType: Character {
    var base: Character { get }
}

// Concrete Decorators (CLASSES)
struct Paladin: CharacterType {
    
    
    let base: Character
    var hp: Int
    var mana: Int
    var def: Int
    var atk: Int
    
    //Enhanced stats based on character type
    var enhancedHp = 30
    var enhancedMana = 20
    var enhancedDef = 15
    var enhancedAtk = 5
    
    func getHealth() -> Int {
        return 50 + base.getHealth()
    }
     
    // New responsibility
    func battleCry() {
        print("RAWR")
    }
    
    init(base: Character) {
        self.base = base
        self.hp = base.hp + enhancedHp
        self.mana = base.mana + enhancedMana
        self.def = base.def + enhancedDef
        self.atk = base.atk + enhancedAtk
    }
}


//MARK: - Heroes
//class Hero {
//    var hp: Int
//    var mana: Int
//    var atk: Int
//    var def: Int
//
//    init(hp: Int, mana: Int, atk: Int, def: Int) {
//        self.hp = hp
//        self.mana = mana
//        self.atk = atk
//        self.def = def
//    }
//}
//
//class Paladin: Hero {
//    let MAX_HP = 110
//    let MAX_MANA = 50
//    let BASE_ATK = 10
//    let BASE_DEF = 10
//
//    init() {
//        super.init(hp: MAX_HP, mana: MAX_MANA, atk: BASE_ATK, def: BASE_DEF)
//    }
//
//    func heal() {
//        if mana > 15 {
//            mana -= 15
//            if hp + 25 >= MAX_HP {
//                hp = MAX_HP
//                print("You have healed yourself for \(MAX_HP - hp)HP.")
//            } else {
//                hp += 25
//                print("You have healed yourself for 25HP.")
//            }
//        }
//    }
//
//    func judgementStrike(monster: Character) {
//        if mana > 5 {
//            mana -= 5
//            if monster.hp >= 15 {
//                monster.hp -= 15
//                print("You have attacked \(monster.name) for 15HP. Orc has \(monster.hp)HP remaining.")
//            }
//        }
//    }
//}
//
//
//protocol Stats {
//    var hp: Int { get set }
//    var mana: Int { get set }
//    var def: Int { get set }
//    var atk: Int { get set }
//}


//MARK: - GamePlay

var hero: Character

var heroClass: CharacterType

print("Please pick your race. \n 1: Orc, 2: Elf")
if let heroRaceStr = readLine() {
    if heroRaceStr == "1" {
        print("You have chosen Orc.")
        hero = Orc()
    } else if heroRaceStr == "2" {
        print("You have chosen Elf.")
        hero = Elf()
    } else {
        print("You have been defaulted to an Orc.")
        hero = Orc()
    }
} else {
    print("You have been defaulted to an Orc.")
    hero = Orc()
}

print("Please pick your class. \n 1: Paladin")
if let heroClassStr = readLine() {
    if heroClassStr == "1" {
        print("You have chosen the class Paladin.")
        heroClass = Paladin(base: hero)
    } else {
        heroClass = Paladin(base: hero)
    }
} else {
    heroClass = Paladin(base: hero)
}

func getStats(hero: Character) {
    print("HP: \(hero.hp)")
    print("MANA: \(hero.mana)")
    print("DEF: \(hero.def)")
    print("ATK: \(hero.atk)")
    
}


getStats(hero: heroClass)
