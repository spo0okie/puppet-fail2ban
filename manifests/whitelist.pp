#вынес белый список в отдельный класс, т.к. больно он громоздкий. неудобно стало

class fail2ban::whitelist {
	
	$wl=[
	#добавляем локальные сети в белый список
	'127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16',
	
	#root
	'94.181.46.36',		#Ревякин Домашний

	#общие узлы ------
	'78.29.0.225',		#IS74 SIP trunk
	'213.170.92.166',	#sip.telphin.com
	'80.75.132.66',		#voip.mtt.ru
	'95.167.163.148 212.48.197.150',	#Rostelekom VPBX
	'188.234.136.49',	#ДомРу ВАТС
	'87.249.220.242',	#Z-Телеком SIP Транк
	'62.165.32.157',	#TTK chel sip trink

	#узлы ЯДС
	'176.96.80.135',	#Курганский офис
	'94.24.244.234',	#Челябинский офис
	'90.154.125.137',	#Москва - РТ
	'178.57.93.227',	#Москва - Бизтелеком
	'212.55.98.9',		#Усинск - РТ
	'95.188.145.222',	#Красноярск - РТ
	'83.69.6.192/28',	#196,197,198,199,200 - IS Leonenko Vasiliy (Salmuito)
	'178.218.1.149',	#Сатис - 16023 Лабангашор
	'178.218.2.215',	#Сатис - 16196 Куюмбинское
	'91.109.231.128',	#Телепорт 064096 Таймыр
	'91.109.227.129',	#Телепорт 212164 Шельф
	'91.109.230.40',	#Телепорт 120800 Требса-ОБП
	'31.10.12.105',		#Альтегро - Наульское м.р. (A83ZY652)
	'31.10.12.126',		#Альтегро - Требса м.р. (A83NN231)
	'31.10.12.99',		#Альтегро - Седтывис м.р. (A89YZ174)
	'217.21.107.12',	#altegrosky NAT

	#Узлы Азимут
	'87.249.213.70',	#azimut-chel-izet
	'62.165.38.74',		#azimut-chel-ttk
	'95.78.163.127',	#azimut-chel-ER-Telekom
	'78.108.201.218',	#azimut msk
	'95.167.177.66',	#azimut mhk

	# Узлы НПП ИКС
	'83.142.162.38',	#осн. аплинк Интерсвязь
	'95.78.181.53',		#рез. аплинк Домру
	'94.181.47.214',	#Микросхема
	'78.29.8.50',		#СпецТранс
	'78.29.9.32',		#Норд (ЖЕК)
	'78.29.13.69',		#Союз
	'78.29.44.61',		#ЖСС+
	'87.249.197.5',		#ЖРЭУ3
	
	# Узлы Алмаз Система
	'94.181.47.98',		#almaz_system
	'95.78.170.226',	#chsdm
	'87.249.215.16',	#chsdm
	'100.200.100.0/24',	#GKB-1 voip

	]
	
	ini_setting {'fail2ban_ignoreips':
		require	=> Package['fail2ban'],
		path	=> '/etc/fail2ban/jail.conf',
		ensure	=> present,
		section	=> 'DEFAULT',
		setting	=> 'ignoreip',
		value	=> join($wl,' '),
		notify	=> Service['fail2ban']
	}
}
