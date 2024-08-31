unit AlephFlexboxEnums;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, FMX.Types, FMX.Controls;

type
  TFlexDirection = (Row, RowReverse, Column, ColumnReverse);
  TJustifyContent = (FlexStart, FlexEnd, Center, SpaceBetween, SpaceAround, SpaceEvenly);
  TAlignItems = (Stretch, AFlexStart, AFlexEnd, ACenter);

  TFlexItem = class(TPersistent)
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

  TFlexContainer = class(TPersistent)
  private
    FItems: TObjectList<TFlexItem>;
    FFlexDirection: TFlexDirection;
    FJustifyContent: TJustifyContent;
    FAlignItems: TAlignItems;
    FControl: TControl; // Armazena o controle (TLayout ou outro TControl)
    procedure CalculateLayout;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddItem(AControl: TControl);
    procedure RemoveItem(AControl: TControl);
    procedure SetControl(AControl: TControl); // Novo método
    property FlexDirection: TFlexDirection read FFlexDirection write FFlexDirection;
    property JustifyContent: TJustifyContent read FJustifyContent write FJustifyContent;
    property AlignItems: TAlignItems read FAlignItems write FAlignItems;
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

constructor TFlexContainer.Create;
begin
  inherited Create;
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

procedure TFlexContainer.AddItem(AControl: TControl);
var
  Item: TFlexItem;
begin
  Item := TFlexItem.Create(AControl);
  FItems.Add(Item);
end;

procedure TFlexContainer.RemoveItem(AControl: TControl);
var
  Item: TFlexItem;
begin
  for Item in FItems do
    if Item.Control = AControl then
    begin
      FItems.Remove(Item);
      Break;
    end;
end;

procedure TFlexContainer.SetControl(AControl: TControl);
begin
  FControl := AControl;
end;

procedure TFlexContainer.CalculateLayout;
var
  TotalSpace, FlexGrowSum, FlexShrinkSum, AvailableSpace, ItemSize, Position, Spacing: Single;
  Item: TFlexItem;
  ItemCount, i: Integer;
