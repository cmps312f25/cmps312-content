enum Color { white, black }

enum Weekday { sunday, monday, tuesday, wednesday, thursday }

enum PlanetType { terrestrial, gas, ice }

enum Weather { sunny, cloudy, rainy }

void main() {
  var day = Weekday.sunday;
  switch (day) {
    case Weekday.sunday:
      print("Today is Sunday.");
    case Weekday.monday:
      print("Today is Monday.");
    case Weekday.tuesday:
      print("Today is Tuesday.");
    case Weekday.wednesday:
      print("Today is Wednesday.");
    default:
      print("Today is Thursday.");
  }

  Color c = Color.black;
  Weekday d = Weekday.values[Weekday.thursday.index];
  Weather w = Weather.sunny;

  if (c == Color.black && d == Weekday.thursday && w == Weather.sunny) {
    print("Let's go shopping!");
  }
  if (w == Weather.rainy) {
    print("Stay at home!");
  } else {
    print("Wait for good deals! and good weather!");
  }

  for (var planet in PlanetType.values) {
    print(planet);
  }
}
