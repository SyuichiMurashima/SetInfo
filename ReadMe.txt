VPN 用の PC シリアル番号を AD に登録する

■ 使い方
	ドメコンで管理権限実行
		SetInfo.ps1 CSV ファイルフルパス


■ CSV フォーマット
	UserName
		ユーザーログオン名(@より前)
		(LDAP 属性名 : SamAccountName)

	SerialNumber
		wmic baseboard get SerialNumber で得られた値
		Alt + Enter で複数行書けば複数登録される

	これ以外の列は使用しないので、備考とか適当に作って OK


■ VPN 詳細情報
	VPN接続方法 - 103 システム基盤部 - Redmine
	https://bts.clayapp.jp/projects/system/wiki/VPN%E6%8E%A5%E7%B6%9A%E6%96%B9%E6%B3%95

