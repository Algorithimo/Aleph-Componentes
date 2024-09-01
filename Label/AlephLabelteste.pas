unit AlephLabelteste;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TAlephLabetestel = class(TLabel)
  public
    procedure AdjustSizeComponent(AFormClientWidth: Integer; BaseFontSize: Integer; FontSizePercent: Double);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aleph', [TAlephLabetestel]);
end;

{ TAlephLabelTeste }

procedure TAlephLabetestel.AdjustSizeComponent(AFormClientWidth: Integer; BaseFontSize: Integer; FontSizePercent: Double);
var
  NewFontSize: Integer;
begin
  Self.BeginUpdate;

  NewFontSize := Trunc(AFormClientWidth * FontSizePercent);

  if NewFontSize < BaseFontSize then
  begin
    NewFontSize := BaseFontSize;
  end;


  Self.TextSettings.Font.Size := NewFontSize;

  Self.EndUpdate;
end;

end.
