unit Layout_Impl;

interface

uses
  System.Generics.Collections,
  FMX.Forms,
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts;

type
  TDimensionType = (dtWidth, dtHeight);

  TLayoutImplement = class(TLayout)
  private
    FSizePercent: Integer;
    FDimensionType: TDimensionType;
    procedure SetDimensionType(const Value: TDimensionType);
    procedure SetSizePercent(const Value: Integer);
    class procedure GlobalFormResizeHandler(Sender: TObject); static;
    procedure FormResizeHandler(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdjustSize(Sender: TObject);
  published
    property DimensionType: TDimensionType read FDimensionType write SetDimensionType;
    property SizePercent: Integer read FSizePercent write SetSizePercent;
  end;

implementation

{ TLayoutImplement }

procedure RegisterAlephRectangle(ARect: TLayoutImplement);
begin
  if not Assigned(LayoutImplement) then
    LayoutImplement := TList<TLayoutImplement>.Create;
  LayoutImplement.Add(ARect);
end;

procedure TLayoutImplement.AdjustSize(Sender: TObject);
var
  ParentWidth, ParentHeight: Single;
begin
  if Assigned(Self.Parent) then
  begin
    // Verifica se o Parent é um TForm
    if Self.Parent is TForm then
    begin
      ParentWidth := TForm(Self.Parent).ClientWidth;
      ParentHeight := TForm(Self.Parent).ClientHeight;
    end
    // Verifica se o Parent é um TControl (layout ou retângulo)
    else if Self.Parent is TControl then
    begin
      ParentWidth := TControl(Self.Parent).Width;
      ParentHeight := TControl(Self.Parent).Height;
    end
    else
    begin
      Exit; // Se não for um TForm ou TControl, não faz ajuste
    end;
    Self.BeginUpdate;
    try
      case FDimensionType of
        dtWidth:
          Self.Width := ParentWidth * FSizePercent / 100;
        dtHeight:
          Self.Height := ParentHeight * FSizePercent / 100;
      end;
    finally
      Self.EndUpdate
    end;
  end;
end;

constructor TLayoutImplement.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
  RegisterAlephRectangle(Self); // Registra o componente na lista
end;

destructor TLayoutImplement.Destroy;
begin

  inherited;
end;

procedure TLayoutImplement.FormResizeHandler(Sender: TObject);
begin
  GlobalFormResizeHandler(Sender);
end;

class procedure TLayoutImplement.GlobalFormResizeHandler(Sender: TObject);
var
  i: Integer;
begin
  if Assigned(LayoutImplement) then
  begin
    for i := 0 to LayoutImplement.Count - 1 do
    begin
      LayoutImplement[i].AdjustSize(Sender);
    end;
  end;
end;

procedure TLayoutImplement.SetDimensionType(const Value: TDimensionType);
begin
  FDimensionType := Value;
end;

procedure TLayoutImplement.SetSizePercent(const Value: Integer);
begin
  FSizePercent := Value;
end;

end.