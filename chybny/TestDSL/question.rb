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
        errorReporter.reportError a, "V rámci tej istej otázky '#{@text}' si opäť definoval/a rovnakú odpoveď: '#{a.text}'! Odstráň ju."
        correct = false
      else
        usedAnswers << a.text
      end
    end
    usedAnswers = []
    @pairs.each do |p|
      if usedAnswers.include? (p.left + p.right)
        errorReporter.reportError p, "V rámci tej istej otázky '#{@text}' si opäť definoval/a rovnaký pár: '#{p.left}' <-> '#{p.right}'! Odstráň ho."
        correct = false
      else
        usedAnswers << (p.left + p.right)
      end
    end

    if @text.strip.empty?
      errorReporter.reportError self, "Otázka '#{@text}' musí mať definovaný text! Dodaj ho prosím."
      correct = false
    end

    if @points < 1
      errorReporter.reportError self, "Otázka '#{@text}' musí mať kladný počet bodov (aspoň jeden bod, ty si uviedol/uviedla '#{@points}')! Oprav to."
      correct = false
    end

    return correct
  end
end