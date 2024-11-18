unit AlephSkSvg;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Skia,
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
  TAlephSkSvg = class( TSkSvg, IResizable )
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
    RegisterComponents( 'Aleph', [ TAlephSkSvg ] );
  end;

function TAlephSkSvg.GetRemMargins : TREmMargins;
  begin
    Result := FRemMargins;
  end;

function TAlephSkSvg.GetTipo : TAlephTipo;
  begin
    Result := FAlephTipo;
  end;

procedure TAlephSkSvg.Resize;
  begin
    inherited;
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Resize;
  end;

procedure TAlephSkSvg.SetRemMargins( const Value : TREmMargins );
  begin
    if Assigned( FRemMargins )
    then
      FRemMargins.Assign( Value );
  end;

procedure TAlephSkSvg.SetTipo( const Value : TAlephTipo );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Assign( Value );
    ResizeComponent( nil );
  end;

procedure TAlephSkSvg.ResizeComponent( Sender : TObject );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.ResizeComponent( Sender );
  end;

constructor TAlephSkSvg.Create( AOwner : TComponent );
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

destructor TAlephSkSvg.Destroy;
  begin
    GlobalResizeManager.UnregisterComponent( Self );
    FreeAndNil( FRemMargins );
    FreeAndNil( FAlephTipo );
    inherited Destroy;
  end;

end.
