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
    FAutoResizer: TLabelAutoResizer;
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    function GetTextRem: TREmFontSize;
    procedure SetTextRem(const Value: TREmFontSize);
    function GetAutoResizeHeight: Boolean;
    procedure SetAutoResizeHeight(const Value: Boolean);
  protected
    procedure ResizeFont(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property MarginsREm: TREmMargins read GetRemMargins write SetRemMargins;
    property TextRem: TREmFontSize  read GetTextRem write SetTextRem;
    property TextAutoResize: Boolean read GetAutoResizeHeight write SetAutoResizeHeight;
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
  FAutoResizer := TLabelAutoResizer.Create(Self);
end;

destructor TAlephLabel.Destroy;
begin
  //FreeAndNil(FAutoResizer);
  FAutoResizer.Free;
  FreeAndNil(FREmMargins);
  FreeAndNil(FRemFontSize);
  inherited;
end;

function TAlephLabel.GetAutoResizeHeight: Boolean;
begin
  Result := FAutoResizer.AutoResizeHeight;
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

procedure TAlephLabel.SetAutoResizeHeight(const Value: Boolean);
begin
  FAutoResizer.AutoResizeHeight := Value;
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