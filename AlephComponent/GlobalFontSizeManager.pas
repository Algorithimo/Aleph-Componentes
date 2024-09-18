unit GlobalFontSizeManager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Math,
  FMX.Forms, FMX.Controls, AlephRem, AlephREmFont, System.IOUtils, FMX.Types, Winapi.Windows;

type


  IGlobalFontSizeAware = interface
    ['{E3CF647C-7D56-446A-8089-F641C8F0106B}']
    procedure UpdateFontSize(NewBaseSize: Integer);
  end;

  TGlobalFontSizeManager = class(TComponent)
   procedure DebugLog(const Msg: string);
  private
    TextWriter: TTextWriter;

    FBaseSize: Integer;
    FMinFontSize: Integer;
    FFontPercentage: Single;
    FComponents: TList<IGlobalFontSizeAware>;

    procedure SetBaseSize(const Value: Integer);
    procedure SetFontPercentage(const Value: Single);
    procedure SetMinFontSize(const Value: Integer);
    procedure UpdateAllComponents;
    procedure CalculateAndUpdateFontSize;
    function GetParentForm: TForm;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterComponent(AComponent: IGlobalFontSizeAware);
    procedure UnregisterComponent(AComponent: IGlobalFontSizeAware);


  published
    property BaseSize: Integer read FBaseSize write SetBaseSize;
    property FontPercentage: Single read FFontPercentage write SetFontPercentage;
    property MinFontSize: Integer read FMinFontSize write SetMinFontSize;
  end;

implementation

procedure TGlobalFontSizeManager.DebugLog(const Msg: string);
begin
  OutputDebugString(PChar(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ' + Msg));
end;

{ TGlobalFontSizeManager }




constructor TGlobalFontSizeManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBaseSize := 12;  // Valor padr�o inicial
  FFontPercentage := 1.0;  // Percentual padr�o
  FMinFontSize := 10;  // Tamanho m�nimo padr�o
  FComponents := TList<IGlobalFontSizeAware>.Create;

  DebugLog('TGlobalFontSizeManager criado');
end;

destructor TGlobalFontSizeManager.Destroy;
begin
  FComponents.Free;
  inherited;
end;

procedure TGlobalFontSizeManager.Loaded;
begin
  inherited;
  CalculateAndUpdateFontSize;
end;

function TGlobalFontSizeManager.GetParentForm: TForm;
begin
  Result := nil;
  if Assigned(Owner) and (Owner is TControl) then
  begin
    if TControl(Owner).Parent is TForm then
      Result := TForm(TControl(Owner).Parent)
    else if Owner is TForm then
      Result := TForm(Owner);
  end;
  if Assigned(Result) then
    DebugLog('ParentForm encontrado')
  else
    DebugLog('ParentForm n�o encontrado');
end;

procedure TGlobalFontSizeManager.SetBaseSize(const Value: Integer);
begin
  if FBaseSize <> Value then
  begin
    FBaseSize := Value;
    DebugLog('BaseSize atualizado para: ' + IntToStr(Value));
    UpdateAllComponents;
  end;
end;

procedure TGlobalFontSizeManager.SetFontPercentage(const Value: Single);
begin
  if FFontPercentage <> Value then
  begin
    FFontPercentage := Value;
    DebugLog('FontPercentage alterado para: ' + FloatToStr(Value));
    CalculateAndUpdateFontSize;
  end;
end;

procedure TGlobalFontSizeManager.SetMinFontSize(const Value: Integer);
begin
  if FMinFontSize <> Value then
  begin
    FMinFontSize := Value;
    CalculateAndUpdateFontSize;
  end;
end;

procedure TGlobalFontSizeManager.RegisterComponent(AComponent: IGlobalFontSizeAware);
begin
  if not FComponents.Contains(AComponent) then
  begin
    FComponents.Add(AComponent);
    AComponent.UpdateFontSize(FBaseSize);
  end;
end;

procedure TGlobalFontSizeManager.UnregisterComponent(AComponent: IGlobalFontSizeAware);
begin
  FComponents.Remove(AComponent);
end;

procedure TGlobalFontSizeManager.UpdateAllComponents;
var
  Component: IGlobalFontSizeAware;
begin
  for Component in FComponents do
    Component.UpdateFontSize(FBaseSize);
end;

procedure TGlobalFontSizeManager.CalculateAndUpdateFontSize;
var
  NewBaseSize: Integer;
  ParentForm: TForm;
begin
  ParentForm := GetParentForm;
  if Assigned(ParentForm) then
  begin
    NewBaseSize := Max(Round(ParentForm.ClientWidth * FFontPercentage / 100), FMinFontSize);
     DebugLog('Novo BaseSize calculado: ' + IntToStr(NewBaseSize));
    SetBaseSize(NewBaseSize);
  end
  else
  begin
    DebugLog('ParentForm n�o encontrado');
  end;
end;

end.
