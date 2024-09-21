unit AlephGroupBox;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.Forms, System.Generics.Collections,
  FMX.StdCtrls, FMX.Objects, AlephRem, AlephTipos, AlephREmFont, GlobalFontSizeManager, ResizeManager;

type
  TAlephGroupBox = class(TGroupBox, IRemFontSize, IGlobalFontSizeAware, IFontSizeAdjustable, IResizable)
  private
    FAlephTipo: TAlephTipo;
    FRemMargins: TREmMargins;
    FRemFontSize: TREmFontSize;
    FGlobalFontSizeManager: TGlobalFontSizeManager;

    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);

    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    function GetTextRem: TREmFontSize;
    procedure SetTextRem(const Value: TREmFontSize);
    procedure SetGlobalFontSizeManager(const Value: TGlobalFontSizeManager);
  protected
    procedure ResizeComponent(Sender: TObject);
    procedure CalculatePercentage(Sender: TObject);
    procedure ResizeFont(Sender: TObject);
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateFontSize(NewBaseSize: Integer);
  published
    property AlephPercentage: TAlephTipo read GetTipo write SetTipo;
    property MarginsRem: TREmMargins read GetRemMargins write SetRemMargins;
    property TextRem: TREmFontSize read GetTextRem write SetTextRem;
    property GlobalFontSizeManager: TGlobalFontSizeManager read FGlobalFontSizeManager write SetGlobalFontSizeManager;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aleph', [TAlephGroupBox]);
end;

{ TAlephGroupBox }

procedure TAlephGroupBox.ResizeComponent(Sender: TObject);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.ResizeComponent(sender);
end;

procedure TAlephGroupBox.CalculatePercentage(Sender: TObject);
begin
  if Assigned(FGlobalFontSizeManager) then
    FGlobalFontSizeManager.CalculatePercentage(sender);
end;

constructor TAlephGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlephTipo := TAlephTipo.Create(Self);
  FRemMargins := TREmMargins.Create(Self);
  FRemFontSize := TREmFontSize.Create(Self);
  GlobalResizeManager.RegisterComponent(Self);
  GlobalResizeManager.RegisterFontSizeComponent(Self);
  //RegisterAlephLayout(Self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := GlobalResizeManager.FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
end;

destructor TAlephGroupBox.Destroy;
begin
  if Assigned(FGlobalFontSizeManager) then
    FGlobalFontSizeManager.UnregisterComponent(Self);
  GlobalResizeManager.UnregisterComponent(Self);
  GlobalResizeManager.UnregisterFontSizeComponent(Self);
  FreeAndNil(FRemMargins);
  FreeAndNil(FRemFontSize);
  FreeAndNil(FAlephTipo);
  inherited;
end;

function TAlephGroupBox.GetRemMargins: TREmMargins;
begin
  Result := FRemMargins;
end;

function TAlephGroupBox.GetTextRem: TREmFontSize;
begin
  Result := FRemFontSize;
end;

function TAlephGroupBox.GetTipo: TAlephTipo;
begin
  Result := FAlephTipo;
end;

procedure TAlephGroupBox.Resize;
begin
  inherited;
  if Assigned(FAlephTipo) then
      FAlephTipo.Resize;
end;

procedure TAlephGroupBox.ResizeFont(Sender: TObject);
begin
  if Assigned(FRemFontSize) then
    TextSettings.Font.Size := FRemFontSize.ToPixels;
end;

procedure TAlephGroupBox.SetRemMargins(const Value: TREmMargins);
begin
  if Assigned(FRemMargins) then
    FRemMargins.Assign(Value);
end;

procedure TAlephGroupBox.SetTextRem(const Value: TREmFontSize);
begin
  if Assigned(FRemFontSize) then
    FRemFontSize.Assign(Value);
end;

procedure TAlephGroupBox.SetTipo(const Value: TAlephTipo);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.Assign(Value);
  ResizeComponent(nil);
end;

procedure TAlephGroupBox.SetGlobalFontSizeManager(const Value: TGlobalFontSizeManager);
begin
  if FGlobalFontSizeManager <> Value then
  begin
    if Assigned(FGlobalFontSizeManager) then
    begin
      FGlobalFontSizeManager.UnregisterComponent(Self);
      RemoveFreeNotification(FGlobalFontSizeManager);
    end;
    FGlobalFontSizeManager := Value;
    if Assigned(FGlobalFontSizeManager) then
    begin
      FGlobalFontSizeManager.RegisterComponent(Self);
      FGlobalFontSizeManager.FreeNotification(Self);
      UpdateFontSize(FGlobalFontSizeManager.BaseSize);
    end;
  end;
end;

procedure TAlephGroupBox.UpdateFontSize(NewBaseSize: Integer);
begin
  if Assigned(FRemFontSize) then
  begin
    FRemFontSize.FontSize := NewBaseSize;
    ResizeFont(Self);
  end;
  if Assigned(FRemMargins) then
  begin
    FRemMargins.AMarginBase.FontBase := NewBaseSize;
    ResizeFont(Self);
  end;
end;

procedure TAlephGroupBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FGlobalFontSizeManager) then
  begin
    FGlobalFontSizeManager := nil;
  end;
end;


end.
