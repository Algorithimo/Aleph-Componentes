unit AlephControl;

interface

uses
  System.Classes, FMX.Controls, MainAleph, RemControlInterface;

type
  TAlephControl = class(TControl, IREmControl)
  private
    FRemMargins: TREmMargins;
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateRemMargins;
    property RemMargins: TREmMargins read GetRemMargins write SetRemMargins;
  end;

implementation

constructor TAlephControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRemMargins := TREmMargins.Create(16, Self);  // Exemplo de tamanho base
end;

destructor TAlephControl.Destroy;
begin
  FRemMargins.Free;
  inherited Destroy;
end;

procedure TAlephControl.Loaded;
begin
  inherited;
  UpdateRemMargins;
end;

function TAlephControl.GetRemMargins: TREmMargins;
begin
  Result := FRemMargins;
end;

procedure TAlephControl.SetRemMargins(const Value: TREmMargins);
begin
  FRemMargins.Assign(Value);
  UpdateRemMargins;
end;

procedure TAlephControl.UpdateRemMargins;
begin
  FRemMargins.ApplyToControl;
end;

end.

