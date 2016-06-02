require_relative './question'

class MultipleOptionsQuestion < Question
  NAME = 'multiple-options-question'

  def initialize(text, points)
    super(text, points)
  end

  def to_js(id)
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
                            #{@answers.collect{|answer| "<input type='checkbox' correct='#{answer.correct}'> #{answer.text}"}.join("
                        </label>
                    </div>

                    <div class='checkbox'>
                        <label>
                            ")}
                        </label>
                    </div>

                    <small class='text-muted'>Watch out, if you select an incorrect option, the whole question will be considered incorrect.</small>
                </div>

                <label class='control-label col-sm-1 points'>?/#{@points}</label>
            </div>
        </form>
    </div>"
  end

  def to_s
    "\t#{NAME} '#{@text}' for #{points} points with options \n\t\t#{@answers.join("\n\t\t")}"
  end

  def validate(errorReporter)
    correct = true

    @pairs.each do |p|
      errorReporter.reportError p, "Otázka '#{@text}' s viacerými správnymi odpoveďami nemôže mať v sebe definovaný pár '#{p.left}' <-> '#{p.right}'! Odstráň ho z definície, alebo zmeň typ otázky."
      correct = false
    end

    numberOfCorrect = @answers.select {|a| a.correct}.size
    numberOfIncorrect = @answers.select {|a| !a.correct}.size

    if numberOfCorrect == 0 || numberOfIncorrect == 0
      errorReporter.reportError self, "Otázka '#{@text}' musí mať aspoň jednu #{numberOfCorrect == 0 ? "správnu" : "nesprávnu"} odpoveď! Dodaj ju prosím."
      correct = false
    end

    superCorrect = super
    return correct && superCorrect
  end

end