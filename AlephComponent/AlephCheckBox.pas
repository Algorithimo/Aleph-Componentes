unit AlephCheckBox;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Math,
  FMX.Types,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Forms,
  System.Generics.Collections,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Graphics,
  FMX.TextLayout,
  AlephRem,
  AlephTipos,
  AlephREmFont,
  GlobalFontSizeManager,
  ResizeManager;

type
  TAlephCheckBox = class( TCheckBox, IRemFontSize, IGlobalFontSizeAware,
    IFontSizeAdjustable, IResizable, ITextSettings )
    private
      FAlephTipo : TAlephTipo;
      FRemMargins : TREmMargins;
      FRemFontSize : TREmFontSize;
      FGlobalFontSizeManager : TGlobalFontSizeManager;
      FOldOnResize : TNotifyEvent;
      FAutoHeight : Boolean;
      FInAutoHeight : Boolean;

      function GetTipo : TAlephTipo;
      procedure SetTipo( const Value : TAlephTipo );

      function GetRemMargins : TREmMargins;
      procedure SetRemMargins( const Value : TREmMargins );
      function GetTextRem : TREmFontSize;
      procedure SetTextRem( const Value : TREmFontSize );
      procedure SetGlobalFontSizeManager( const Value
        : TGlobalFontSizeManager );
      procedure AdjustHeight( Sender : TObject );
      procedure SetAutoHeight( const Value : Boolean );
      procedure SetPadding( const Value : TBounds );
      procedure DoFormResize( Sender : TObject );
    protected
      procedure ResizeComponent( Sender : TObject );
      procedure CalculatePercentage( Sender : TObject );
      procedure ResizeFont( Sender : TObject );
      procedure Resize; override;
      procedure Notification(
        AComponent : TComponent;
        Operation  : TOperation ); override;
      procedure Loaded; override;
    public
      constructor Create( AOwner : TComponent ); override;
      destructor Destroy; override;
      procedure UpdateFontSize( NewBaseSize : Integer );
    published
      property AlephPercentage : TAlephTipo
        read GetTipo
        write SetTipo;
      property AutoHeight : Boolean
        read FAutoHeight
        write SetAutoHeight;
      property MarginsRem : TREmMargins
        read GetRemMargins
        write SetRemMargins;
      property TextRem : TREmFontSize
        read GetTextRem
        write SetTextRem;
      property GlobalFontSizeManager : TGlobalFontSizeManager
        read FGlobalFontSizeManager
        write SetGlobalFontSizeManager;
  end;

procedure Register;

implementation

procedure Register;
  begin
    RegisterComponents( 'Aleph', [ TAlephCheckBox ] );
  end;

{ TAlephCheckBox }

procedure TAlephCheckBox.ResizeComponent( Sender : TObject );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.ResizeComponent( Sender );
  end;

procedure TAlephCheckBox.AdjustHeight;
  var
    NewHeight : Single;
  begin
    if not FAutoHeight
    then
      Exit;
    NewHeight := TextSettings.Font.Size + Padding.Top + Padding.Bottom;
    if ( csDesigning in ComponentState ) or not ( csLoading in ComponentState )
    then
    begin
      BeginUpdate;
      try
        Height := Round( NewHeight );
      finally
        EndUpdate;
      end;
    end;
  end;

procedure TAlephCheckBox.CalculatePercentage( Sender : TObject );
  begin
    if Assigned( FGlobalFontSizeManager )
    then
      FGlobalFontSizeManager.CalculatePercentage( Sender );
  end;

constructor TAlephCheckBox.Create( AOwner : TComponent );
  begin
    inherited Create( AOwner );
    FAutoHeight := False; // Inicializa o AutoHeight como habilitado
    FInAutoHeight := False;
    FAlephTipo := TAlephTipo.Create( Self );
    FRemMargins := TREmMargins.Create( Self );
    FRemFontSize := TREmFontSize.Create( Self );
    GlobalResizeManager.RegisterComponent( Self );
    GlobalResizeManager.RegisterFontSizeComponent( Self );
    if AOwner is TForm
    then
    begin
      // Guarda o handler original do form
      FOldOnResize := TForm( AOwner ).OnResize;
      // Define o novo handler
      TForm( AOwner ).OnResize := DoFormResize;
    end;
  end;

