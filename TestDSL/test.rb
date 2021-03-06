
class Test
  NAME = 'test'

  attr_accessor :title, :minimalPoints, :questions

  def initialize(title, minimalPoints)
    @title = title
    @minimalPoints = minimalPoints
    @questions = []
  end

  def last_question
    @questions.last.question
  end

  def add_question(question)
    @questions << Tuple.new("question#{@questions.length + 1}", question)
  end

  def total_points
    @questions.inject(0) {|sum, n| sum + n.question.points}
  end

  def passing_minimum
    @minimalPoints
  end

  def to_html
    "<!DOCTYPE html>
<html lang = 'en'>

<head>
    <title>#{@title}</title>

    <meta charset = 'utf-8'>
    <meta http-equiv = 'X-UA-Compatible' content = 'IE = edge'>
    <meta name = 'viewport' content = 'width = device-width, initial-scale = 1'>


    <!-- Bootstrap Core CSS -->
    <link rel='stylesheet' href='css/bootstrap.min.css' type='text/css'>

    <!-- Custom Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>
    <link rel='stylesheet' href='font-awesome/css/font-awesome.min.css' type='text/css'>

    <!-- Plugin CSS -->
    <link rel='stylesheet' href='css/animate.min.css' type='text/css'>

    <!-- Custom CSS -->
    <link rel='stylesheet' href='css/creative.css' type='text/css'>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->

    <!--[if lt IE 9]>
    <![endif]-->
    <!-- jQuery -->
    <script src='js/jquery.js'></script>

    <!-- Bootstrap Core JavaScript -->
    <script src='js/bootstrap.min.js'></script>

    <!-- Plugin JavaScript -->
    <script src='js/jquery.easing.min.js'></script>
    <script src='js/jquery.fittext.js'></script>
    <script src='js/wow.min.js'></script>

    <script src='js/bootbox.min.js'></script>

    <!-- Custom Theme JavaScript -->
    <script src='js/creative.js'></script>

    <script>
        function test() {
            bootbox.confirm('Are you sure you want to end your test?', function(result) {
                if (result) {
                    window.scrollTo(0, 0);
                    $('#submitBtn').hide();
                    full = #{total_points()};
                    limit = #{passing_minimum()};
                    total = 0;
                    total += #{@questions.collect{|q| "#{q.question.to_js(q.id)}"}.join(";
                    total += ")};

                    $('input').each(function (index, value) {
                        $(value).attr('disabled', true);
                    });
                    $('select').each(function (index, value) {
                        $(value).attr('disabled', true);
                    });

                    $('#information-info').hide();
                    if (total >= limit) {
                        $('#success-points').text(total + '/' + full);
                        $('#success-info').fadeIn();
                    } else {
                        $('#failure-points').text(total + '/' + full);
                        $('#failure-info').fadeIn();
                    }
                }
            });
        }

        function testMultipleChoice(id) {
            selected = $(id);
            possiblePoints = parseFloat($(selected).attr('points'));

            allCorrect = selectedCorrect = 0;

            selectedIncorrect = false;

            $('input', selected).each(function (index, value) {
                toBeSelected = $.parseJSON($(value).attr('correct'));

                if (toBeSelected) {
                    $(value).parent().parent().addClass('has-success');
                } else {
                    $(value).parent().parent().addClass('has-error');
                }

                checked = $(value).is(':checked');
                if (toBeSelected) {
                    allCorrect += 1; // increment all
                    if (checked) {
                        selectedCorrect+= 1; // increment points
                    }
                } else {
                    if (checked) {
                        selectedIncorrect = true;
                    }
                }
            });

            points = 0;
            if (!selectedIncorrect) {
                points = (selectedCorrect * possiblePoints) / allCorrect;
                points = (Math.round(points * 100) / 100);
            }
            $('.points', selected).text(points + '/' + possiblePoints);
            return points;
        }

        function testSingleChoice(id) {
            selected = $(id);
            possiblePoints = parseFloat($(selected).attr('points'));

            selectedCorrect = false;

            $('input', selected).each(function (index, value) {
                correct = $.parseJSON($(value).attr('correct'));
                if (correct) {
                    $(value).parent().parent().addClass('has-success');
                } else {
                    $(value).parent().parent().addClass('has-error');
                }
                if ($(value).is(':checked')) {
                    if (correct) {
                        selectedCorrect = true;
                    } else {
                        selectedCorrect = false;
                    }
                }
            });

            points = selectedCorrect ? possiblePoints : 0;
            points = (Math.round(points * 100) / 100);

            $('.points', selected).text(points + '/' + possiblePoints);

            return points;
        }

        function testFreeAnswer(id) {
            selected = $(id);
            possiblePoints = parseFloat($(selected).attr('points'));

            correctAnswer = $('input', selected).attr('correctAnswer');
            answer = $('input', selected).val();
            caseSensitive = $.parseJSON($('input', selected).attr('caseSensitive'));

            if (!caseSensitive) {
                answer = answer.toLocaleUpperCase();
                correctAnswer = correctAnswer.toLocaleUpperCase();
            }

            $('input', selected).parent().addClass((correctAnswer == answer) ? 'has-success' : 'has-error');

            points = (correctAnswer == answer) ? possiblePoints : 0;
            points = (Math.round(points * 100) / 100);
            $('.points', selected).text(points + '/' + possiblePoints);

            return points;
        }

        function testPairingAnswer(id) {
            selected = $(id);
            possiblePoints = parseFloat($(selected).attr('points'));

            allQuestions = correctMatches= 0;

            $('select', selected).each(function (index, value) {
                allQuestions += 1;
                selectedValue = $(value).val();
                correctValue = $(value).attr('correct');
                if (selectedValue == correctValue) {
                    correctMatches += 1;
                    $(value).parent().addClass('has-success');
                } else {
                    $(value).parent().addClass('has-error');
                }
            });

            points = (correctMatches * possiblePoints) / allQuestions;
            points = (Math.round(points * 100) / 100);
            $('.points', selected).text(points + '/' + possiblePoints);

            return points;
        }
    </script>

    <style>
        .slimFont {
            min-height: 20px;
            padding-left: 20px;
            margin-bottom: 0;
            font-weight: 400;
            cursor: pointer;
        }
        .questionHeader {
            padding: 10px;
            margin-bottom: 5px;
            border: 1px solid transparent;
            border-radius: 4px;

            background-color: #e0ebf0;
            border-color: #c6cfe9;
        }
    </style>
