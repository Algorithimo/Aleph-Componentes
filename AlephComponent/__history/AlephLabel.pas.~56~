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
  AlephREmFont,
  GlobalFontSizeManager;

type
  TAlephLabel = class(TLabel, IRemFontSize, IGlobalFontSizeAware)
  private
    FRemMargins: TREmMargins;
    FRemFontSize: TREmFontSize;
    FGlobalFontSizeManager: TGlobalFontSizeManager;
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    function GetTextRem: TREmFontSize;
    procedure SetTextRem(const Value: TREmFontSize);
    procedure SetGlobalFontSizeManager(const Value: TGlobalFontSizeManager);
  protected
    procedure ResizeFont(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateFontSize;
  published
    property MarginsREm: TREmMargins read GetRemMargins write SetRemMargins;
    property TextRem: TREmFontSize  read GetTextRem write SetTextRem;
    property GlobalFontSizeManager: TGlobalFontSizeManager read FGlobalFontSizeManager write SetGlobalFontSizeManager;
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
  FRemFontSize := TREmFontSize.Create(12);
  FRemFontSize.OnChange := ResizeFont;
end;

destructor TAlephLabel.Destroy;
begin
  if Assigned(FGlobalFontSizeManager) then
    FGlobalFontSizeManager.UnregisterComponent(Self);
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

procedure TAlephLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FGlobalFontSizeManager) then
    FGlobalFontSizeManager := nil;
end;

procedure TAlephLabel.ResizeFont(Sender: TObject);
begin
   if Assigned(FRemFontSize) then
      self.TextSettings.Font.Size := FRemFontSize.ToPixels;
end;


procedure TAlephLabel.SetGlobalFontSizeManager(const Value: TGlobalFontSizeManager);
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
      FreeNotification(FGlobalFontSizeManager);
      UpdateFontSize;
    end;
  end;
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

procedure TAlephLabel.UpdateFontSize;
begin
  if Assigned(FGlobalFontSizeManager) and Assigned(FRemFontSize) then
  begin
    FRemFontSize.Assign(FGlobalFontSizeManager.RemFontSize);
    ResizeFont(Self);
  end;
end;

end.
