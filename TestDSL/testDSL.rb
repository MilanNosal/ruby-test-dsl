require_relative './test'
require_relative './single_option_question'
require_relative './multiple_options_question'
require_relative './open_question'
require_relative './matching_pairs_question'
require_relative './answer'
require_relative './matching_pair'

ANO = true
NIE = false

# Creates a new test. You can define its title, minimal points to success, and the list of questions in the test.
# If there are no errors in the test definition, the program generates an HTML + JS test and runs it. Otherwise, an error is reported along with a link to the line of code that cause the error.
# Parameters:
# _title_:: Text in quotation marks that represent the title.
# _minimalPoints_:: Points minimum for the success. Cannot be negative, nor it can be more than the maximum possible points for the test (calculated as the possible points for all the questions).
def create_test (title, minimalPoints)
  @test = Test.new title, minimalPoints
  @errorReporter = ErrorReporter.new
  @errorReporter.register @test
end

# Runs the created test (this command is used at the end of the test definition). If there are errors in the test definition the test will not run - errors need to be fixed.
def run_test
  if validate(@test)
    generate(@test)
  else
    $stderr.puts "There were some errors, fix them and rerun the program."
  end
end

# Creates a single choice question. The question defines multiple answers, but only a single one is correct.
# In the result it is represented by radio buttons.
# Parameters:
# _text_:: Question text in quotation marks.
# _points_:: Positive number of points for the question.
def single_choice_question(text, points)
  question = SingleOptionQuestion.new(text, points)
  @errorReporter.register question
  @test.add_question question
end

# Creates a multiple choice question. This question type can have multiple correct question, for each selected correct answer the user receives a portion of the possible points, e.g., if there are ten points for the question and it has 2 correct answers, each answer is worth 5 points.
# Selecting incorrect answer nullifies all the points.
# The question has to have at least one correct and one incorrect answer.
# Parameters:
# _text_:: Question text in quotation marks.
# _points_:: Positive number of points for the question.
def multiple_choice_question(text, points)
  question = MultipleOptionsQuestion.new(text, points)
  @errorReporter.register question
  @test.add_question question
end

# Creates open answer question (no options are provided, the user has to fill in a text box). The question has only a single correct answer, all other answers are considered incorrect. By default the answer is not case sensitive.
# Parameters:
# _text_:: Question text in quotation marks.
# _points_:: Positive number of points for the question.
# _correctAnswer_:: The correct answer to the question.
def open_answer_question(text, points, correctAnswer)
  question = OpenQuestion.new(text, points, NIE)
  @errorReporter.register question
  @test.add_question question
  correct_answer(correctAnswer)
end

# Creates pairing question. As an example there can be pairs such as "school" - "teacher", "airplane" - "pilot", "barracks" - "soldier", etc., where you have to match each item on the left with the corresponding one on the right. In the result, items on the right are randomly shuffled.
# Parameters:
# _text_:: Question text in quotation marks.
# _points_:: Positive number of points for the question.
def pairing_question(text, points)
  question = MatchingPairsQuestion.new(text, points)
  @errorReporter.register question
  @test.add_question question
end

# Creates a correct answer option for a question.
# Parameters:
# _text_:: Answer's text in quotation marks.
def correct_answer(text)
  answer = Answer.new(text, true)
  @errorReporter.register answer
  @test.last_question.add_answer answer
end

# Creates an incorrect answer option for a question.
# Parameters:
# _text_:: Answer's text in quotation marks.
def incorrect_answer(text)
  answer = Answer.new(text, false)
  @errorReporter.register answer
  @test.last_question.add_answer answer
end

# Create a pair of corresponding items for the pairing question type.
# Parameters:
# _firstItem_:: Item to be show to the user.
# _secondItem_:: Item to be included in the selection list.
def pair(firstItem, secondItem)
  pair = MatchingPair.new(firstItem, secondItem)
  @errorReporter.register pair
  @test.last_question.add_pair pair
end

def validate(test)
  test.validate(@errorReporter)
end

def generate(test)
  #testTitle = test.title.split(' ').join('')
  link = "./html/test.html"
  puts link
  File.open(link, 'w') { |file| file.write(test.to_html) }

  system "start #{link}"
end

class ErrorReporter
  def initialize
    @objects = {}
  end

  def register(object)
    @objects[object] = caller_locations(2)
  end

  def reportError(object, message)
    $stderr.puts "Riadok #{@objects[object].first.lineno}: #{message}\n"
  end
end