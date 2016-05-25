class Answer
  attr_accessor :text, :correctness
  def initialize(text, correctness)
    @text = text
    @correctness = correctness
  end

  def to_s
    "'#{@text}' (#{@correctness})"
  end
end