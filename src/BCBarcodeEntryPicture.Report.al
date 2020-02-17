report 80282 "TTT-EBS-BCBarcodeEntryPicture"
{
    UsageCategory = Lists;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = '.\src\BCBarcodeEntryPicture.Report.rdl';
    Caption = 'Barcode Entry Picture';
    PreviewMode = Normal;

    dataset
    {
        dataitem(TTTEBSBCBarcodeEntries; "TTT-EBS-BCBarcodeEntry")
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
