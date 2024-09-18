unit AlephREmFont;

interface

uses
  System.Classes, Fmx.Controls, Fmx.StdCtrls, System.SysUtils, Fmx.Objects;

type

  IRemFontSize = interface
    ['{6719F41F-D2BC-4C5F-A9E4-828F52E45BA7}']
    procedure ResizeFont(Sender: TObject);
  end;

type
  TREmFontSize = class(TPersistent)
  private
    FBaseSize: Integer;
    FREM: Single;
    FOnChange: TNotifyEvent;
    FControl: TControl;
    procedure SetBaseSize(const Value: Integer);
    procedure SetREM(const Value: Single);
  public
    procedure TextResizeHandler(Sender: TObject);
    constructor Create(FBaseSize: Integer);
    destructor Destroy; override;
    function ToPixels: Integer;
  published
    property FontSize: Integer read FBaseSize write SetBaseSize;
    property REM: Single read FREM write SetREM;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

var
  FResizeManager: TREmFontSize = nil;

  { TREmFontSize }

constructor TREmFontSize.Create(FBaseSize: Integer);
begin
  inherited Create;
  FBaseSize := 12; // Valor padr�o para o tamanho base da fonte
  FREM := 1; // Valor padr�o de 1 rem
end;

destructor TREmFontSize.Destroy;
begin
  inherited;
end;

procedure TREmFontSize.SetBaseSize(const Value: Integer);
begin
  if FBaseSize <> Value then
  begin
    FBaseSize := Value;
    TextResizeHandler(nil);
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TREmFontSize.SetREM(const Value: Single);
begin
  if FREM <> Value then
  begin
    FREM := Value;
    TextResizeHandler(nil);
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TREmFontSize.TextResizeHandler(Sender: TObject);
var
  Component: IRemFontSize;
begin
  if Supports(FControl, IRemFontSize, Component) then
  begin
    Component.ResizeFont(Sender);
  end;
end;

function TREmFontSize.ToPixels: Integer;
begin
  Result := Round(FREM * FBaseSize);
end;

end.

