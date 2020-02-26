page 80285 "TTT-EBS-BCBarcodeTypeList"
{
    PageType = List;
    SourceTable = "TTT-EBS-BCBarcodeType";
    Caption = 'Barcode Type List';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Barcode" Code (Primary Key).';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Barcode" description.';
                }
                field(URL; URL)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the URL used, to generate the Barcode - See: https://barcode.tec-it.com/en';
                }
            }
        }
    }

}
