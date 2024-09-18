unit AlephLabel;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  System.Generics.Collections,
  AlephRem,
  AlephTipos,
  AlephREmFont;

type
  TAlephLabel = class(TLabel, IRemFontSize)
  private
    FRemMargins: TREmMargins;
    FRemFontSize: TREmFontSize;
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    function GetTextRem: TREmFontSize;
    procedure SetTextRem(const Value: TREmFontSize);
  protected
    procedure ResizeFont(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property MarginsREm: TREmMargins read GetRemMargins write SetRemMargins;
    property TextRem: TREmFontSize  read GetTextRem write SetTextRem;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aleph', [TAlephLabel]);
end;

{ TAlephLabel }

constructor TAlephLabel.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
  FREmMargins := TREmMargins.Create(Self);
  FRemFontSize := TREmFontSize.Create(Self);
end;

destructor TAlephLabel.Destroy;
begin
  FreeAndNil(FREmMargins);
  FreeAndNil(FRemFontSize);
  inherited;
end;


function TAlephLabel.GetRemMargins: TREmMargins;
begin
  Result := FRemMargins;
end;

function TAlephLabel.GetTextRem: TREmFontSize;
begin
  Result := FRemFontSize;
end;

procedure TAlephLabel.ResizeFont(Sender: TObject);
begin
   if Assigned(FRemFontSize) then
      self.TextSettings.Font.Size := FRemFontSize.ToPixels;
end;

procedure TAlephLabel.SetRemMargins(const Value: TREmMargins);
begin
  if Assigned(FRemMargins) then
    FRemMargins.Assign(Value);
end;

procedure TAlephLabel.SetTextRem(const Value: TREmFontSize);
begin
  if Assigned(FRemFontSize) then
    FRemFontSize.Assign(Value);
end;

end.
