unit InterfaceBuilder_Impl;

interface

uses
  System.Classes, LayoutGof;

type
  IInterfaceBuilder = interface
    ['{40F378C5-8D92-4410-916C-504D623E456C}']
    function GetRemMargins: TREmMargins;
    procedure SetRemMargins(const Value: TREmMargins);
    procedure UpdateRemMargins;
    property RemMargins: TREmMargins read GetRemMargins write SetRemMargins;
  end;

implementation

end.
