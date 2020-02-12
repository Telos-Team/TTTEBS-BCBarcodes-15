report 80282 "TTT-EBS-BCBarcodeEntriesPictur"
{
    UsageCategory = Lists;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = '.\src\BCBarcodeEntriesPictur.Report.rdl';
    Caption = 'Barcode Entries Picture';
    PreviewMode = Normal;

    dataset
    {
        dataitem(TTTEBSBCBarcodeEntries; "TTT-EBS-BCBarcodeEntries")
        {
            column(BarcodeType; "BarcodeType")
            {
            }
            column(BarcodeValue; "BarcodeValue")
            {
            }
            column(EntryNo; "EntryNo.")
            {
            }
            column(LinkSID; "LinkSID")
            {
            }
            column(WithText; "WithText")
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
