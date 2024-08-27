unit RemControlInterface;

interface

uses
  System.Classes, MainAleph;

type
  IREmControl = interface
    ['{D9A1F5E3-5B4C-4E6F-8F2C-3A1D2B4C5E6F}']
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    procedure UpdateRemMargins;
    property RemMargins: TREmMargins read GetRemMargins write SetRemMargins;
  end;

implementation

end.
