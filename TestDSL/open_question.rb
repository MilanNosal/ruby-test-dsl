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
      errorReporter.reportError p, "Otázka '#{@text}' s otvorenou odpoveďou nemôže mať v sebe definovany pár '#{p.left}' <-> '#{p.right}'! Odstráň ho z definície, alebo zmeň typ otázky."
      correct = false
    end

    numberOfAnswers = 0

    @answers.each do |a|
      numberOfAnswers = numberOfAnswers + 1

      if numberOfAnswers == 1
        if !a.correct
          errorReporter.reportError a, "Otázka '#{@text}' s otvorenou odpoveďou nemôže mať nesprávnu odpoveď (odpoveď '#{a.text}'), ale musí mať práve jednu správnu odpoveď!"
          correct = false
        end
      else
        errorReporter.reportError a, "Otázka '#{@text}' nesmie mať viacero odpovedí! Ponechaj len jednu správnu a zmaž odpoveď '#{a.text}'."
        correct = false
      end

    end

    if numberOfAnswers == 0
      errorReporter.reportError self, "Otázka '#{@text}' musí mať správnu odpoveď! Dodaj ju prosím."
      correct = false
    end

    superCorrect = super
    return correct && superCorrect
  end
end