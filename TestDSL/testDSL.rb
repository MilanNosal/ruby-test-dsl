require_relative './test'
require_relative './single_option_question'
require_relative './multiple_options_question'
require_relative './open_question'
require_relative './matching_pairs_question'
require_relative './answer'
require_relative './pair'



test = Test.new 'Novy test', 100

question = SingleOptionQuestion.new 'Kto je Maros?', 10
question.add_answer (Answer.new('Gej', true))
question.add_answer (Answer.new('Gejos', false))
question.add_answer (Answer.new('Puci', false))
question.add_answer (Answer.new('Dudok', false))
test.add_question question

question = MultipleOptionsQuestion.new 'Kto je Mato?', 8
question.add_answer (Answer.new('Jojo', true))
question.add_answer (Answer.new('Dudok', false))
question.add_answer (Answer.new('Pupek', true))
question.add_answer (Answer.new('Tucko', false))


test.add_question question

question = OpenQuestion.new 'Kto je Misko?', 12
question.add_answer (Answer.new('Jojo', true))


test.add_question question


question = MatchingPairsQuestion.new 'Sparuj bratov podla iq', 20
question.add_pair (Pair.new('Milan', 'Milan'))
question.add_pair (Pair.new('Michal', 'Michal'))
question.add_pair (Pair.new('Matej', 'Matej'))
question.add_pair (Pair.new('Maros', 'Maros'))


test.add_question question

File.open('../html/test.html', 'w') { |file| file.write(test.to_html) }


system 'start ../html/test.html'