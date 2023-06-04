
/*
* Programador(a): Filipe da Silva Carvalho
* Criado em.....: 03/06/2023
* Funcao........: Rotina para facilitar a escrita de logs ou mensagens de controle para PROMPT, de forma a posibilitar a utilização de várias cores.
* Linguagem.....: Harbour (x64)
* Compilador....: hbmk2
*/

/* Tipo de Formatação*/
#define TIPO_FORMATACAO_SIMPLES   '-m'
#define TIPO_FORMATACAO_COMPOSTO  '-f'

/* Array da Mensagem */
#define ARRAY_MENSAGEM_LINHA      1
#define ARRAY_MENSAGEM_COLUNA     2
#define ARRAY_MENSAGEM_CONTEUDO   3
#define ARRAY_MENSAGEM_COR_FORE   4
#define ARRAY_MENSAGEM_COR_BACK   5

/* Cores */
#define COR_PRETA     'N'
#define COR_BRANCA    'W+'
#define COR_AZUL      'B+'
#define COR_VERDE     'G+'
#define COR_VERMELHO  'R+'
#define COR_AMARELO   'GR+'
#define COR_CINZA     'N+'

/******************************************************************************/
procedure Main( ... )

   local aParametros, aMensagem, aMensagens

   aParametros := hb_AParams()
   //? hb_ValToExp(aParametros)

   if Empty( aParametros ) .or. !CarregarParametros( aParametros, @aMensagens)
      Help()
      return
   endif

   for each aMensagem in aMensagens
      //? hb_ValToExp(aMensagem)
      @ aMensagem[ ARRAY_MENSAGEM_LINHA ],aMensagem[ ARRAY_MENSAGEM_COLUNA ] say aMensagem[ ARRAY_MENSAGEM_CONTEUDO ] color aMensagem[ ARRAY_MENSAGEM_COR_FORE ] + '/' + aMensagem[ ARRAY_MENSAGEM_COR_BACK ]

   next

   ? ''

return

/******************************************************************************/
static procedure Help()

   ? "fore="
   ? "back="
   ? "-m"
   // say -m "Mensagem de Teste" fore=blue

   ? "-f"
   // say -f "Status: ; fore=teste| Em processamento; fore=green"
return

/******************************************************************************/
static function CarregarParametros( aParametros, aMensagens )

   local cTipoFormatacao, nColuna, aParametrosAux

   aMensagens := {}

   /* Foreground and background color pair separated by the slash (/) */

   cTipoFormatacao := aParametros[ 1 ] /* -m or -f */
   hb_ADel( aParametros, 1, .t. )

   if cTipoFormatacao == TIPO_FORMATACAO_SIMPLES

      AdicionarMensagem( @aMensagens, aParametros, Row(), Col() )


   elseif cTipoFormatacao == TIPO_FORMATACAO_COMPOSTO

      aParametros    := hb_ATokens( aParametros[ 1 ], '|' )
      aParametrosAux := AClone( aParametros )
      nColuna        := Col()
      aParametros    := {}

      AEval( aParametrosAux, { | x | AAdd( aParametros, hb_ATokens( x, ';' ) ) } )

      for each aParametrosAux in aParametros
         AdicionarMensagem( @aMensagens, aParametrosAux, Row(), nColuna )
         nColuna += Len( aMensagens[ Len( aMensagens ), ARRAY_MENSAGEM_CONTEUDO ] )
      next

   else
      ? 'ERRO: Opcao desconhecida [' + cTipoFormatacao + ']'
      return .f.

   endif

return .t.

/******************************************************************************/
static procedure AdicionarMensagem( aMensagens, aParametros, nLinha, nColuna )

   local cCorForeground, cCorBackground, cMensagem

   cCorForeground := COR_BRANCA
   cCorBackground := COR_PRETA

   CarregarMensagemArray( aParametros, @cCorForeground, @cCorBackground, @cMensagem )

   AAdd( aMensagens, { nLinha        ,; /* ARRAY_MENSAGEM_LINHA    */
                       nColuna       ,; /* ARRAY_MENSAGEM_COLUNA   */
                       cMensagem     ,; /* ARRAY_MENSAGEM_CONTEUDO */
                       cCorForeground,; /* ARRAY_MENSAGEM_COR_FORE */
                       cCorBackground}) /* ARRAY_MENSAGEM_COR_BACK */

return


/******************************************************************************/
static procedure CarregarMensagemArray( aParametros, cCorForeground, cCorBackground, cMensagem )

   local nPosicao

   /* Foreground */
   nPosicao := AScan( aParametros, { | x | !Empty( hb_at( 'FORE=', Upper( x ) ) ) } )
   if !Empty( nPosicao )
      cCorForeground := ConvertePadraoCoresHarbour( Alltrim( StrTran( Upper( aParametros[ nPosicao ] ), 'FORE=', '') ), COR_BRANCA )
      hb_ADel( aParametros, nPosicao, .t. )
   endif

   /* Background */
   nPosicao := AScan( aParametros, { | x | !Empty( hb_at( 'BACK=', Upper( x ) ) ) } )
   if !Empty( nPosicao )
      cCorBackground := ConvertePadraoCoresHarbour( AllTrim( StrTran( Upper( aParametros[ nPosicao ] ) ), 'BACK=', ''), COR_PRETA )
      hb_ADel( aParametros, nPosicao, .t. )
   endif

   cMensagem := ''
   if !Empty( aParametros )
      cMensagem += ArrayToString( aParametros )
   endif

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

/******************************************************************************/
static function ArrayToString( aArray, cSeparador )

   local cString

   if Empty( cSeparador )
      cSeparador := ''
   endif

   cString := ''

   AEval( aArray, { | x | cString += x + cSeparador } )

   if !Empty( cString )
      cString := SubStr( cString, 0, Len( cString ) - 1 )
   endif

return cString


