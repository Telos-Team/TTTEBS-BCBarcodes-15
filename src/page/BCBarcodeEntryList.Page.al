page 80282 "TTT-EBS-BCBarcodeEntryList"
{
    PageType = List;
    SourceTable = "TTT-EBS-BCBarcodeEntry";
    Caption = 'Barcode Entry List';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(LinkSystemID; LinkSystemID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the System ID from the linked table Barcode (Part of primary key).';
                }
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies several Barcode Entries per Barcode (Part of primary key).';
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a type - Optional.';
                }
                field(BarcodeType; BarcodeType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies wich Barcode Type used (EAN13, Code128, QR, and so on.).';
                }
                field(Height; Height)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Hight of the Barcode picture - Optional.';
                }
                field(Width; Width)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Width of the Barcode picture - Optional.';
                }
                field(WithText; WithText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the Barcode picture is With Text - Optional.';
                }
                field(BarcodeValue; BarcodeValue)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Barcode.';
                }
                field(BarcodeHasValue; barcode.HasValue())
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Barcode Exists';
                    ToolTip = 'Specifies if the Barcode Exists.';
                }
                field(SystemID; Format(SystemId))
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the System ID of the current record.';
                    Caption = 'System ID';
                }
            }
            group(BarcodePicture)
            {
                ShowCaption = false;
                part(BarcodePicturePart; "TTT-EBS-BCBarcodePicture")
                {
                    ApplicationArea = all;
                    Editable = false;
                    SubPageLink = LinkSystemID = field(LinkSystemID), EntryNo = field(EntryNo);
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowBarcode)
            {
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Show Barcode';
                ApplicationArea = All;
                PromotedCategory = Process;
                Image = Picture;
                PromotedOnly = true;
                ToolTip = 'View the Barcode.';

                trigger OnAction()
                var
                    lr_BarcodeEntry: Record "TTT-EBS-BCBarcodeEntry";
                begin
                    lr_BarcodeEntry.SetRange(LinkSystemID, LinkSystemID);
                    lr_BarcodeEntry.SetRange(EntryNo, EntryNo);
                    report.Run(report::"TTT-EBS-BCBarcodeEntryPicture", true, true, lr_BarcodeEntry);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields(Barcode);
    end;
}
