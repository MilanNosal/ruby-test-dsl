require_relative './test'
require_relative './single_option_question'
require_relative './multiple_options_question'
require_relative './open_question'
require_relative './matching_pairs_question'
require_relative './answer'
require_relative './matching_pair'

ANO = true
NIE = false

# Vytvorí nový test. V rámci testu je možné definovať jeho názov, počet percent, ktoré je potrebné dosiahnúť na úspech v teste, a zoznam otázok, ktoré budú v teste.
# Potom nasleduje zoznam otázok v rámci testu.
# Parametre:
# _nazov_:: Text v úvodzovkách definujúci názov testu.
# _potrebnePercentaBodov_:: Číslo od 0 do 100 definujúce, koľko percent bodov je potrebné dosiahnúť na úspech.
def test (nazov, potrebnePercentaBodov)
  @test = Test.new nazov, potrebnePercentaBodov
  @errorReporter = ErrorReporter.new
  @errorReporter.register @test
end

# Spustí vytvorený test (tento príkaz sa volá na konci súboru). Ak sú v definícii testu nejaké logické chyby, tak test nie je spustený - vtedy je potrebné ohlásené chyby opraviť.
def spusti
  if validate(@test)
    generate(@test)
  else
    $stderr.puts "Našli sa chyby, prosím oprav ich a spusti test znova."
  end
end

# Vytvorí otázku s jedinou správnou odpoveďou. Otázka definuje viacero odpovedí, z ktorých je jedna správna. Pre výber odpovede je použitý radio button umožňujúci vybrať len jednu odpoveď.
# Otázka musí mať práve jednu správnu a aspoň jednu nesprávnu odpoveď.
# Za otázkou nasleduje zoznam odpovedí pre danú otázku.
# Parametre:
# _text_:: Text otázky v úvodzovkách.
# _body_:: Počet bodov za danú otázku (musí byť aspoň jeden bod).
def otazka_s_jednou_spravnou_odpovedou(text, body)
  question = SingleOptionQuestion.new(text, body)
  @errorReporter.register question
  @test.add_question question
end

# Vytvorí otázku s viacerými správnymi možnosťami. Správnych odpovedí môže byť viac. Za výber každej z nich je možné získať podiel z možných bodov, napr. ak sú 2 správne odpovede dokopy za 5 bodov, vybratím jednej zíkame 2.5 boda (5/2). Ak však vyberieme čo i len jednu nesprávnu odpoveď, nezískame žiadne body.
# Otázka musí mať aspoň jednu správnu a aspoň jednu nesprávnu odpoveď.
# Za otázkou nasleduje zoznam odpovedí pre danú otázku.
# Parametre:
# _text_:: Text otázky v úvodzovkách.
# _body_:: Počet bodov za danú otázku (musí byť aspoň jeden bod).
def otazka_s_viacerymi_spravnymi_odpovedami(text, body)
  question = MultipleOptionsQuestion.new(text, body)
  @errorReporter.register question
  @test.add_question question
end

# Vytvorí otázku s voľnou odpoveďou (nie je poskytnutá množina odpovedí, z ktorej sa vyberá, ale je potrebné odpoveď vpísať do políčka). Otázka má len jednu správnu odpoveď, ktorú je potrebné uhádnuť. Akákoľvek iná vpísaná odpoveď je považovaná za nesprávnu.
# Predvolene neberie ohľad na veľkosť písmen, a teda napr. ak máme správnu odpoveď "Mačička", test uzná za správnu aj hodnotu "MAČIČKA". Toto správanie je možné zmeniť nastavením posledného parametra na ANO.
# Za otázkou nasleduje jedna správna odpoveď na otázku.
# Parametre:
# _text_:: Text otázky v úvodzovkách.
# _body_:: Počet bodov za danú otázku (musí byť aspoň jeden bod).
# _zohladnitVelkeAMalePismena_:: Určuje, či sa pri porovnávaní správnej odpovede s vpísanou hodnotou má brať ohľad na rozdiel vo veľkosti písmen (Zadaj ANO, alebo NIE). Tento parameter je voliteľný, keď sa neuvedie, použije sa hodnota NIE.
def otazka_s_volnou_odpovedou(text, body, zohladnitVelkeAMalePismena = NIE)
  question = OpenQuestion.new(text, body, zohladnitVelkeAMalePismena)
  @errorReporter.register question
  @test.add_question question
end

# Vytvorí otázku, v ktorej riešiteľ hľadá dvojice (páry), ktoré k sebe patria. Príkladom môžu byť páry ako "škola" - "učiteľ", "lietadlo" - "pilot", "kasárne" - "vojak", a podobne, kde ku každému výrazu na ľavo je potrebné nájsť správny prvok z množiny tých čo sú napravo. Prvky sprava sú náhodne premiešané, aby nebolo možné ľahko uhádnuť čo patrí k čomu.
# Za otázkou nasleduje zoznam dvojíc (párov hodnôt) pre danú otázku.
# Parametre:
# _text_:: Text otázky v úvodzovkách.
# _body_:: Počet bodov za danú otázku (musí byť aspoň jeden bod).
def otazka_na_hladanie_parov(text, body)
  question = MatchingPairsQuestion.new(text, body)
  @errorReporter.register question
  @test.add_question question
end

# Vytvorí správnu odpoveď na otázku.
# Parametre:
# _text_:: Text odpovede v úvodzovkách.
def spravna_odpoved(text)
  answer = Answer.new(text, true)
  @errorReporter.register answer
  @test.last_question.add_answer answer
end

# Vytvorí nesprávnu odpoveď na otázku.
# Parametre:
# _text_:: Text odpovede v úvodzovkách.
def nespravna_odpoved(text)
  answer = Answer.new(text, false)
  @errorReporter.register answer
  @test.last_question.add_answer answer
end

# Vytvorí dvojicu k sebe patriacich prvkov pre otázku na hľadanie párov. Prvý prvok je ten, ktorý je zobrazený, druhý je ten, ktorý sa pridá do zoznamu, z ktorého sa vyberá správna dvojica.
# Parametre:
# _prvyPrvok_:: Prvok, ktorý je zobrazený používateľovi.
# _druhyPrvok_:: Prvok, ktorý sa pridá do množiny možností, z ktorých sa vyberá správny pár.
def dvojica(prvyPrvok, druhyPrvok)
  pair = MatchingPair.new(prvyPrvok, druhyPrvok)
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