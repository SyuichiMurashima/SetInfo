Param($Path)

##########################################################
# ヒア文字列を配列にする
##########################################################
function HereString2StringArray( $HereString ){
    $Temp = $HereString.Replace("`r","")
    [string[]]$StringArray = $Temp.Split("`n")
    return $StringArray
}

##########################################################
# ドメインユーザーアカウントのメモを設定する
##########################################################
function SetInfo4ADUser( [string]$SamAccountName, [string[]]$Infos ){

    # セットする値の数
    $Max = $Infos.Count

    if($Max -eq 0 ){
        return $false
    }
    else{
        $InfoString = ""
        for($i = 0 ; $i -lt $Max; $i++){
            # 値セット
            $InfoString += $Infos[$i]

            # 末尾以外は改行を入れる
            if( $i -lt $Max -1 ){
                $InfoString += "`r`n"
            }
        }
    }

    # ユーザー情報取得
    $User = Get-ADUser -Filter { SamAccountName -eq $SamAccountName } -Properties info
    if( $User -eq $null ){
        # そんなユーザーはいない
        return $false
    }

    # 追加
    if( $User.info -eq $null ){
        $User | Set-ADUser -Add @{ info = $InfoString }
    }
    # 更新
    else{
        $User | Set-ADUser -Replace @{ info = $InfoString }
    }

    return $true
}

#######################################################
# 管理権限で実行されているか確認
#######################################################
function HaveIAdministrativePrivileges(){
    $WindowsPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $IsRoleStatus = $WindowsPrincipal.IsInRole("Administrators")
    return $IsRoleStatus
}

##########################################################
# main
##########################################################
$Result =HaveIAdministrativePrivileges 

if( -not $Result ){
	echo "[FAIL] 管理権限で実行してください"
	exit
}

if( $Path -eq $null ){
	echo "Usage..."
	echo "    .\SetInfo.ps1 CSVファイルフルパス"
	exit
}

if( -not (Test-Path $Path)){
	echo "[FAIL] $Path がありません"
	exit
}

# CSV 読み込み
$CSV = Import-Csv $Path

# 登録
foreach( $Data in $CSV ){

	# 登録データ
	$SamAccountName = $Data.UserName
	$SerialData = $Data.SerialNumber
	$SerialNumbers = HereString2StringArray $SerialData

	$Result = SetInfo4ADUser $SamAccountName $SerialNumbers
	if( $Result -eq $true ){
		echo "[INFO] OK : $SamAccountName"
	}
	else{
		echo "[ERROR] 〇●〇● NG : $SamAccountName"
	}
}
