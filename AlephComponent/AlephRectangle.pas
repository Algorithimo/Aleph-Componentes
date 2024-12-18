unit AlephRectangle;

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
  TAlephRectangle = class( TRectangle, IResizable, IResizeCorner )
    private
      FAlephTipo : TAlephTipo;
      FRemMargins : TREmMargins;
      FOldOnResize : TNotifyEvent;
      FPRadius : double;
      FSquareMode : Boolean;
      function GetTipo : TAlephTipo;
      procedure SetTipo( const Value : TAlephTipo );
      function GetRemMargins : TREmMargins;
      procedure SetRemMargins( const Value : TREmMargins );
      procedure SetPRadius( const Value : double );
      procedure ResizeCorner( Sender : TObject );
      procedure SetSquareMode( const Value : Boolean );
      procedure ResizeSquareMode( Sender : TObject );
      procedure DoFormResize( Sender : TObject );
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
      property PRadius : double
        read FPRadius
        write SetPRadius;
      Property SquareMode : Boolean
        Read FSquareMode
        write SetSquareMode;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register;
  begin
    // Registrar os componentes na paleta de componentes da IDE
    RegisterComponents( 'Aleph', [ TAlephRectangle ] );
  end;

function TAlephRectangle.GetRemMargins : TREmMargins;
  begin
    Result := FRemMargins;
  end;

function TAlephRectangle.GetTipo : TAlephTipo;
  begin
    Result := FAlephTipo;
  end;

procedure TAlephRectangle.Resize;
  begin
    inherited;
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Resize;
  end;

procedure TAlephRectangle.SetPRadius( const Value : double );
  begin
    if FPRadius <> Value
    then
      FPRadius := Value;
    ResizeCorner( nil );
  end;

procedure TAlephRectangle.SetRemMargins( const Value : TREmMargins );
  begin
    if Assigned( FRemMargins )
    then
      FRemMargins.Assign( Value );
  end;

procedure TAlephRectangle.SetSquareMode( const Value : Boolean );
  begin
    if FSquareMode <> Value
    then
    begin
      FSquareMode := Value;
      if FSquareMode
      then
        ResizeSquareMode( nil );
    end;
  end;

procedure TAlephRectangle.SetTipo( const Value : TAlephTipo );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Assign( Value );
    ResizeComponent( nil );
  end;

procedure TAlephRectangle.ResizeComponent( Sender : TObject );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.ResizeComponent( Sender );
  end;

procedure TAlephRectangle.ResizeCorner( Sender : TObject );
  var
    PercentageHeight : double;
  begin

    PercentageHeight := RoundTo( Width * FPRadius / 100, - 1 );
    if ( csDesigning in ComponentState ) or not ( csLoading in ComponentState )
    then
    begin
      BeginUpdate;
      try
        Self.XRadius := Round( PercentageHeight );
        Self.YRadius := Round( PercentageHeight );
      finally
        EndUpdate;
      end;
    end;
  end;

procedure TAlephRectangle.ResizeSquareMode( Sender : TObject );
  begin
    if not FSquareMode
    then
      Exit;

    if ( csDesigning in ComponentState ) or not ( csLoading in ComponentState )
    then
    begin
      BeginUpdate;
      try
        if ( Align = TAlignLayout.Left ) or ( Align = TAlignLayout.Right )
        then
          Self.Width := Self.Height;
        if ( Align = TAlignLayout.Top ) or ( Align = TAlignLayout.Bottom )
        then
          Self.Height := Self.Width;
      finally
        EndUpdate;
      end;
    end;
  end;

constructor TAlephRectangle.Create( AOwner : TComponent );
  begin
    inherited Create( AOwner );
    FAlephTipo := TAlephTipo.Create( Self );
    FRemMargins := TREmMargins.Create( Self );
    GlobalResizeManager.RegisterComponent( Self );
    if AOwner is TForm
    then
    begin
      // Guarda o handler original do form
      FOldOnResize := TForm( AOwner ).OnResize;
      // Define o novo handler
      TForm( AOwner ).OnResize := DoFormResize;
    end;
  end;

destructor TAlephRectangle.Destroy;
  begin
    GlobalResizeManager.UnregisterComponent( Self );
    FreeAndNil( FRemMargins );
    FreeAndNil( FAlephTipo );
    inherited Destroy;
  end;

procedure TAlephRectangle.DoFormResize( Sender : TObject );
  begin
    if Assigned( FOldOnResize )
    then
      FOldOnResize( Sender );
    GlobalResizeManager.FormResizeHandler( Sender );
  end;

end.
