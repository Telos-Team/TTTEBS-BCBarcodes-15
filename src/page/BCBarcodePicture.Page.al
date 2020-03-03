page 80284 "TTT-EBS-BCBarcodePicture"
{

    PageType = ListPart;
    SourceTable = "TTT-EBS-BCBarcodeEntry";
    Caption = 'Barcode Picture';
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            field(Barcode; Barcode)
            {
                ApplicationArea = All;
                ToolTip = 'Shows the "Barcode" picture';
                ShowCaption = false;
            }
        }
    }
}
