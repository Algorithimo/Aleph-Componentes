unit AlephRectangle;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Forms,
  System.Generics.Collections,
  AlephTipos;

type
  TAlephRectangle = class(TRectangle)
  private
    FAlephTipo: TAlephTipo;
    FCornerPerWidthPercent: Integer;
    FCornerPerHeightPercent: Integer;
    procedure SetCornerPerHeightPercent(const Value: Integer);
    procedure SetCornerPerWidthPercent(const Value: Integer);
    procedure AdjustSize(Sender: TObject);
    procedure FormResizeHandler(Sender: TObject);
    class procedure GlobalFormResizeHandler(Sender: TObject); static;
    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetMarginsWithPercentageHeight(AParentHeight: Integer;
      Top, Bottom, Left, Right: Single);
    procedure SetMarginsWithPercentageWidth(AParentWidth: Integer;
      Top, Bottom, Left, Right: Single);
    procedure AdjustCornerSize(Sender: TObject);
  published
    property Tipo: TAlephTipo read GetTipo write SetTipo;
    property CornerHeightPercent: Integer read FCornerPerHeightPercent
      write SetCornerPerHeightPercent;
    property CornerWidthPercent: Integer read FCornerPerWidthPercent
      write SetCornerPerWidthPercent;
  end;

procedure Register;

implementation

var
  AlephRectangles: TList<TAlephRectangle>;

procedure RegisterAlephRectangle(ARect: TAlephRectangle);
begin
  if not Assigned(AlephRectangles) then
    AlephRectangles := TList<TAlephRectangle>.Create;
  AlephRectangles.Add(ARect);
end;

procedure UnregisterAlephRectangle(ARect: TAlephRectangle);
begin
  if Assigned(AlephRectangles) then
    AlephRectangles.Remove(ARect);
end;

function TAlephRectangle.GetTipo: TAlephTipo;
begin
  Result := FAlephTipo;
end;

class procedure TAlephRectangle.GlobalFormResizeHandler(Sender: TObject);
var
  i: Integer;
begin
  if Assigned(AlephRectangles) then
  begin
    for i := 0 to AlephRectangles.Count - 1 do
    begin
      AlephRectangles[i].AdjustSize(Sender);
    end;
  end;
end;

procedure TAlephRectangle.Resize;
var
  ParentWidth, ParentHeight: Single;
  CurrentWidthPercent, CurrentHeightPercent: Integer;
begin
  inherited;

  if Assigned(Self.Parent) then
  begin
    // Verifica se o Parent � um TForm
    if Self.Parent is TForm then
    begin
      ParentWidth := TForm(Self.Parent).ClientWidth;
      ParentHeight := TForm(Self.Parent).ClientHeight;
    end
    // Verifica se o Parent � um TControl (layout ou ret�ngulo)
    else if Self.Parent is TControl then
    begin
      ParentWidth := TControl(Self.Parent).Width;
      ParentHeight := TControl(Self.Parent).Height;
    end
    else
    begin
      Exit; // Se n�o for um TForm ou TControl, n�o faz ajuste
    end;

    // Calcula a porcentagem atual da largura e altura em rela��o ao pai
    if ParentWidth > 0 then
      CurrentWidthPercent := Round((Self.Width / ParentWidth) * 100)
    else
      CurrentWidthPercent := 0;

    if ParentHeight > 0 then
      CurrentHeightPercent := Round((Self.Height / ParentHeight) * 100)
    else
      CurrentHeightPercent := 0;

    // Agora voc� pode usar CurrentWidthPercent e CurrentHeightPercent como desejar
    FAlephTipo.PWidth := CurrentWidthPercent;
    FAlephTipo.PHeight := CurrentHeightPercent;
  end;
end;


procedure Register;
begin
  RegisterComponents('Aleph', [TAlephRectangle]);
end;

{ TAlephRectangle }

procedure TAlephRectangle.AdjustSize(Sender: TObject);
begin
  FAlephTipo.AdjustSize;
end;

