unit LayoutGof;

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
  System.Generics.Collections;

type
  TREmSize = class(TPersistent)
  private
    FFontBase: Single;
    FREM: Single;
    FOnChange: TNotifyEvent;
    procedure SetFontBase(const Value: Single);
    procedure SetREM(const Value: Single);
  public
    constructor Create(ABaseSize: Single);
    destructor Destroy; override;
    function ToPixels: Single;
  published
    property REM: Single read FREM write SetREM;
    property FontBase: Single read FFontBase write SetFontBase;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TREmMargins = class(TPersistent)
  private
    FTop: TREmSize;
    FLeft: TREmSize;
    FRight: TREmSize;
    FBottom: TREmSize;
    FControl: TControl; // Referência ao controle
    procedure SetBottom(const Value: TREmSize);
    procedure SetLeft(const Value: TREmSize);
    procedure SetRight(const Value: TREmSize);
    procedure SetTop(const Value: TREmSize);
    procedure OnChange(Sender: TObject);
  public
    constructor Create(BaseSize: Single; AControl: TControl);
    destructor Destroy; override;
    procedure ApplyToControl;
  published
    property Top: TREmSize read FTop write SetTop;
    property Left: TREmSize read FLeft write SetLeft;
    property Right: TREmSize read FRight write SetRight;
    property Bottom: TREmSize read FBottom write SetBottom;
  end;

  TControlHelper = class helper for TControl
  public
    procedure DoRealign;
  end;

implementation

{ TControlHelper }

procedure TControlHelper.DoRealign;
begin
  Self.Realign;
end;

{ TREmSize }

constructor TREmSize.Create(ABaseSize: Single);
begin
  FFontBase := ABaseSize;
  FREM := 1; // Valor padrão de 1 rem
end;

destructor TREmSize.Destroy;
begin
  inherited Destroy;
end;

procedure TREmSize.SetFontBase(const Value: Single);
begin
  if FFontBase <> Value then
  begin
    FFontBase := Value;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TREmSize.SetREM(const Value: Single);
begin
  if FREM <> Value then
  begin
    FREM := Value;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

function TREmSize.ToPixels: Single;
begin
  Result := FREM * FFontBase;
end;

{ TREmMargins }

constructor TREmMargins.Create(BaseSize: Single; AControl: TControl);
begin
  inherited Create;
  FControl := AControl;
  FTop := TREmSize.Create(BaseSize);
  FLeft := TREmSize.Create(BaseSize);
  FRight := TREmSize.Create(BaseSize);
  FBottom := TREmSize.Create(BaseSize);
  // Adiciona handlers para mudança de propriedades
  FTop.OnChange := OnChange;
  FLeft.OnChange := OnChange;
  FRight.OnChange := OnChange;
  FBottom.OnChange := OnChange;
end;

destructor TREmMargins.Destroy;
begin
  FTop.Free;
  FLeft.Free;
  FRight.Free;
  FBottom.Free;
  inherited Destroy;
end;

procedure TREmMargins.OnChange(Sender: TObject);
begin
  ApplyToControl;
end;

procedure TREmMargins.ApplyToControl;
begin
  if Assigned(FControl) then
  begin
    FControl.Margins.Top := FTop.ToPixels;
    FControl.Margins.Left := FLeft.ToPixels;
    FControl.Margins.Right := FRight.ToPixels;
    FControl.Margins.Bottom := FBottom.ToPixels;
    FControl.DoRealign; // Chama o Realign via helper
  end;
end;

procedure TREmMargins.SetBottom(const Value: TREmSize);
begin
  FBottom.Assign(Value);
  ApplyToControl; // Aplica as margens automaticamente
end;

procedure TREmMargins.SetLeft(const Value: TREmSize);
begin
  FLeft.Assign(Value);
  ApplyToControl; // Aplica as margens automaticamente
end;

procedure TREmMargins.SetRight(const Value: TREmSize);
begin
  FRight.Assign(Value);
  ApplyToControl; // Aplica as margens automaticamente
end;

procedure TREmMargins.SetTop(const Value: TREmSize);
begin
  FTop.Assign(Value);
  ApplyToControl; // Aplica as margens automaticamente
end;

end.

