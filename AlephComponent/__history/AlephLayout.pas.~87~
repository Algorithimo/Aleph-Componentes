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
  FMX.Forms,
  System.Generics.Collections,
  AlephRem,
  AlephTipos,
  ResizeManager;

type
  TAlephLayout = class( TLayout, IResizable )
    private
      FAlephTipo : TAlephTipo;
      FRemMargins : TREmMargins;
      function GetTipo : TAlephTipo;
      procedure SetTipo( const Value : TAlephTipo );
      function GetRemMargins : TREmMargins;
      procedure SetRemMargins( const Value : TREmMargins );
    protected
      procedure ResizeComponent( Sender : TObject );
      procedure Resize; override;
    public
      constructor Create( AOwner : TComponent ); override;
      destructor Destroy; override;
    published
      property AlephPercentage : TAlephTipo
        read GetTipo
        write SetTipo;
      property MarginsRem : TREmMargins
        read GetRemMargins
        write SetRemMargins;

  end;

procedure Register;

implementation

procedure Register;
  begin
    // Registrar os componentes na paleta de componentes da IDE
    RegisterComponents( 'Aleph', [ TAlephLayout ] );
  end;

function TAlephLayout.GetRemMargins : TREmMargins;
  begin
    Result := FRemMargins;
  end;

function TAlephLayout.GetTipo : TAlephTipo;
  begin
    Result := FAlephTipo;
  end;

procedure TAlephLayout.Resize;
  begin
    inherited;
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Resize;
  end;

procedure TAlephLayout.SetRemMargins( const Value : TREmMargins );
  begin
    if Assigned( FRemMargins )
    then
      FRemMargins.Assign( Value );
  end;

procedure TAlephLayout.SetTipo( const Value : TAlephTipo );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Assign( Value );
    ResizeComponent( nil );
  end;

procedure TAlephLayout.ResizeComponent( Sender : TObject );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.ResizeComponent( Sender );
  end;

constructor TAlephLayout.Create( AOwner : TComponent );
  begin
    inherited Create( AOwner );
    FAlephTipo := TAlephTipo.Create( Self );
    FRemMargins := TREmMargins.Create( Self );
    GlobalResizeManager.RegisterComponent( Self );
    if AOwner is TForm
    then
    begin
      TForm( AOwner ).OnResize := GlobalResizeManager.FormResizeHandler;
    end;
  end;

destructor TAlephLayout.Destroy;
  begin
    GlobalResizeManager.UnregisterComponent( Self );
    FreeAndNil( FRemMargins );
    FreeAndNil( FAlephTipo );
    inherited Destroy;
  end;

end.
