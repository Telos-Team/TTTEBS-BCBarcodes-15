table 80283 "TTT-EBS-BCBarcodeType"
{
    Caption = 'Barcode Types';
    DataClassification = CustomerContent;
    LookupPageId = "TTT-EBS-BCBarcodeTypeList";
    DrillDownPageId = "TTT-EBS-BCBarcodeTypeList";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(9; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; URL; Text[250])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", URL)
        {
        }
    }
}
