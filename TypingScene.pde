public class TypingScene extends Scene {
  private ProblemSet problems;
  private int index;
  private RomanParser parser;
  private PFont displayTextFont, romanTextFont;
  private List<Particle> particles;
  private boolean doesDrawMissedEffect;
  private int textOffsetX;
  private int shakeWidth;
  
  public TypingScene() {
    RomanTable romanTable = new RomanTable();
    romanTable.loadFromFile("romantable.txt");
    
    ProblemSet problems = new ProblemSet();
    problems.loadFromFile("problems.txt");
    
    this.problems = problems;
    this.parser = new RomanParser(romanTable);
    this.index = 0;
    this.textOffsetX = 0;

    this.displayTextFont = createFont("ヒラギノ明朝 ProN W3", 48);
    this.romanTextFont = createFont("AvenirNext-Regular", 32);
    this.particles = new ArrayList<Particle>();
    
    next();
  }

  public boolean isFinished() {
    return this.index >= this.problems.size();
  }

  public void reset() {
    this.index = 0;
  }

  public void draw() {
    background(0);
    noStroke();
    drawParticles();
    drawProblem();
  }
  
  public void keyTyped(String alphabet) {
    if (parser.input(alphabet)) {
      createParticle();
    } else {
      miss();
    }

    if (parser.isFinished()) next();
  }

  public void next() {
    if (isFinished()) {
      transition(new ResultScene());
    } else {
      parser.setProblem(problems.get(index++));
    }
  }

  public Problem currentProblem() {
    return this.problems.get(index);
  }


  protected void drawParticles() {    
    for (Particle particle : particles) {
      particle.fillColor =
        color(red(particle.fillColor), 
        green(particle.fillColor), 
        blue(particle.fillColor), 
        alpha(particle.fillColor) - 10);
      particle.setup();
      ellipse(particle.x, particle.y, particle.w, particle.h);
    }
  }

  protected void drawProblem() {
    if (doesDrawMissedEffect) {
      if (shakeWidth >= 0) {
        shakeWidth--;
        textOffsetX = frameCount % 2 == 0 ? shakeWidth : -shakeWidth;
      } else {
        doesDrawMissedEffect = false;
      }
    }
    
    fill(255);
    textAlign(CENTER, CENTER);
    textFont(displayTextFont);
    text(parser.problem.displayText, width / 2 + textOffsetX, height / 2);

    textAlign(LEFT, CENTER);
    textFont(romanTextFont);

    float romanTextWidth = textWidth(parser.acceptedRomanText() + parser.remainRomanText());
    float romanTextLeft = (width - romanTextWidth) / 2;
    float acceptedRomanTextWidth = textWidth(parser.acceptedRomanText());
    fill(100);
    text(parser.acceptedRomanText(), romanTextLeft, height / 2 + 40);
    fill(255);
    text(parser.remainRomanText(), romanTextLeft + acceptedRomanTextWidth, height / 2 + 40);
  }

  protected void miss() {
    doesDrawMissedEffect = true;
    shakeWidth = 12;
  }

  protected void createParticle() {
    Particle particle = new Particle();
    colorMode(HSB);
    int h = (int)random(0, 255);
    int s = (int)random(200, 255);
    int b = (int)random(255, 255);

    particle.fillColor = color(h, s, b);
    colorMode(RGB);
    particle.x = random(100, width - 100);
    particle.y = random(100, height - 100);
    particle.w = random(20, 100);
    particle.h = particle.w;
    particles.add(particle);
  }
}