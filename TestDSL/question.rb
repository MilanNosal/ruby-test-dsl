class Question
  attr_accessor :text, :points, :answers
  def initialize(text, points)
    @text = text
    @points = points
    @answers = []
    @pairs = []
  end

  def add_answer(answer)
    @answers << answer
  end

  def add_pair(pair)
    @pairs << pair
  end

  def validate(errorReporter)
    correct = true
    usedAnswers = []
    @answers.each do |a|
      if usedAnswers.include? a.text
        errorReporter.reportError a, "In the same question '#{@text}' there are two identical answers: '#{a.text}''! Remove one."
        correct = false
      else
        usedAnswers << a.text
      end
    end
    usedAnswers = []
    @pairs.each do |p|
      if usedAnswers.include? (p.left + p.right)
        errorReporter.reportError p, "In the same question '#{@text}' there are two identical matching pairs: '#{p.left}' <-> '#{p.right}'! Remove one."
        correct = false
      else
        usedAnswers << (p.left + p.right)
      end
    end

    if @text.strip.empty?
      errorReporter.reportError self, "Every question has to have text! Add it please."
      correct = false
    end

    if @points < 1
      errorReporter.reportError self, "Question '#{@text}' has to have a positive number of points (at least one, you have stated '#{@points}')! Fix it."
      correct = false
    end

    return correct
  end
end