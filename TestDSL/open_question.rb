require_relative './question'

class OpenQuestion < Question
  NAME = 'open-answer-question'

  attr_accessor :caseSensitive
  def initialize(text, points, caseSensitive = false)
    super(text, points)
    @caseSensitive = caseSensitive
  end

  def to_js(id)
    "testFreeAnswer('##{id}')"
  end

  def to_html(id)
    "    <div style='margin:25px 0 25px 0;'>
        <form class='form-horizontal questionHeader' role='form' id='#{id}' points='#{@points}'>
            <div class='form-group'>
                <label class='control-label col-sm-3'>#{@text}</label>

                <div class='col-sm-8'>
                    <input type='text' class='form-control' correctAnswer='#{@answers[0].text}' caseSensitive='#{@caseSensitive}'>
                    #{@caseSensitive ? "<small class='text-muted'>Watch out, the question is case sensitive.</small>" : "<small class='text-muted'>Question is not case sensitive.</small>"}
                </div>
                <label class='control-label col-sm-1 points'>?/#{@points}</label>
            </div>
        </form>
    </div>"
  end

  def to_s
    "\t#{NAME} '#{@text}' for #{points} points with answer #{@answers[0].text}"
  end

  def validate(errorReporter)
    correct = true

    @pairs.each do |p|
      errorReporter.reportError p, "Open answer Question '#{@text}' cannot define a matching pair '#{p.left}' <-> '#{p.right}'! Remove it, or change the question type to one that supports it."
      correct = false
    end

    numberOfAnswers = 0

    @answers.each do |a|
      numberOfAnswers = numberOfAnswers + 1

      if numberOfAnswers == 1
        if !a.correct
          errorReporter.reportError a, "Open answer question '#{@text}' cannot define an incorrect answer (answer '#{a.text}')!"
          correct = false
        end
      else
        errorReporter.reportError a, "Open answer question '#{@text}' cannot have multiple answers. Remove answer '#{a.text}'."
        correct = false
      end

    end

    if numberOfAnswers == 0
      errorReporter.reportError self, "Open answer question '#{@text}' has to have a single correct answer! Add it please."
      correct = false
    end

    superCorrect = super
    return correct && superCorrect
  end
end