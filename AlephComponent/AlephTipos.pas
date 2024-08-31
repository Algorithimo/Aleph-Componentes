unit AlephTipos;

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
  AlephRem;

type
  TREmMargins = class(TPersistent)
  private
    FTop: TREmSize;
    FLeft: TREmSize;
    FRight: TREmSize;
    FBottom: TREmSize;
    FControl: TControl; // Refer�ncia ao controle
    procedure SetBottom(const Value: TREmSize);
    procedure SetLeft(const Value: TREmSize);
    procedure SetRight(const Value: TREmSize);
    procedure SetTop(const Value: TREmSize);
    procedure OnChange(Sender: TObject);
  public
    constructor Create(AFontBase: TFontBase; AControl: TControl);
    destructor Destroy; override;
    procedure ApplyToControl;
  published
    property Top: TREmSize read FTop write SetTop;
    property Left: TREmSize read FLeft write SetLeft;
    property Right: TREmSize read FRight write SetRight;
    property Bottom: TREmSize read FBottom write SetBottom;
  end;

  TAlephTipo = class(TPersistent)
  private
    FPWidth: Integer;
    FPHeight: Integer;
    FControl: TControl;
    procedure SetPHeight(const Value: Integer);
    procedure SetPWidth(const Value: Integer);

  published
    property PHeight: Integer read FPHeight write SetPHeight;
    property PWidth: Integer read FPWidth write SetPWidth;
  public
    procedure Resize;
    procedure AdjustSize(Sender: TObject);
    constructor Create(AControl: TControl);
    destructor Destroy; override;
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

{ TAlephTipo }

procedure TAlephTipo.AdjustSize(Sender: TObject);
var

  ParentWidth, ParentHeight: Single;
begin
  if Assigned(FControl.Parent) then
  begin
    // Verifica se o Parent � um TForm
    if FControl.Parent is TForm then
    begin
      ParentWidth := TForm(FControl.Parent).ClientWidth;
      ParentHeight := TForm(FControl.Parent).ClientHeight;
    end
    // Verifica se o Parent � um TControl (layout ou ret�ngulo)
    else if FControl.Parent is TControl then
    begin
      ParentWidth := TControl(FControl.Parent).Width;
      ParentHeight := TControl(FControl.Parent).Height;
    end
    else
      Exit; // Se n�o for um TForm ou TControl, n�o faz ajuste

    if Assigned(FControl) then
    begin
      FControl.BeginUpdate;
      try
        if FPWidth > 0 then
        begin
          FControl.Width := ParentWidth * FPWidth / 100;
        end;
        if FPHeight > 0 then
        begin
          FControl.Height := ParentHeight * FPHeight / 100;
        end;
      finally
        FControl.EndUpdate
      end;
    end;
  end;
end;

constructor TAlephTipo.Create(AControl: TControl);
begin
  inherited Create;
  FControl := AControl;
end;

destructor TAlephTipo.Destroy;
begin
  inherited;
end;

procedure TAlephTipo.Resize;
var
  ParentWidth, ParentHeight: Single;
  CurrentWidthPercent, CurrentHeightPercent: Integer;
begin
  if Assigned(FControl.Parent) then
  begin
    if Assigned(FControl.Parent) then
    begin
      // Verifica se o Parent � um TForm
      if FControl.Parent is TForm then
      begin
        ParentWidth := TForm(FControl.Parent).ClientWidth;
        ParentHeight := TForm(FControl.Parent).ClientHeight;
      end
      // Verifica se o Parent � um TControl (layout ou ret�ngulo)
      else if FControl.Parent is TControl then
      begin
        ParentWidth := TControl(FControl.Parent).Width;
        ParentHeight := TControl(FControl.Parent).Height;
      end
      else
      begin
        Exit; // Se n�o for um TForm ou TControl, n�o faz ajuste
      end;

      // Calcula a porcentagem atual da largura e altura em rela��o ao pai
      if ParentWidth > 0 then
        CurrentWidthPercent := Round((FControl.Width / ParentWidth) * 100)
      else
        CurrentWidthPercent := 0;

      if ParentHeight > 0 then
        CurrentHeightPercent := Round((FControl.Height / ParentHeight) * 100)
      else
        CurrentHeightPercent := 0;

      // Agora voc� pode usar CurrentWidthPercent e CurrentHeightPercent como desejar
      if Self <> nil then
      begin
        PWidth := CurrentWidthPercent;
        PHeight := CurrentHeightPercent;
      end;
    end;
  end;
end;

procedure TAlephTipo.SetPHeight(const Value: Integer);
begin
  if FPHeight <> Value then
  begin
    FPHeight := Value;
    AdjustSize(nil);
  end;
end;

procedure TAlephTipo.SetPWidth(const Value: Integer);
begin
  if FPWidth <> Value then
  begin
    FPWidth := Value;
    AdjustSize(nil);
  end;
end;

{ TREmMargins }

constructor TREmMargins.Create(AFontBase: TFontBase; AControl: TControl);
begin
  inherited Create;
  FControl := AControl;

  if not Assigned(AFontBase) then
  begin
    AFontBase := TFontBase.Create(12);
  end;

 if Assigned(AFontBase) then
  begin
    FTop := TREmSize.Create(AFontBase);
    FLeft := TREmSize.Create(AFontBase);
    FRight := TREmSize.Create(AFontBase);
    FBottom := TREmSize.Create(AFontBase);
  end
  else
  begin
    raise Exception.Create('FontBase n�o pode ser nil.');
  end;
  // Adiciona handlers para mudan�a de propriedades
  FTop.OnChange := OnChange;
  FLeft.OnChange := OnChange;
  FRight.OnChange := OnChange;
  FBottom.OnChange := OnChange;
end;

destructor TREmMargins.Destroy;
begin
  if Assigned(FTop) then
    FTop.Free;
  if Assigned(FLeft) then
    FLeft.Free;
  if Assigned(FRight) then
    FRight.Free;
  if Assigned(FBottom) then
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
    // Reaplica as margens e realinha o controle
    FControl.DoRealign;
  end
  else
  begin
    raise Exception.Create('FControl n�o est� atribu�do.');
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
