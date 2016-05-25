class OpenQuestion
  NAME = 'open-answer-question'

  attr_accessor :text, :points, :answer, :caseSensitive
  def initialize(text, points, caseSensitive = false)
    @text = text
    @points = points
    @caseSensitive = caseSensitive
  end

  def add_answer(answer)
    unless @answer.nil?
      raise "#{NAME} with text \'#{@text}\' cannot have multiple answers, provide only a single correct answer!"
    else
      if !answer.correctness
        raise "#{NAME} with text \'#{@text}\' cannot have wrong answer, provide only a single correct answer!"
      else
        @answer = answer
      end
    end
  end

  def to_json(id)
    "testFreeAnswer('##{id}')"
  end

  def to_html(id)
    "    <div style='margin:25px 0 25px 0;'>
        <form class='form-horizontal questionHeader' role='form' id='#{id}' points='#{@points}'>
            <div class='form-group'>
                <label class='control-label col-sm-3'>#{@text}</label>

                <div class='col-sm-8'>
                    <input type='text' class='form-control' correctAnswer='#{@answer.text}' caseSensitive='#{@caseSensitive}'>
                </div>
                <label class='control-label col-sm-1 points'>?/#{@points}</label>
            </div>
        </form>
    </div>"
  end

  def to_s
    "\t#{NAME} '#{@text}' for #{points} points with answer #{@answer.text}"
  end
end