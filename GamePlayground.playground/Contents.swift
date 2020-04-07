import Foundation

var str = "Hello, playground"


// Inheritance is one in which a new class is created that inherits the properties of the already exist class. It supports the concept of code reusability and reduces the length of the code in object-oriented programming.

// Polymorphism is that in which we can perform a task in multiple forms or ways. It is applied to the functions or methods. Polymorphism allows the object to decide which form of the function to implement at compile-time as well as run-time.

//MARK: - Monsters

class Monster {
    var hp: Int
    var atk: Int
    var def: Int
    
    init(hp: Int, atk: Int, def: Int) {
        self.hp = hp
        self.atk = atk
        self.def = def
    }
    
    func getAttacked(damage: Int) {
        hp -= damage - def
        print("you have \(hp) remaining")
    }
    
}

//Orc inherits from Monster
class Orc: Monster {
    init() {
        super.init(hp: 125, atk: 15, def: 3)
    }
}

class Troll: Monster {
    init() {
        super.init(hp: 90, atk: 20, def: 0)
    }
}

//MARK: - Heroes
class Hero {
    var hp: Int
    var mana: Int
    var atk: Int
    var def: Int
    
    init(hp: Int, mana: Int, atk: Int, def: Int) {
        self.hp = hp
        self.mana = mana
        self.atk = atk
        self.def = def
    }
}

class Paladin: Hero {
    let MAX_HP = 110
    let MAX_MANA = 50
    let BASE_ATK = 10
    let BASE_DEF = 10
    
    init() {
        super.init(hp: MAX_HP, mana: MAX_MANA, atk: BASE_ATK, def: BASE_DEF)
    }
    
    func heal() {
        if mana > 15 {
            mana -= 15
            if hp + 25 >= MAX_HP {
                hp = MAX_HP
                print("You have healed yourself for \(MAX_HP - hp)HP.")
            } else {
                hp += 25
                print("You have healed yourself for 25HP.")
            }
        }
    }
}


//MARK: - GamePlay

print("Please enter your name: ")
if let hero = readLine() {
    print(hero)
    let paladin = Paladin()
    paladin.heal()
}

var orc = Orc()
orc.getAttacked(damage: 5)