begin
  // Verifica se o contêiner está definido
  if not Assigned(FControl) then
    Exit;

  // Inicializa variáveis
  TotalSpace := 0;
  FlexGrowSum := 0;
  FlexShrinkSum := 0;
  ItemCount := FItems.Count;

  // Calcula o espaço total baseado na direção
  case FFlexDirection of
    TFlexDirection.Row, TFlexDirection.RowReverse:
      TotalSpace := FControl.Width;  // Usa a largura real do contêiner
    TFlexDirection.Column, TFlexDirection.ColumnReverse:
      TotalSpace := FControl.Height; // Usa a altura real do contêiner
  end;

  // Calcula somas de flex-grow e flex-shrink
  for Item in FItems do
  begin
    FlexGrowSum := FlexGrowSum + Item.FlexGrow;
    FlexShrinkSum := FlexShrinkSum + Item.FlexShrink;
  end;

  // Calcula o espaço disponível
  AvailableSpace := TotalSpace;
  for Item in FItems do
    AvailableSpace := AvailableSpace - Item.FlexBasis;

  // Distribui o espaço
  for Item in FItems do
  begin
    if AvailableSpace > 0 then
      ItemSize := Item.FlexBasis + (AvailableSpace * (Item.FlexGrow / FlexGrowSum))
    else
      ItemSize := Item.FlexBasis + (AvailableSpace * (Item.FlexShrink / FlexShrinkSum));

    // Ajusta o tamanho do controle conforme a direção
    case FFlexDirection of
      TFlexDirection.Row, TFlexDirection.RowReverse:
        Item.Control.Width := ItemSize;
      TFlexDirection.Column, TFlexDirection.ColumnReverse:
        Item.Control.Height := ItemSize;
    end;
  end;

  // Posiciona os itens
  Position := 0;
  case FFlexDirection of
    TFlexDirection.Row, TFlexDirection.RowReverse:
      begin
        for i := 0 to ItemCount - 1 do
        begin
          Item := FItems[i];
          Item.Control.Position.X := Position;

          // Ajusta o alinhamento
          case FAlignItems of
            TAlignItems.Stretch:
              Item.Control.Height := TotalSpace;
            TAlignItems.ACenter:
              Item.Control.Position.Y := (TotalSpace - Item.Control.Height) / 2;
            TAlignItems.AFlexStart:
              // Posição já está alinhada ao início
              ;
            TAlignItems.AFlexEnd:
              Item.Control.Position.Y := TotalSpace - Item.Control.Height;
          end;

          Position := Position + Item.Control.Width;
        end;
      end;
    TFlexDirection.Column, TFlexDirection.ColumnReverse:
      begin
        for i := 0 to ItemCount - 1 do
        begin
          Item := FItems[i];
          Item.Control.Position.Y := Position;

          // Ajusta o alinhamento
          case FAlignItems of
            TAlignItems.Stretch:
              Item.Control.Width := TotalSpace;
            TAlignItems.ACenter:
              Item.Control.Position.X := (TotalSpace - Item.Control.Width) / 2;
            TAlignItems.AFlexStart:
              // Posição já está alinhada ao início
              ;
            TAlignItems.AFlexEnd:
              Item.Control.Position.X := TotalSpace - Item.Control.Width;
          end;

          Position := Position + Item.Control.Height;
        end;
      end;
  end;

  // Ajuste de justificação
  case FJustifyContent of
    TJustifyContent.FlexStart:
      // Posição já está alinhada ao início
      ;
    TJustifyContent.FlexEnd:
      begin
        case FFlexDirection of
          TFlexDirection.Row, TFlexDirection.RowReverse:
            Spacing := TotalSpace - Position;
          TFlexDirection.Column, TFlexDirection.ColumnReverse:
            Spacing := TotalSpace - Position;
        end;

        for i := 0 to ItemCount - 1 do
        begin
          Item := FItems[i];
          case FFlexDirection of
            TFlexDirection.Row, TFlexDirection.RowReverse:
              Item.Control.Position.X := Item.Control.Position.X + Spacing;
            TFlexDirection.Column, TFlexDirection.ColumnReverse:
              Item.Control.Position.Y := Item.Control.Position.Y + Spacing;
          end;
        end;
      end;
    TJustifyContent.Center:
      begin
        Spacing := (TotalSpace - Position) / 2;
        for i := 0 to ItemCount - 1 do
        begin
          Item := FItems[i];
          case FFlexDirection of
            TFlexDirection.Row, TFlexDirection.RowReverse:
              Item.Control.Position.X := Item.Control.Position.X + Spacing;
            TFlexDirection.Column, TFlexDirection.ColumnReverse:
              Item.Control.Position.Y := Item.Control.Position.Y + Spacing;
          end;
        end;
      end;
    TJustifyContent.SpaceBetween:
      begin
        if ItemCount > 1 then
        begin
          Spacing := (TotalSpace - Position) / (ItemCount - 1);
          for i := 1 to ItemCount - 1 do
          begin
            Item := FItems[i];
            case FFlexDirection of
              TFlexDirection.Row, TFlexDirection.RowReverse:
                Item.Control.Position.X := FItems[i - 1].Control.Position.X + Spacing;
              TFlexDirection.Column, TFlexDirection.ColumnReverse:
                Item.Control.Position.Y := FItems[i - 1].Control.Position.Y + Spacing;
            end;
          end;
        end;
      end;
    TJustifyContent.SpaceAround:
      begin
        if ItemCount > 1 then
        begin
          Spacing := (TotalSpace - Position) / (ItemCount + 1);
          for i := 0 to ItemCount - 1 do
          begin
            Item := FItems[i];
            case FFlexDirection of
              TFlexDirection.Row, TFlexDirection.RowReverse:
                Item.Control.Position.X := Item.Control.Position.X + (Spacing * (i + 1));
              TFlexDirection.Column, TFlexDirection.ColumnReverse:
                Item.Control.Position.Y := Item.Control.Position.Y + (Spacing * (i + 1));
            end;
          end;
        end;
      end;
    TJustifyContent.SpaceEvenly:
      begin
        if ItemCount > 1 then
        begin
          Spacing := (TotalSpace - Position) / (ItemCount + 1);
          for i := 1 to ItemCount - 1 do
          begin
            Item := FItems[i];
            case FFlexDirection of
              TFlexDirection.Row, TFlexDirection.RowReverse:
                Item.Control.Position.X := FItems[i - 1].Control.Position.X + Spacing;
              TFlexDirection.Column, TFlexDirection.ColumnReverse:
                Item.Control.Position.Y := FItems[i - 1].Control.Position.Y + Spacing;
            end;
          end;
        end;
      end;
  end;
end;

end.