constructor TAlephRectangle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlephTipo := TAlephTipo.Create(self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
  RegisterAlephRectangle(Self); // Registra o componente na lista
end;

destructor TAlephRectangle.Destroy;
begin
  FreeAndNil(AlephRectangles);
  FreeAndNil(FAlephTipo);
  UnregisterAlephRectangle(Self);
  inherited Destroy;
end;

procedure TAlephRectangle.SetMarginsWithPercentageHeight(AParentHeight: Integer;
  Top, Bottom, Left, Right: Single);
var
  NewMarginSizeTop, NewMarginSizeBottom, NewMarginSizeLeft,
    NewMarginSizeRight: Integer;
begin
  Self.BeginUpdate;
  // Calcular o novo tamanho das margens com base na largura do formul�rio e nos percentuais
  NewMarginSizeTop := Round(AParentHeight * Top);
  NewMarginSizeBottom := Round(AParentHeight * Bottom);
  NewMarginSizeLeft := Round(AParentHeight * Left);
  NewMarginSizeRight := Round(AParentHeight * Right);

  // Garantir que os tamanhos das margens n�o fiquem menores que um valor m�nimo
  if NewMarginSizeTop = 0 then
    NewMarginSizeTop := 0;
  if NewMarginSizeBottom = 0 then
    NewMarginSizeBottom := 0;
  if NewMarginSizeLeft = 0 then
    NewMarginSizeLeft := 0;
  if NewMarginSizeRight = 0 then
    NewMarginSizeRight := 0;

  // Ajustar as margens do componente
  Self.Margins.Top := NewMarginSizeTop;
  Self.Margins.Bottom := NewMarginSizeBottom;
  Self.Margins.Left := NewMarginSizeLeft;
  Self.Margins.Right := NewMarginSizeRight;
  Self.EndUpdate;
end;

procedure TAlephRectangle.SetMarginsWithPercentageWidth(AParentWidth: Integer;
  Top, Bottom, Left, Right: Single);
var
  NewMarginSizeTop, NewMarginSizeBottom, NewMarginSizeLeft,
    NewMarginSizeRight: Integer;
begin
  Self.BeginUpdate;
  // Calcular o novo tamanho das margens com base na largura do formul�rio e nos percentuais
  NewMarginSizeTop := Round(AParentWidth * Top);
  NewMarginSizeBottom := Round(AParentWidth * Bottom);
  NewMarginSizeLeft := Round(AParentWidth * Left);
  NewMarginSizeRight := Round(AParentWidth * Right);

  // Garantir que os tamanhos das margens n�o fiquem menores que um valor m�nimo
  if NewMarginSizeTop = 0 then
    NewMarginSizeTop := 0;
  if NewMarginSizeBottom = 0 then
    NewMarginSizeBottom := 0;
  if NewMarginSizeLeft = 0 then
    NewMarginSizeLeft := 0;
  if NewMarginSizeRight = 0 then
    NewMarginSizeRight := 0;

  // Ajustar as margens do componente
  Self.Margins.Top := NewMarginSizeTop;
  Self.Margins.Bottom := NewMarginSizeBottom;
  Self.Margins.Left := NewMarginSizeLeft;
  Self.Margins.Right := NewMarginSizeRight;
  Self.EndUpdate;
end;

procedure TAlephRectangle.SetTipo(const Value: TAlephTipo);
begin
  FAlephTipo.Assign(Value);
  AdjustSize(nil);
end;

procedure TAlephRectangle.AdjustCornerSize(Sender: TObject);
begin
  Self.BeginUpdate;

  if CornerHeightPercent = 0 then
  Begin

    Self.XRadius := Self.Height * CornerHeightPercent / 100;
    Self.YRadius := Self.Height * CornerHeightPercent / 100;
  End;

  if CornerWidthPercent = 0 then
  Begin

    Self.XRadius := Self.Width * CornerWidthPercent / 100;
    Self.YRadius := Self.Width * CornerWidthPercent / 100;
  End;

  Self.EndUpdate;
end;

procedure TAlephRectangle.SetCornerPerHeightPercent(const Value: Integer);
begin
  FCornerPerHeightPercent := Value;
end;

procedure TAlephRectangle.SetCornerPerWidthPercent(const Value: Integer);
begin
  FCornerPerWidthPercent := Value;
end;

// ---------------------  AdjustCornerSize ---------------------  //

procedure TAlephRectangle.FormResizeHandler(Sender: TObject);
begin
  GlobalFormResizeHandler(Sender);

end;

end.