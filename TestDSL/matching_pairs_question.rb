require_relative './question'

class MatchingPairsQuestion < Question
  NAME = 'matching-pairs-question'

  def initialize(text, points)
    super(text, points)
  end

  def get_all_matching_options
    @pairs.collect{|pair| pair.right}.uniq.shuffle
  end

  def to_js(id)
    "testPairingAnswer('##{id}')"
  end

  def to_html(id)
    allOptionsHtml = "#{get_all_matching_options().collect{|right| "
                        <option value='#{right}'>#{right}</option>"}.join()}"

    "    <div style='margin:25px 0 25px 0;'>
        <form class='form-horizontal questionHeader' role='form' id='#{id}' points='#{@points}'>
            <div class='form-group'>
                <label class='control-label col-sm-3'>#{@text}</label>
                <label class='col-sm-offset-8 control-label col-sm-1 points'>?/#{@points}</label>
            </div>

            #{@pairs.collect{|pair| "            <div class='form-group'>
                <label class='col-sm-offset-3 control-label col-sm-3 slimFont'>#{pair.left}</label>
                <label class=' control-label col-sm-1' style='text-align: center;'>&#x21d0;&#x21d2;</label>

                <div class='col-sm-4'>
                    <select class='form-control' correct='#{pair.right}'>#{allOptionsHtml}
                    </select>
                </div>
            </div>

"}.join()}        </form>
    </div>"
  end

  def to_s
    "\t#{NAME} '#{@text}' for #{points} points with pairs \n\t\t#{pairs.join("\n\t\t")}"
  end

  def validate(errorReporter)
    correct = true

    @answers.each do |a|
      errorReporter.reportError a, "Pairing question '#{@text}' cannot contain answer '#{a.text}'! Remove it, or change the question type"
      correct = false
    end

    superCorrect = super
    return correct && superCorrect
  end
end