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
  FMX.Forms;

type
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
    procedure AdjustSize;
    constructor Create(AControl: TControl);
    destructor Destroy; override;
  end;

implementation


{ TAlephTipo }

procedure TAlephTipo.AdjustSize;
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
        if PWidth > 0 then
          begin
            FControl.Width := ParentWidth * FPWidth / 100;
          end;
        if PHeight > 0 then
         begin
            FControl.Height := ParentHeight * PHeight / 100;
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
      if self <> nil then
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
  AdjustSize;
  end;
end;

procedure TAlephTipo.SetPWidth(const Value: Integer);
begin
  if FPWidth <> Value then
  begin
  FPWidth := Value;
  AdjustSize;
  end;
end;

end.
