unit AlephImage;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Objects,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Forms,
  System.Generics.Collections,
  AlephRem,
  AlephTipos,
  ResizeManager;

type
  TAlephImage = class(TImage, IResizable)
  private
    FAlephTipo: TAlephTipo;
    FRemMargins : TREmMargins;
    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
  protected
    procedure ResizeComponent(Sender: TObject);
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlephPercentage: TAlephTipo read GetTipo write SetTipo;
    property MarginsRem: TREmMargins  read GetRemMargins write SetRemMargins;

  end;

procedure Register;

implementation

procedure Register;
begin
  // Registrar os componentes na paleta de componentes da IDE
  RegisterComponents('Aleph', [TAlephImage]);
end;

function TAlephImage.GetRemMargins: TREmMargins;
begin
  Result := FRemMargins;
end;

function TAlephImage.GetTipo: TAlephTipo;
begin
  Result := FAlephTipo;
end;

procedure TAlephImage.Resize;
begin
  inherited;
  if Assigned(FAlephTipo) then
      FAlephTipo.Resize;
end;


procedure TAlephImage.SetRemMargins(const Value: TREmMargins);
begin
  if Assigned(FRemMargins) then
    FRemMargins.Assign(Value);
end;

procedure TAlephImage.SetTipo(const Value: TAlephTipo);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.Assign(Value);
  ResizeComponent(nil);
end;

procedure TAlephImage.ResizeComponent(Sender: TObject);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.ResizeComponent(sender);
end;

constructor TAlephImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlephTipo := TAlephTipo.Create(Self);
  FREmMargins := TREmMargins.Create(Self);
  GlobalResizeManager.RegisterComponent(Self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := GlobalResizeManager.FormResizeHandler;
  end;
end;

destructor TAlephImage.Destroy;
begin
  GlobalResizeManager.UnregisterComponent(Self);
  FreeAndNil(FREmMargins);
  FreeAndNil(FAlephTipo);
  inherited Destroy;
end;

end.
