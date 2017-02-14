Game game;

void setup() {
  size(800, 600);

  ProblemSet problems = new ProblemSet();
  problems.loadFromFile("problems.txt");
  problems.shuffle();
  
  RomanTable romanTable = new RomanTable();
  romanTable.loadFromFile("romantable.txt");

  game = new Game(problems, romanTable);
}

void draw() {
  game.draw();
}

void keyTyped() {
  game.input(str(key));
}