Config              = {}
Config.DrawDistance = 100.0
Config.MarkerSize                 = { x = 1.1, y = 1.1, z = 0.5 }
--[[
Zaimportuj pierw plik sql na swój serwer.

Aby skrypt zadziałał musisz dodać do tabeli users w bazie danych 2 kolumny:
`org` oraz `org_grade`      
org jako VARCHAR, 255 znaków, default value 'unemployed'
org_grade jako int 11 znaków, default value 0



Jak tworzysz organizację nie zapomnij utworzyć w: 
addon_account: society_nazwaorganizacji, society_nazwaorganizacji_black
addon_inventory: society_nazwaorganizacji
datastore: society_nazwaorganizacji
te same dane wpisujesz w Ustawieniach poniżej

W tabeli kaiser_orgs musisz dodać organizację w name wpisujesz nazwę, a w level wpisujesz 1


Aby kogoś zatrudnić jako admin: /setdualjobadmin ID NAZWAORGANIZACIJ GRADE ------- setdualjobadmin 2 mafia 4

Aby kogoś zatrudnić jako szef mając grade 4: /setdualjob ID nazwatwojejorganizacji GRADE
Aby kogoś zwolnić analognicznie /setdualjob ID unemployed 0






Kolory furek na:  https://wiki.rage.mp/index.php?title=Vehicle_Colors
Jak chcesz full ciemne szybki to glass = 1, bez przyciemniania glass = 0, glass = 2,3,4 to mniej ciemne
tunning = true daje tunning mechaniczny





W RAZIE JAKIEGOKOLWIEK PROBLEMU KONTAKT POPRZEZ TICKET NA JOHNSONSCRIPTS  https://discord.gg/3csjChbBd6
]]

Config.MaxLevel = 5
Config.StartLevel = 0
Config.Limits = {5,10,15,20,99}   -- limity osob po kolei od 1 levela do 5
Config.LevelPrices = {500000,1000000,1500000,2000000}   -- kasa za levelowanie po kolei na poczatek na 2 level potem na 3 etc.

