codeunit 80281 "TTTEBS-BCBarcodeInstall"
{
    Subtype = Install;

    var
        v_ModuleInfo: ModuleInfo;
        v_AppInfoLoaded: Boolean;

    trigger OnInstallAppPerCompany()
    begin
        LoadAppInfo();
        if v_ModuleInfo.DataVersion() = Version.Create(0, 0, 0, 0) then
            HandleFreshInstall(CompanyName)
        else
            HandleReInstall(CompanyName);
    end;

    trigger OnInstallAppPerDatabase()
    begin
        LoadAppInfo();
        if v_ModuleInfo.DataVersion() = Version.Create(0, 0, 0, 0) then
            HandleFreshInstall('')
        else
            HandleReInstall('');
    end;

    local procedure LoadAppInfo()
    begin
        if v_AppInfoLoaded then
            exit;
        v_AppInfoLoaded := NavApp.GetCurrentModuleInfo(v_ModuleInfo);
    end;

    local procedure HandleFreshInstall(partxtCompanyName: Text)
    begin
        if partxtCompanyName <> '' then
            CreateSetup();
        // LogInstall('New', partxtCompanyName, Format(v_ModuleInfo.DataVersion), Format(v_ModuleInfo.AppVersion));
    end;

    local procedure HandleReInstall(partxtCompanyName: Text)
    begin
        if partxtCompanyName <> '' then
            CreateSetup();
        // LogInstall('Update', partxtCompanyName, Format(v_ModuleInfo.DataVersion), Format(v_ModuleInfo.AppVersion));
    end;

    local procedure CreateSetup()
    var
        lr_BarcodeType: Record "TTTEBS-BCBarcodeType";
        lv_CodeDim: array[20] of code[20];
        lv_URLDim: array[20] of text[250];
        I: Integer;
    begin
        with lr_BarcodeType do begin
            if get then
                exit;

            lv_CodeDim[1] := 'EAN13';
            lv_URLDim[1] := 'https://barcode.tec-it.com/barcode.ashx?data=%1&code=EAN13&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=jpg&rotation=0&color=%23000000&bgcolor=%23ffffff&qunit=Mm&quiet=0';
            lv_CodeDim[2] := 'CODE128';
            lv_URLDim[2] := 'https://barcode.tec-it.com/barcode.ashx?data=%1&code=Code128&dpi=96&dataseparator=';
            lv_CodeDim[3] := 'QR';
            lv_URLDim[3] := 'https://barcode.tec-it.com/barcode.ashx?data=%1&code=QRCode&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=Gif&rotation=0&color=%23000000&bgcolor=%23ffffff&qunit=Mm&quiet=0&eclevel=L';

            for I := 1 to 3 do begin
                if not get(lv_CodeDim[I]) then begin
                    Init();
                    code := lv_CodeDim[I];
                    URL := lv_URLDim[I];
                    insert();
                end;
            end;
        end;
    end;

    // local procedure LogInstall(partxtInstallType: Text; partxtCompanyName: Text; partxtFromVersion: Text; partxtToVersion: Text);
    // var
    //     locrecLog: Record MyInstallLog;
    // begin
    //     locrecLog.Init();
    //     locrecLog.InstallType := partxtInstallType;
    //     locrecLog.CompanyName := partxtCompanyName;
    //     locreclog.FromVersion := partxtFromVersion;
    //     locrecLog.ToVersion := partxtToVersion;
    //     locrecLog.UserID := UserId;
    //     if locrecLog.Insert(true) then;
    // end;

}