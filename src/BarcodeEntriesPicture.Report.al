report 80282 "TTTEBS-BCBarcodeEntriesPicture"
{
    UsageCategory = Lists;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = '.\src\BarcodeEntriesPicture.Report.rdl';
    Caption = 'Barcode Entries Picture';
    PreviewMode = Normal;

    dataset
    {
        dataitem(TTTEBSBCBarcodeEntries; "TTTEBS-BCBarcodeEntries")
        {
            column(BarcodeType; "Barcode Type")
            {
            }
            column(BarcodeValue; "Barcode Value")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(LinkSID; "Link SID")
            {
            }
            column(WithText; "With Text")
            {
            }
            column(Barcode; Barcode)
            {
            }
            column(Height; Height)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(Type; Type)
            {
            }
            column(Width; Width)
            {
            }
            trigger OnAfterGetRecord()
            begin
                CalcFields(Barcode);
            end;
        }
    }
}
