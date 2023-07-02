/*
* Programador...: Filipe da Silva Carvalho
* Criado em.....: 03/06/2023
* Funcao........: Rotina para facilitar a escrita de logs ou mensagens de controle para PROMPT, de forma a posibilitar a utilizacao de varias cores.
* Linguagem.....: Harbour (xBase)
* Compilador....: hbmk2
*/

/* Array da Mensagem */
#define ARRAY_MENSAGEM_CONTEUDO   1
#define ARRAY_MENSAGEM_COR_FORE   2
#define ARRAY_MENSAGEM_COR_BACK   3

/* Cores */
#define COR_PRETA     'N'
#define COR_BRANCA    'W+'
#define COR_AZUL      'B+'
#define COR_VERDE     'G+'
#define COR_VERMELHO  'R+'
#define COR_AMARELO   'GR+'
#define COR_CINZA     'N+'

/******************************************************************************/
procedure main( ... )

   local aParametros, aMensagem, aMensagens

   aParametros := Hb_AParams()

   if Empty( aParametros )
      Help()
      return
   endif

   CarregarParametros( aParametros, @aMensagens)

   for each aMensagem in aMensagens
      SetColor( aMensagem[ ARRAY_MENSAGEM_COR_FORE ] + '/' + aMensagem[ ARRAY_MENSAGEM_COR_BACK ] )
      ?? aMensagem[ ARRAY_MENSAGEM_CONTEUDO ]
   next

   ? ''

return

/******************************************************************************/
static procedure Help()

   ? '   Sintaxe: say <mensagem> [<fore=cor>] [<back=cor>] ...'
   ? ' '
   ? '   <mensagem>: [Obrigatorio] Mensagem que sera exibida.'
   ? '   <fore=cor>: [Opcional] Cor da letra exibida, sendo por padrao branco'
   ? '   <back=cor>: [Opcional] Cor de fundo da escrita, sendo por padrao preto'
   ? ' '
   ? '   Lista de cores: preto, branco, vermelho, amarelo, azul, verde, cinza'
   ? '                   (black, white, red, yellow, blue, green, gray)'
   ? ' '
   ? ' '
   ? '     Ex: say "Mensagem teste"'
   ? '         say "Mensagem com cor" fore=red'
   ? '         say "Mensagem " fore=branco "concatenada" fore=green'
   ? ' '

return

/******************************************************************************/
static procedure CarregarParametros( aParametros, aMensagens )

   local cMensagem, cForeground, cBackground

   aMensagens := {}


   do while !Empty( aParametros )

      cMensagem    := ''
      cForeground  := ''
      cBackground  := ''

      do while !Empty( aParametros )

         if !Empty( Hb_At( 'FORE=', Upper( aParametros[ 1 ] ) ) )
            if !Empty( cForeground )
               exit
            endif

            cForeground := ConvertePadraoCoresHarbour( Alltrim( StrTran( Upper( aParametros[ 1 ] ), 'FORE=', '') ), COR_BRANCA )

         elseif !Empty( Hb_At( 'BACK=', Upper( aParametros[ 1 ] ) ) )
            if !Empty( cBackground )
               exit
            endif

            cBackground :=  ConvertePadraoCoresHarbour( AllTrim( StrTran( Upper( aParametros[ 1 ] ), 'BACK=', '' ) ), COR_PRETA )

         else
            if !Empty( cMensagem )
               exit
            endif

            cMensagem := aParametros[ 1 ]

         endif

         hb_ADel( aParametros, 1, .t. )
      enddo

      if Empty( cForeground )
         cForeground := COR_BRANCA
      endif

      if Empty( cBackground )
         cBackground := COR_PRETA
      endif

      AAdd( aMensagens, { cMensagem   ,;  /* ARRAY_MENSAGEM_CONTEUDO */
                          cForeground ,;  /* ARRAY_MENSAGEM_COR_FORE */
                          cBackground } ) /* ARRAY_MENSAGEM_COR_BACK */

   enddo

return

/******************************************************************************/
static function ConvertePadraoCoresHarbour( cNomeCorUpper, cCorDefault )

   if InArray( cNomeCorUpper, { 'BLACK', 'PRETO' } )
      return COR_PRETA

   elseif InArray( cNomeCorUpper, { 'RED', 'VERMELHO' } )
      return COR_VERMELHO

   elseif InArray( cNomeCorUpper, { 'WHITE', 'BRANCO' } )
      return COR_BRANCA

   elseif InArray( cNomeCorUpper, { 'BLUE', 'AZUL' } )
      return COR_AZUL

   elseif InArray( cNomeCorUpper, { 'GREEN', 'VERDE' } )
      return COR_VERDE

   elseif InArray( cNomeCorUpper, { 'YELLOW', 'AMARELO' } )
      return COR_AMARELO

   elseif InArray( cNomeCorUpper, { 'GRAY', 'CINZA' } )
      return COR_CINZA

   endif

return cCorDefault

/******************************************************************************/
static function InArray( xValue, aArray )

return !Empty( AScan( aArray, { | x | x == xValue } ) )
