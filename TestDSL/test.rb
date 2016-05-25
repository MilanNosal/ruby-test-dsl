
class Test
  NAME = 'test'

  attr_accessor :title, :percMinimum, :questions

  def initialize(title, percMinimum)
    @title = title
    unless percMinimum.between?(0,100)
      raise "#{NAME} percMinimum parameter requires to be between 0-100 (it is a percentage), you provided #{percMinimum}!"
    end
    @percMinimum = percMinimum
    @questions = []
  end

  def add_question(question)
    @questions << Tuple.new("question#{@questions.length + 1}", question)
  end

  def get_total_points()
    @questions.inject(0) {|sum, n| sum + n.question.points}
  end

  def get_passing_minimum()
    (get_total_points * (@percMinimum / 100.0)).ceil
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
                    full = #{get_total_points()};
                    limit = #{get_passing_minimum()};
                    total = 0;
                    total += #{@questions.collect{|q| "#{q.question.to_json(q.id)}"}.join(";
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
                checked = $(value).is(':checked');
                if (toBeSelected) {
                    allCorrect += 1; // increment all
                    if (checked) {
                        $(value).parent().parent().addClass('has-success');
                        selectedCorrect+= 1; // increment points
                    }
                } else {
                    if (checked) {
                        $(value).parent().parent().addClass('has-error');
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
                if ($(value).is(':checked')) {
                    if ($.parseJSON($(value).attr('correct'))) {
                        $(value).parent().parent().addClass('has-success');
                        selectedCorrect = true;
                    } else {
                        $(value).parent().parent().addClass('has-error');
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
        <strong>Failure!</strong> You have failed with <strong id='failure-points'></strong> points (passing limit was at least #{get_passing_minimum()} points).
    </div>

    <div class='alert alert-warning' id='information-info'>
        <strong>Be careful!</strong> You will need <strong>#{get_passing_minimum()}</strong> of total #{get_total_points()} points to pass the test.
    </div>

    <h2></h2>

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
    "Test \'#{@text}\' with minimal passing #{get_passing_minimum()} of #{get_total_points()} is\n#{@questions.collect{|q| q.question}.join("\n")}"
  end
end

class Tuple
  attr_accessor :id, :question

  def initialize(id, question)
    @id = id
    @question = question
  end
end