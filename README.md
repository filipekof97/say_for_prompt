# say_for_prompt

Rotina para facilitar escrever logs ou mensagens em PROMPT/Terminais, de forma a posibilitar a escrita em várias cores.


Sintaxe: say <mensagem> [<fore=cor>] [<back=cor>] . . .

<blockquote>
**<mensagem>:** [Obrigatorio] Mensagem que sera exibida.
<fore=cor>: [Opcional] Cor da letra exibida, sendo por padrao branco
<back=cor>: [Opcional] Cor de fundo da escrita, sendo por padrao preto

Lista de cores: preto, branco, vermelho, amarelo, azul, verde, cinza
               (black, white, red, yellow, blue, green, gray)


Ex: say "Mensagem teste"
    say "Mensagem com cor" fore=red
    say "Mensagem " fore=branco "concatenada" fore=green




