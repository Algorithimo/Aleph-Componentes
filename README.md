# Componentes Visuais Responsivos para FireMonkey

## Visão Geral

Este projeto oferece um conjunto de componentes visuais orientados a objeto, criados para FireMonkey, que tornam sua interface responsiva de forma simples e eficiente. Ele foi desenvolvido para garantir que os componentes se ajustem proporcionalmente ao formulário, mantendo a legibilidade e consistência em dispositivos de diferentes tamanhos e resoluções.

### Principais Funcionalidades

- **Unidade de Medida Proporcional ao Formulário**: Define uma unidade de medida baseada no tamanho do formulário, o que impacta praticamente todos os componentes visuais.
  
- **Crescimento Proporcional dos Componentes**: Os componentes ajustam seu tamanho com base em uma porcentagem do tamanho do elemento pai, iniciando a responsividade na interface.
  
- **`GlobalFontSizeManager`**: Um componente que gerencia a margem e a fonte de botões, labels e edits globalmente. Ele garante que os elementos da interface sejam escalados de acordo com a porcentagem definida, proporcionando uma aparência uniforme em toda a aplicação.

## Componentes Suportados

Atualmente, os seguintes componentes são suportados:

- Botões
- Labels
- Edits
- Rectangle
- CornerButton
- Layout
- RadioButton
- Checkbox
- GroupBox
- Image
- Circle
- SkiaSvg

## Próximos Passos

Os próximos componentes a serem configurados para responsividade são:

- `ListView`
- `Grid`

## Como Usar

1. Adicione os componentes ao seu formulário.
2. Defina a porcentagem de crescimento desejada em relação ao elemento pai.
3. Utilize o `GlobalFontSizeManager` para gerenciar a fonte e a margem globalmente em botões, labels e edits.
4. É necessário ter o Skia4Delphi(Componentes para SVG free) instalado, caso não queria ter Skia, é so excluir o AlephSkSvg.

## Contribuições

Sinta-se à vontade para contribuir com melhorias ou relatar problemas. Este projeto está em constante evolução, e sua contribuição será muito bem-vinda!
