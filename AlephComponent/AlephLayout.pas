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
  AlephTipos;

type
  TAlephLayout = class(TLayout)
  private
    FAlephTipo: TAlephTipo;
    procedure AdjustSize(Sender: TObject);
    procedure FormResizeHandler(Sender: TObject);
    class procedure GlobalFormResizeHandler(Sender: TObject); static;
    function GetTipo: TAlephTipo;
    procedure SetTipo(const Value: TAlephTipo);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Tipo: TAlephTipo read GetTipo write SetTipo;


  end;

procedure Register;

implementation

procedure Register;
begin
  // Registrar os componentes na paleta de componentes da IDE
  RegisterComponents('Aleph', [TAlephLayout]);
//  RegisterPropertiesInCategory('Layout', TAlephLayout, ['PWidth', 'PHeight']);
end;

var
  AlephLayouts: TList<TAlephLayout>;

procedure RegisterAlephLayout(ALayout: TAlephLayout);
begin
  if not Assigned(AlephLayouts) then
    AlephLayouts := TList<TAlephLayout>.Create;
  AlephLayouts.Add(ALayout);
end;

procedure UnregisterAlephLayout(ALayout: TAlephLayout);
begin
  if Assigned(AlephLayouts) then
    AlephLayouts.Remove(ALayout);
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
      AlephLayouts[i].AdjustSize(sender);
    end;
  end;
end;

procedure TAlephLayout.Resize;
begin
  inherited;
  FAlephTipo.Resize;
end;

procedure TAlephLayout.SetTipo(const Value: TAlephTipo);
begin
  FAlephTipo.Assign(Value);
  AdjustSize(nil);
end;

{ TAlephLayout }

procedure TAlephLayout.AdjustSize(Sender: TObject);
begin
    FAlephTipo.AdjustSize;
end;

constructor TAlephLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
   FAlephTipo := TAlephTipo.Create(self);
  if AOwner is TForm then
  begin
    TForm(AOwner).OnResize := FormResizeHandler;
    // Registra o evento de redimensionamento global
  end;
  RegisterAlephLayout(Self); // Registra o componente na lista
end;

destructor TAlephLayout.Destroy;
begin
  FreeAndNil(AlephLayouts);
  FreeAndNil(FAlephTipo);
  UnregisterAlephLayout(Self);
  inherited Destroy;
end;

procedure TAlephLayout.FormResizeHandler(Sender: TObject);
begin
  GlobalFormResizeHandler(Sender);

end;


end.
