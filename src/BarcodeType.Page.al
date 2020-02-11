page 80285 "TTTEBS-BCBarcodeTypeList"
{

    PageType = List;
    SourceTable = "TTTEBS-BCBarcodeType";
    Caption = 'Barcode Type List';
    ApplicationArea = All;
    // UsageCategory = Administration;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(URL; URL)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
