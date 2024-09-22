unit AlephRem;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TFontBase = class( TPersistent )
    private
      FOnChange : TNotifyEvent;
      procedure SetFontBase( const Value : Integer );
    public
      FAlephFonteBase : Integer;
      constructor Create( ABaseSize : Integer );
      destructor Destroy; override;
    published
      property FontBase : Integer
        read FAlephFonteBase
        write SetFontBase;
      property OnChange : TNotifyEvent
        read FOnChange
        write FOnChange;
  end;

  TREmSize = class( TPersistent )
    private
      FFontBase : TFontBase;
      FREM : Single;
      FOnChange : TNotifyEvent;
      procedure SetREM( const Value : Single );
      procedure FontBaseChanged( Sender : TObject );
    public
      constructor Create( AFontBase : TFontBase );
      destructor Destroy; override;
      function ToPixels : Integer;
    published
      property REM : Single
        read FREM
        write SetREM;
      property OnChange : TNotifyEvent
        read FOnChange
        write FOnChange;
  end;

implementation

{ TREmSize }

constructor TREmSize.Create( AFontBase : TFontBase );
  begin
    FFontBase := AFontBase;
    FREM := 0; // Valor padr�o de 0 rem

    // Inscreve-se para ser notificado quando a FontBase mudar
    FFontBase.OnChange := FontBaseChanged;
  end;

destructor TREmSize.Destroy;
  begin
    FFontBase.OnChange := nil;
    inherited;
  end;

procedure TREmSize.FontBaseChanged( Sender : TObject );
  begin
    // Notifica qualquer mudan�a relevante
    if Assigned( FOnChange )
    then
      FOnChange( Self );
  end;

procedure TREmSize.SetREM( const Value : Single );
  begin
    if FREM <> Value
    then
    begin
      FREM := Value;
      if Assigned( FOnChange )
      then
        FOnChange( Self );
    end;
  end;

function TREmSize.ToPixels : Integer;
  begin
    Result := Round( FREM * FFontBase.FAlephFonteBase );
  end;

{ TFontBase }

constructor TFontBase.Create( ABaseSize : Integer );
  begin
    FAlephFonteBase := ABaseSize;
  end;

destructor TFontBase.Destroy;
  begin
    inherited;
  end;

procedure TFontBase.SetFontBase( const Value : Integer );
  begin
    if FAlephFonteBase <> Value
    then
    begin
      FAlephFonteBase := Value;
      if Assigned( FOnChange )
      then
        FOnChange( Self );
    end;
  end;

end.
