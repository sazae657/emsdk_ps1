# emsdk_set_envとだいたい同じ動きをさせる
function ｾｯﾄｴﾝﾌﾞー($置き場, $円舞) {
    $ｴﾝﾌﾞー内のﾊﾟｽ = $null;
    Get-Content $円舞 | % {
        # SET HOGE=HOGE
        $w = $_.Split(" ", 2)[1].Split("=",2)

        # PATHだけは配列にして別途追加
        if ($w[0] -eq "PATH") {
            $ｴﾝﾌﾞー内のﾊﾟｽ = $w[1].Split(";")
        }
        else {
            # Write-Host $w
            Set-Item -path "ENV:\$($w[0])" -value "$($w[1])"
        }
    }

    if ($null -eq $ｴﾝﾌﾞー内のﾊﾟｽ) {
        return;
    }

    $今のﾊﾟｽ = $env:Path.ToUpper()
    $ｴﾝﾌﾞー内のﾊﾟｽ | % {
        # $置き場 ｽﾀーﾄの物だけ追加
        if ($_.StartsWith($置き場)) {
            # 雑に重複ﾁｪｯｸ
            if (-Not $今のﾊﾟｽ.Contains($_.ToUpper())) {
                $env:Path += ";$($_)"
            }
        }
    }       
}

# emsdk.batとだいたい同じ動きをするbat
function ばっと($置き場, $引数) {
    Push-Location $置き場
    $古いﾊﾟｽ = $Env:Path

    $ぱいそん=(Get-ChildItem -Path (Join-Path $置き場 "python") -Filter python.exe -Recurse -ErrorAction SilentlyContinue -Force).FullName
    if ($null -eq $ぱいそん) {
        $ぱいそん = "python"
    }
    #Write-Host "Python: "$ぱいそん

    . $ぱいそん (Join-Path $置き場 "emsdk") $引数

    $Env:Path = $古いﾊﾟｽ

    $円舞 = Join-Path $置き場 "emsdk_set_env.bat"
    if (Test-Path $円舞) {
        ｾｯﾄｴﾝﾌﾞー $置き場 $円舞
        Remove-Item $円舞
    }
    Pop-Location
}

# Env:EMSDK_ROOTが設定されてたらそっちをSDKのﾙーﾄに
# そうでなければｽｸﾘﾌﾟﾄのﾊﾟｽのﾊﾟｽをﾙーﾄにする (emsdkの.bat準拠)

$ｻーﾀﾞーｶー=(Split-Path -Parent $MyInvocation.MyCommand.Path)
if (Test-Path "Env:EMSDK_ROOT") {
    $ｻーﾀﾞーｶー = $Env:EMSDK_ROOT
}

if (-Not (Test-Path (Join-Path $ｻーﾀﾞーｶー "emsdk"))) {
    throw "EMSDK_ROOTを設定するかemsdk-portable-64bitの直下に置いてちょ"
}

ばっと $ｻーﾀﾞーｶー $args

