unit AlephFlexbox;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, FMX.Types, FMX.Controls, AlephFlexboxInterfaces;
type
  TFlexItem = class
  private
    FControl: TControl;
    FFlexGrow: Single;
    FFlexShrink: Single;
    FFlexBasis: Single;
  public
    constructor Create(AControl: TControl);
    property Control: TControl read FControl;
    property FlexGrow: Single read FFlexGrow write FFlexGrow;
    property FlexShrink: Single read FFlexShrink write FFlexShrink;
    property FlexBasis: Single read FFlexBasis write FFlexBasis;
  end;
  TFlexContainer = class(TControl, IFlexContainer)
  private
    FItems: TObjectList<TFlexItem>;
    FFlexDirection: TFlexDirection;
    FJustifyContent: TJustifyContent;
    FAlignItems: TAlignItems;
    function GetFlexDirection: TFlexDirection;
    procedure SetFlexDirection(Value: TFlexDirection);
    function GetJustifyContent: TJustifyContent;
    procedure SetJustifyContent(Value: TJustifyContent);
    function GetAlignItems: TAlignItems;
    procedure SetAlignItems(Value: TAlignItems);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CalculateLayout;
    procedure AddItem(AItem: TFlexItem);
    procedure RemoveItem(AItem: TFlexItem);
    function GetItems: TList<TFlexItem>;
    property FlexDirection: TFlexDirection read GetFlexDirection write SetFlexDirection;
    property JustifyContent: TJustifyContent read GetJustifyContent write SetJustifyContent;
    property AlignItems: TAlignItems read GetAlignItems write SetAlignItems;
  end;
implementation
{ TFlexItem }
constructor TFlexItem.Create(AControl: TControl);
begin
  inherited Create;
  FControl := AControl;
  FFlexGrow := 0;
  FFlexShrink := 1;
  FFlexBasis := 0;
end;
{ TFlexContainer }
constructor TFlexContainer.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TObjectList<TFlexItem>.Create(True);
  FFlexDirection := TFlexDirection.Row;
  FJustifyContent := TJustifyContent.FlexStart;
  FAlignItems := TAlignItems.Stretch;
end;
destructor TFlexContainer.Destroy;
begin
  FItems.Free;
  inherited;
end;
procedure TFlexContainer.AddItem(AItem: TFlexItem);
begin
  FItems.Add(AItem);
  AItem.Control.Parent := Self;
end;
procedure TFlexContainer.RemoveItem(AItem: TFlexItem);
begin
  FItems.Remove(AItem);
end;
function TFlexContainer.GetItems: TList<TFlexItem>;
begin
  Result := FItems;
end;
procedure TFlexContainer.CalculateLayout;
var
  TotalSpace, FlexGrowSum, FlexShrinkSum, AvailableSpace: Single;
  Item: TFlexItem;
  ItemSize: Single;
begin
  // Simplifica��o para dire��o de linha
  if FFlexDirection in [TFlexDirection.Row, TFlexDirection.RowReverse] then
    TotalSpace := Width
  else
    TotalSpace := Height;
  // Calcular somas de flex-grow e flex-shrink
  FlexGrowSum := 0;
  FlexShrinkSum := 0;
  for Item in FItems do
  begin
    FlexGrowSum := FlexGrowSum + Item.FlexGrow;
    FlexShrinkSum := FlexShrinkSum + Item.FlexShrink;
  end;
  // Calcular espa�o dispon�vel
  AvailableSpace := TotalSpace;
  for Item in FItems do
    AvailableSpace := AvailableSpace - Item.FlexBasis;
  // Distribuir espa�o
  for Item in FItems do
  begin
    if AvailableSpace > 0 then
      ItemSize := Item.FlexBasis + (AvailableSpace * (Item.FlexGrow / FlexGrowSum))
    else
      ItemSize := Item.FlexBasis + (AvailableSpace * (Item.FlexShrink / FlexShrinkSum));
    // Aplicar tamanho ao controle
    if FFlexDirection in [TFlexDirection.Row, TFlexDirection.RowReverse] then
      Item.Control.Width := ItemSize
    else
      Item.Control.Height := ItemSize;
  end;
  // Posicionar itens (simplificado para FlexStart)
  var Position: Single := 0;
  for Item in FItems do
  begin
    if FFlexDirection in [TFlexDirection.Row, TFlexDirection.RowReverse] then
    begin
      Item.Control.Position.X := Position;
      Position := Position + Item.Control.Width;
    end
    else
    begin
      Item.Control.Position.Y := Position;
      Position := Position + Item.Control.Height;
    end;
  end;
end;
function TFlexContainer.GetFlexDirection: TFlexDirection;
begin
  Result := FFlexDirection;
end;
procedure TFlexContainer.SetFlexDirection(Value: TFlexDirection);
begin
  FFlexDirection := Value;
  CalculateLayout;
end;
function TFlexContainer.GetJustifyContent: TJustifyContent;
begin
  Result := FJustifyContent;
end;
procedure TFlexContainer.SetJustifyContent(Value: TJustifyContent);
begin
  FJustifyContent := Value;
  CalculateLayout;
end;
function TFlexContainer.GetAlignItems: TAlignItems;
begin
  Result := FAlignItems;
end;
procedure TFlexContainer.SetAlignItems(Value: TAlignItems);
begin
  FAlignItems := Value;
  CalculateLayout;
end;
end.