</head>

<body>
<div class = 'container'>
    <h1 class='text-center'>#{@title}</h1>

    <div class='alert alert-success collapse' id='success-info'>
        <strong>Congratulations!</strong> You have passed with <strong id='success-points'></strong> points.
    </div>

    <div class='alert alert-danger collapse' id='failure-info'>
        <strong>Failure!</strong> You have failed with <strong id='failure-points'></strong> points (passing limit was at least #{passing_minimum()} points).
    </div>

    <div class='alert alert-warning' id='information-info'>
        <strong>Be careful!</strong> You will need <strong>#{passing_minimum()}</strong> of total #{total_points()} points to pass the test.
    </div>

    #{@questions.collect{|q| q.question.to_html(q.id)}.join("\n")}

    <div style='margin:25px 0 25px 0;'>
        <form class='form-horizontal' role='form' points='10'>
            <div class='form-group'>
                <div class='col-sm-offset-5 col-sm-1'>
                    <button id='submitBtn' type='button' onclick='test()' class='btn btn-default'>Submit</button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>"
  end

  def to_s
    "Test \'#{@text}\' with minimal passing #{passing_minimum()} of #{total_points()} is\n#{@questions.collect{|q| q.question}.join("\n")}"
  end

  def validate(errorReporter)
    correct = true

    unless @minimalPoints.between?(0,total_points)
      errorReporter.reportError self, "Minimal points for the success in the test '#{@title}' has to be in range 0-#{total_points} (total possible points for the test), you have stated #{@minimalPoints}! Fix it please!"
      correct = false
    end

    usedQuestions = []
    @questions.each do |qt|
      q = qt.question
      if usedQuestions.include? q.text
        errorReporter.reportError self, "You have defined two question with text: '#{q.text}', fix it (you can have only one question with the same text)!"
        correct = false
      else
        usedQuestions << q.text
      end
      tempCorrectQuestion = q.validate(errorReporter)
      correct = correct && tempCorrectQuestion
    end

    if @title.strip.empty?
      errorReporter.reportError self, "Test have to have a title, fix it please."
      correct = false
    end

    if @questions.empty?
      errorReporter.reportError self, "Test '#{@title}' has to have at least a single question, add it please."
      correct = false
    end

    return correct
  end
end

class Tuple
  attr_accessor :id, :question

  def initialize(id, question)
    @id = id
    @question = question
  end
end