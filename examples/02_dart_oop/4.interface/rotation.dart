// Interface: defines the contract
abstract class Rotatable {
  void rotate();
}

// Earth implements rotation in its own way
class Earth implements Rotatable {
  @override
  void rotate() {
    print(
        "Earth rotates on its axis every 24 hours => the succession of day and night");
  }
}

// Blood implements rotation differently
class Blood implements Rotatable {
  @override
  void rotate() {
    print(
        "Blood circulates through veins and arteries => nutrient and oxygen transport");
  }
}

// Water cycle rotation
class WaterCycle implements Rotatable {
  @override
  void rotate() {
    print(
        "Water rotates via evaporation, condensation, and precipitation => continuous water movement");
  }
}

void main() {
  List<Rotatable> systems = [Earth(), Blood(), WaterCycle()];
  for (var system in systems) {
    system.rotate(); // Polymorphism in action
  }
}