Config.Ustawienia = {
	['santa'] = {
		society = 'society_santa',				
		szafka = 'santa',
		societyblack = 'society_santa_black',
		samochody = {
			 {name = 'stretch', label = 'Limuzyna', color = 111, glass = 1, tunning = true, count = 1},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 2,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['Camorra'] = {
		society = 'society_Camorra',				
		szafka = 'Camorra',
		societyblack = 'society_Camorra_black',
		samochody = {
			 {name = 'schafter4', label = 'Schafter', color = 12, glass = 1, tunning = true, count = 1},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 1,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['lcn'] = {
		society = 'society_lcn',				
		szafka = 'lcn',
		societyblack = 'society_lcn_black',
		samochody = {
			 {name = 'schafter4', label = 'Schafter', color = 12, glass = 1, tunning = true, count = 1},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 1,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['CDB'] = {
		society = 'society_CDB',				
		szafka = 'CDB',
		societyblack = 'society_CDB_black',
		samochody = {
			 {name = 'Kamacho', label = 'Kamacho', color = 0, glass = 1, tunning = true, count = 2},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 2,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['CDG'] = {
		society = 'society_jamajka',				
		szafka = 'jamajka',
		societyblack = 'society_jamajka_black',
		samochody = {
			 {name = 'toros', label = 'Toros', color = 41, glass = 1, tunning = true, count = 5},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 2,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['mechanicy'] = {
		society = 'society_mechanicy',				
		szafka = 'mechanicy',
		societyblack = 'society_mechanicy_black',
		samochody = {
			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 2,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['locco'] = {
		society = 'society_locco',				
		szafka = 'locco',
		societyblack = 'society_locco_black',
		samochody = {
			{name = 'schafter4', label = 'Schafter', color = 12, glass = 1, tunning = true, count = 1},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 2,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['ballas'] = {
		society = 'society_ballas',				
		szafka = 'ballas',
		societyblack = 'society_ballas_black',
		samochody = {
			{name = 'buccaneer2', label = 'Buccaneer', color = 145, glass = 1, tunning = true, count = 1},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 3,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
	['TheFamillies'] = {
		society = 'society_TheFamilles',				
		szafka = 'TheFamillies',
		societyblack = 'society_TheFamillies_black',
		samochody = {
			{name = 'buccaneer2', label = 'Buccaneer', color = 53, glass = 1, tunning = true, count = 1},			
		},
		pex = {
			samochody = 1,
			wyciaganiebroni = 3,
			wyciaganieitemow = 2,
			wyciaganiekasy = 4,
			wyciaganiekasybrudnej = 4,
		}
	},
}
Config.Zones = {
	['santa'] = {
		tako = {
			Armories = {
				vector3(-1518.33, 112.08, 50.05),
				
			},	
			Vehicles = {
				{
					Spawner      = { x = -1532.79, y = 81.58, z = 56.77 },
					SpawnPoint   = { x = -1520.896, y = 90.3944, z = 56.48 },
					Heading      = 240.22,
				},
				
			},	
			VehicleDeleters = {
				vector3(-1533.3597, 94.8854, 56.72),
				
			},
			szafka = {
				vector3(-1503.49, 102.26, 55.66),
			},	
		}

	},
	['Camorra'] = {
		tako = {
			Armories = {
				vector3(-1489.62, 840.93, 177.0),
				
			},	
			Vehicles = {
				{
					Spawner      = { x = -1529.89, y = 857.1, z = 181.5 },
					SpawnPoint   = { x = -1529.89, y = 857.1, z = 181.5 },
					Heading      = 47.05,
				},
				
			},	
			VehicleDeleters = {
				vector3(-1530.5, 887.48, 181.84),
				
			},
			szafka = {
				vector3(-1494.07, 839.62, 177.0),
			},	
		}

	},
	['lcn'] = {
		tako = {
			Armories = {
				vector3(-84.92, 997.3963, 230.61),
				
			},	
			Vehicles = {
				{
					Spawner      = { x = -124.416, y = 1009.0744, z = 235.73 },
					SpawnPoint   = { x = -125.956, y = 991.8644, z = 235.75 },
					Heading      = 151.22,
				},
				
			},	
			VehicleDeleters = {
				vector3(-108.4197, 1007.8654, 235.76),
				
			},
			szafka = {
				vector3(-90.74, 994.28, 234.56),
			},	
		}

	},
	['CDB'] = {
		tako = {
			Armories = {
				vector3(1392.43, 1134.56, 109.0),
				
			},	
			Vehicles = {
				{
					Spawner      = { x = 1400.63, y = 1119.29, z = 114.84 },
					SpawnPoint   = { x = 1400.63, y = 1119.29, z = 114.84 },
					Heading      = 97.43,
				},
				
			},	
			VehicleDeleters = {
				vector3( 1412.36, 1118.73, 114.84),
				
			},
			szafka = {
				vector3(1399.46, 1139.78, 114.33),
			},	
		}

	},
	['CDG'] = {
		tako = {
			Armories = {
				vector3(899.05, -3224.28, -98.27),
				
			},	
			Vehicles = {
				{
					Spawner      = { x = 1764.21, y = -1647.99, z = 112.65 },
					SpawnPoint   = { x = 1764.21, y = -1647.99, z = 112.65 },
					Heading      = 294.13,
				},
				
			},	
			VehicleDeleters = {
				vector3(1773.17, -1660.72, 112.61),
				
			},
			szafka = {
				vector3(904.34, -3201.16, -97.19),
			},	
		}

	},
	['mechanicy'] = {
		tako = {
			Armories = {
				vector3(-2.78, 532.53, 175.34),
			
			},	
			Vehicles = {
				{
					Spawner      = { x = -1532.79, y = 81.58, z = -56.77 },
					SpawnPoint   = { x = -1520.896, y = 90.3944, z = -56.48 },
					Heading      = 240.22,
				},
				
			},	
			VehicleDeleters = {
				vector3(-1533.3597, 94.8854, -56.72),
				
			},
			szafka = {
				vector3(8.37, 528.89, 170.64),
			},	
		}

	},
	['locco'] = {
		tako = {
			Armories = {
				vector3(-6.45, 530.64, 175.0),
			
			},	
			Vehicles = {
				{
					Spawner      = { x = 22.15, y = 544.32, z = 176.03 },
					SpawnPoint   = { x = 14.16, y = 549.3, z = 176.25 },
					Heading      = 55.34,
				},
				
			},	
			VehicleDeleters = {
				vector3(11.84, 544.87,175.86),
				
			},
			szafka = {
				vector3(9.67, 528.7, 170.62),
			},	
		}

	},
	['ballas'] = {
		tako = {
			Armories = {
				vector3(108.31, -1980.24, 20.66),
			
			},	
			Vehicles = {
				{
					Spawner      = { x = 103.74, y = -1966.12, z = 20.64 },
					SpawnPoint   = { x = 103.72, y = -1947.8, z = 20.78 },
					Heading      = 354.34,
				},
				
			},	
			VehicleDeleters = {
				vector3(86.28, -1970.43, 20.55),
				
			},
			szafka = {
				vector3(117.55, -1963.21, 21.03),
			},	
		}

	},
	['TheFamillies'] = {
		tako = {
			Armories = {
				vector3(-136.8, -1609.1, 34.70),
			
			},	
			Vehicles = {
				{
					Spawner      = { x = -113.35, y = -1597.31, z = 31.70 },
					SpawnPoint   = { x = -112.76, y = -1603.31, z = 31.73 },
					Heading      = 316.34,
				},
				
			},	
			VehicleDeleters = {
				vector3(-120.06, -1612.33, 31.60),
				
			},
			szafka = {
				vector3(-155.23, -1603.06, 34.74),
			},	
		}

	},
}

