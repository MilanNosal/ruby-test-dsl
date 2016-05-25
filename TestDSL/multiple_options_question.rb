class MultipleOptionsQuestion
  NAME = 'multiple-option-question'

  attr_accessor :text, :points, :answer
  def initialize(text, points)
    @text = text
    @points = points
    @answers = []
  end

  def add_answer(answer)
    @answers << answer
  end

  def to_json(id)
    "testMultipleChoice('##{id}')"
  end

  def to_html(id)
    "    <div style='margin:25px 0 25px 0;'>
        <form class='form-horizontal questionHeader' role='form' id='#{id}' points='#{@points}'>
            <div class='form-group'>
                <label class='control-label col-sm-3'>#{@text}</label>

                <div class='col-sm-8'>
                    <div class='checkbox'>
                        <label>
                            #{@answers.collect{|answer| "<input type='checkbox' correct='#{answer.correctness}'> #{answer.text}"}.join("
                        </label>
                    </div>

                    <div class='checkbox'>
                        <label>
                            ")}
                        </label>
                    </div>
                </div>

                <label class='control-label col-sm-1 points'>?/#{@points}</label>
            </div>
        </form>
    </div>"
  end

  def to_s
    "\t#{NAME} '#{@text}' for #{points} points with options \n\t\t#{@answers.join("\n\t\t")}"
  end

end