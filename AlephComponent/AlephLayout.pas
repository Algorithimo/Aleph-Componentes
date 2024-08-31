unit AlephLayout;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Layouts,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Forms,
  System.Generics.Collections,
  AlephRem,
  AlephTipos,
  ResizeManager;

type
  TAlephLayout = class(TLayout, IResizable)
  private
    FAlephTipo: TAlephTipo;
    FRemMargins : TREmMargins;
    FFontBase : TFontBase;
    procedure FormResizeHandler(Sender: TObject);
    class procedure GlobalFormResizeHandler(Sender: TObject); static;
    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    function GetFontBase: TFontBase;
    procedure setFontBase(const Value: TFontBase);
  protected
    procedure AdjustSize(Sender: TObject);
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlephPercentage: TAlephTipo read GetTipo write SetTipo;
    property REmMargins: TREmMargins  read GetRemMargins write SetRemMargins;
    property FontBase : TFontBase read GetFontBase write setFontBase;
  end;

procedure Register;



implementation

var
  AlephLayouts: TList<TAlephLayout>;

procedure Register;
begin
  // Registrar os componentes na paleta de componentes da IDE
  RegisterComponents('Aleph', [TAlephLayout]);

//  RegisterPropertyEditor(TypeInfo(Integer), TAlephLayout, 'PHeight', TAlephWidthHeightPropertyEditor);
//  RegisterPropertyEditor(TypeInfo(Integer), TAlephLayout, 'PWidth', TAlephWidthHeightPropertyEditor);
end;

procedure RegisterAlephLayout(ALayout: TAlephLayout);
begin
  if not Assigned(AlephLayouts) then
    AlephLayouts := TList<TAlephLayout>.Create;
  AlephLayouts.Add(ALayout);
end;

procedure UnregisterAlephLayout(ALayout: TAlephLayout);
begin
  if Assigned(AlephLayouts) then
  begin
    AlephLayouts.Remove(ALayout);
    if AlephLayouts.Count = 0 then
      FreeAndNil(AlephLayouts);
  end;
end;

function TAlephLayout.GetFontBase: TFontBase;
begin
  Result := FFontBase;
end;

function TAlephLayout.GetRemMargins: TREmMargins;
begin
  Result := FRemMargins;
end;

function TAlephLayout.GetTipo: TAlephTipo;
begin
  Result := FAlephTipo;
end;

class procedure TAlephLayout.GlobalFormResizeHandler(Sender: TObject);
var
  i: Integer;
begin
  if Assigned(AlephLayouts) then
  begin
    for i := 0 to AlephLayouts.Count - 1 do
    begin
      AlephLayouts[i].AdjustSize(Sender);
    end;
  end;
end;

procedure TAlephLayout.Resize;
begin
  inherited;
  if Assigned(FAlephTipo) then
    FAlephTipo.Resize;
end;

procedure TAlephLayout.setFontBase(const Value: TFontBase);
begin
  if Assigned(FFontBase) then
    FFontBase.Assign(Value);
end;

procedure TAlephLayout.SetRemMargins(const Value: TREmMargins);
begin
  if Assigned(FRemMargins) then
    FRemMargins.Assign(Value);
end;

procedure TAlephLayout.SetTipo(const Value: TAlephTipo);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.Assign(Value);
  AdjustSize(nil);
end;

procedure TAlephLayout.AdjustSize(Sender: TObject);
begin
  if Assigned(FAlephTipo) then
    FAlephTipo.AdjustSize(sender);
end;

constructor TAlephLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlephTipo := TAlephTipo.Create(Self);
  FFontBase := TFontBase.Create(12);
  FREmMargins := TREmMargins.Create(FFontBase, Self);
  GlobalResizeManager.RegisterComponent(Self);
  //RegisterAlephLayout(Self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := GlobalResizeManager.FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
   // Registra o componente na lista
end;

destructor TAlephLayout.Destroy;
begin
  GlobalResizeManager.UnregisterComponent(Self);
  //UnregisterAlephLayout(Self);
  FreeAndNil(FAlephTipo);
  inherited Destroy;

//  if Assigned(AlephLayouts) then
//  begin
//    UnregisterAlephLayout(Self);
//    if AlephLayouts.Count = 0 then
//      FreeAndNil(AlephLayouts); // Liberar a lista se estiver vazia
//  end;
//  FreeAndNil(FAlephTipo);
//  inherited Destroy;
end;

procedure TAlephLayout.FormResizeHandler(Sender: TObject);
begin
  GlobalFormResizeHandler(Sender);
end;

end.