destructor TAlephCheckBox.Destroy;
  begin
    if Assigned( FGlobalFontSizeManager )
    then
      FGlobalFontSizeManager.UnregisterComponent( Self );
    GlobalResizeManager.UnregisterComponent( Self );
    GlobalResizeManager.UnregisterFontSizeComponent( Self );
    FreeAndNil( FRemMargins );
    FreeAndNil( FRemFontSize );
    FreeAndNil( FAlephTipo );
    inherited;
  end;

procedure TAlephCheckBox.DoFormResize( Sender : TObject );
  begin
    if Assigned( FOldOnResize )
    then
      FOldOnResize( Sender );
    GlobalResizeManager.FormResizeHandler( Sender );
  end;

procedure TAlephCheckBox.SetPadding( const Value : TBounds );
  begin
    inherited Padding := Value;
    if FAutoHeight
    then
      AdjustHeight( nil );
  end;

function TAlephCheckBox.GetRemMargins : TREmMargins;
  begin
    Result := FRemMargins;
  end;

function TAlephCheckBox.GetTextRem : TREmFontSize;
  begin
    Result := FRemFontSize;
  end;

function TAlephCheckBox.GetTipo : TAlephTipo;
  begin
    Result := FAlephTipo;
  end;

procedure TAlephCheckBox.Loaded;
  begin
    inherited;
    if FAutoHeight
    then
      AdjustHeight( nil );
  end;

procedure TAlephCheckBox.Resize;
  begin
    inherited;
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Resize;
  end;

procedure TAlephCheckBox.ResizeFont( Sender : TObject );
  begin
    if Assigned( FRemFontSize )
    then
      TextSettings.Font.Size := FRemFontSize.ToPixels;
    if FAutoHeight
    then
      AdjustHeight( nil );
  end;

procedure TAlephCheckBox.SetRemMargins( const Value : TREmMargins );
  begin
    if Assigned( FRemMargins )
    then
      FRemMargins.Assign( Value );
  end;

procedure TAlephCheckBox.SetTextRem( const Value : TREmFontSize );
  begin
    if Assigned( FRemFontSize )
    then
      FRemFontSize.Assign( Value );
  end;

procedure TAlephCheckBox.SetTipo( const Value : TAlephTipo );
  begin
    if Assigned( FAlephTipo )
    then
      FAlephTipo.Assign( Value );
    ResizeComponent( nil );
  end;

procedure TAlephCheckBox.SetAutoHeight( const Value : Boolean );
  begin
    FAutoHeight := Value;
  end;

procedure TAlephCheckBox.SetGlobalFontSizeManager( const Value
  : TGlobalFontSizeManager );
  begin
    if FGlobalFontSizeManager <> Value
    then
    begin
      if Assigned( FGlobalFontSizeManager )
      then
      begin
        FGlobalFontSizeManager.UnregisterComponent( Self );
        RemoveFreeNotification( FGlobalFontSizeManager );
      end;
      FGlobalFontSizeManager := Value;
      if Assigned( FGlobalFontSizeManager )
      then
      begin
        FGlobalFontSizeManager.RegisterComponent( Self );
        FGlobalFontSizeManager.FreeNotification( Self );
        UpdateFontSize( FGlobalFontSizeManager.BaseSize );
      end;
    end;
  end;

procedure TAlephCheckBox.UpdateFontSize( NewBaseSize : Integer );
  begin
    if Assigned( FRemFontSize )
    then
    begin
      FRemFontSize.FontSize := NewBaseSize;
      ResizeFont( Self );
    end;
    if Assigned( FRemMargins )
    then
    begin
      FRemMargins.AMarginBase.FontBase := NewBaseSize;
      ResizeFont( Self );
    end;
  end;

procedure TAlephCheckBox.Notification(
  AComponent : TComponent;
  Operation  : TOperation );
  begin
    inherited;
    if ( Operation = opRemove ) and ( AComponent = FGlobalFontSizeManager )
    then
    begin
      FGlobalFontSizeManager := nil;
    end;
  end;

end.
