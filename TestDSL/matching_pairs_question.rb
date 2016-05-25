class MatchingPairsQuestion
  NAME = 'matching-pairs-question'

  attr_accessor :text, :points, :pairs
  def initialize(text, points)
    @text = text
    @points = points
    @pairs = []
  end

  def add_pair(pair)
    @pairs << pair
  end

  def get_all_pairable()
    @pairs.collect{|pair| pair.right}
  end

  def to_json(id)
    "testPairingAnswer('##{id}')"
  end

  def to_html(id)
    allOptionsHtml = "#{get_all_pairable().collect{|right| "
                        <option value='#{right}'>#{right}</option>"}.join()}"

    "    <div style='margin:25px 0 25px 0;'>
        <form class='form-horizontal questionHeader' role='form' id='#{id}' points='#{@points}'>
            <div class='form-group'>
                <label class='control-label col-sm-3'>#{@text}</label>
                <label class='col-sm-offset-8 control-label col-sm-1 points'>?/#{@points}</label>
            </div>

            #{@pairs.collect{|pair| "            <div class='form-group'>
                <label class='col-sm-offset-3 control-label col-sm-2 slimFont'>#{pair.left}</label>

                <div class='col-sm-6'>
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
end