unit AlephLayout1;

interface

uses
  System.Classes, FMX.Layouts,MainAleph, RemControlInterface, AlephControl;

type
  TAlephLayout = class(TLayout, IREmControl)
  private
    FRemMargins: TREmMargins;
    function GetRemMargins: TREmMargins;  // Adicionei esta linha
    procedure SetRemMargins(const Value: TREmMargins);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateRemMargins;
  published
    property RemMargins: TREmMargins read GetRemMargins write SetRemMargins;
    // Outras propriedades do TLayout
  end;

 procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Aleph', [TAlephLayout]);
end;

{ TAlephLayout }

constructor TAlephLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRemMargins := TREmMargins.Create(16, Self);
end;

destructor TAlephLayout.Destroy;
begin
  FRemMargins.Free;
  inherited Destroy;
end;

procedure TAlephLayout.Loaded;
begin
  inherited;
  UpdateRemMargins;
end;

function TAlephLayout.GetRemMargins: TREmMargins;  // Implementa��o do m�todo
begin
  Result := FRemMargins;
end;

procedure TAlephLayout.SetRemMargins(const Value: TREmMargins);
begin
  FRemMargins.Assign(Value);
  UpdateRemMargins;
end;

procedure TAlephLayout.UpdateRemMargins;
begin
  FRemMargins.ApplyToControl;
end;

end.

