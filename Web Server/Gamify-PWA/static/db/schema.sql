BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "games" (
	"gameID"	INTEGER,
	"gameName"	TEXT NOT NULL,
	"gameDev"	TEXT NOT NULL,
	"genre"	TEXT NOT NULL,
	"gameDesc"	TEXT NOT NULL,
	"ageRating"	TEXT NOT NULL,
	"logo"	hyperlink NOT NULL,
	"banner"	hyperlink NOT NULL,
	"trailer"	hyperlink NOT NULL,
	"sysReqs"	TEXT,
	"patchNotes"	TEXT,
	PRIMARY KEY("gameID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "reviews" (
	"revID"	INTEGER,
	"gameID"	INTEGER NOT NULL,
	"userID"	INTEGER NOT NULL,
	"revTitle"	TEXT NOT NULL,
	"revDate"	TEXT DEFAULT (strftime('%Y-%m-%d %H:%M', 'now', 'localtime')),
	"revDescription"	TEXT NOT NULL,
	"revRating"	INTEGER NOT NULL,
	PRIMARY KEY("revID" AUTOINCREMENT),
	FOREIGN KEY("gameID") REFERENCES "games"("gameID"),
	FOREIGN KEY("userID") REFERENCES "users"("userID")
);
CREATE TABLE IF NOT EXISTS "user_library" (
	"userID"	INTEGER NOT NULL,
	"gameID"	INTEGER NOT NULL,
	PRIMARY KEY("userID","gameID"),
	FOREIGN KEY("gameID") REFERENCES "games"("gameID"),
	FOREIGN KEY("userID") REFERENCES "users"("userID")
);
CREATE TABLE IF NOT EXISTS "users" (
	"userID"	INTEGER,
	"userName"	TEXT NOT NULL,
	"userEmail"	TEXT NOT NULL,
	"userPassword"	TEXT NOT NULL,
	"userPfp"	BLOB,
	"userBio"	TEXT,
	"userSettings"	TEXT,
	PRIMARY KEY("userID" AUTOINCREMENT)
);
INSERT INTO "games" VALUES (1,'Elden Ring','FromSoftware','RPG','An open-world action RPG set in a dark fantasy realm.','17+','https://www.pngmart.com/files/23/Elden-Ring-Logo-PNG-Photo.png','https://image.api.playstation.com/vulcan/ap/rnd/202110/2000/YMUoJUYNX0xWk6eTKuZLr5Iw.jpg','https://www.youtube.com/embed/AKXiKBnzpBQ','Patch 1.09: PvP balancing, ray tracing support','Windows 10, 12GB RAM, GTX 1060, 60GB storage');
INSERT INTO "games" VALUES (2,'Stardew Valley','ConcernedApe','Simulation','A farming simulator with RPG elements and cozy village life.','10+','https://cdn2.steamgriddb.com/logo/b1c9cafe109ae47006730f3cca062215.png','https://hisameartwork.wordpress.com/wp-content/uploads/2018/01/sdv-banner.jpg','https://www.youtube.com/embed/ot7uXNQskhs','Windows 7+, 2GB RAM, Intel HD Graphics, 500MB storage','1.6 Update: New crops, festivals, multiplayer fixes');
INSERT INTO "games" VALUES (3,'Valorant','Riot Games','FPS','Tactical 5v5 shooter with unique agent abilities.','16+','https://www.pngmart.com/files/23/Valorant-Logo-PNG.png','https://www.riotgames.com/darkroom/1440/8d5c497da1c2eeec8cffa99b01abc64b:5329ca773963a5b739e98e715957ab39/ps-f2p-val-console-launch-16x9.jpg','https://www.youtube.com/embed/2O1bH4YJ1XU','Windows 10, 8GB RAM, GTX 1050 Ti, 30GB storage','Episode 8: New map “Drift”, agent tweaks');
INSERT INTO "games" VALUES (4,'Hollow Knight','Team Cherry','Platformer','A hand-drawn metroidvania with deep lore and challenging combat.','12+','https://cdn2.steamgriddb.com/logo/6d4e59d5963286dfe2e696258bb10d1c.png','https://assets.nintendo.com/image/upload/c_fill,w_1200/q_auto:best/f_auto/dpr_2.0/store/software/switch/70010000003208/4643fb058642335c523910f3a7910575f56372f612f7c0c9a497aaae978d3e51','https://www.youtube.com/embed/UAO2urG23S4','Windows 7+, 4GB RAM, GeForce 9800GTX+, 9GB storage','Silksong teaser released, no release date yet');
INSERT INTO "games" VALUES (5,'Minecraft','Mojang Studios','Sandbox','Sandbox game with building, exploration, and survival mechanics.','7+','https://www.pngmart.com/files/22/Minecraft-Logo-PNG-Photos.png','https://image.api.playstation.com/vulcan/ap/rnd/202407/1020/91fe046f742042e3b31e57f7731dbe2226e1fd1e02a36223.jpg','https://www.youtube.com/embed/MmB9b5njVbA','Windows 10, 4GB RAM, Intel HD Graphics 4000, 1GB storage','1.20 Trails & Tales update: Camels, archaeology');
INSERT INTO "games" VALUES (6,'Cyberpunk 2077','CD Projekt Red','RPG','Futuristic RPG in Night City.','18+','https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Cyberpunk_2077_logo.svg/1200px-Cyberpunk_2077_logo.svg.png','https://image.api.playstation.com/vulcan/ap/rnd/202311/2812/ae84720b553c4ce943e9c342621b60f198beda0dbf533e21.jpg','https://www.youtube.com/embed/qIcTM8WXFjk','Win 10, 16GB RAM, RTX 2060, 70GB storage','Phantom Liberty DLC released');
INSERT INTO "games" VALUES (7,'The Witcher 3','CD Projekt Red','RPG','Fantasy RPG with monster hunting.','18+','https://pngimg.com/d/witcher_PNG13.png','https://www.thewitcher.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2F1.4c59601c.jpg&w=3840&q=75','https://www.youtube.com/embed/c0i88t0Kacs','Win 10, 8GB RAM, GTX 970, 50GB storage','Next-gen update with ray tracing');
INSERT INTO "games" VALUES (8,'Apex Legends','Respawn','Battle Royale','Battle royale with hero abilities.','16+','https://cdn.freebiesupply.com/images/large/2x/apex-legends-logo-font.png','https://gaming-cdn.com/images/news/articles/9130/cover/apex-legends-season-23-brings-us-the-great-return-of-the-original-map-with-classic-weapons-and-abilities-cover672a4833f1b62.jpg','https://www.youtube.com/embed/innmNewjkuk','Win 10, 8GB RAM, GTX 660, 22GB storage','Season 20: New legend “Conduit”');
INSERT INTO "games" VALUES (9,'Fortnite','Epic Games','Battle Royale','Battle royale with building mechanics.','13+','https://www.pngmart.com/files/22/Fortnite-Logo-PNG-File.png','https://cms-assets.unrealengine.com/cm6l5gfpm05kr07my04cqgy2x/cm9wwjg2r2n9e08n4hrfeouns','https://www.youtube.com/embed/2gUtfBmw86Y','Win 10, 8GB RAM, GTX 960, 30GB storage','OG Chapter returns');
INSERT INTO "games" VALUES (10,'League of Legends','Riot Games','MOBA','MOBA with strategic team battles.','13+','https://logos-world.net/wp-content/uploads/2020/11/League-of-Legends-Logo.png','https://res.cloudinary.com/jerrick/image/upload/v1719229443/66795c03ec9ab8001d956b4a.jpg','https://www.youtube.com/embed/BGtROJeMPeE','Win 7+, 4GB RAM, Intel HD Graphics, 15GB storage','Patch 13.22: Champion reworks');
INSERT INTO "games" VALUES (11,'Hades','Supergiant Games','Roguelike','Roguelike dungeon crawler with Greek mythology.','16+','https://cdn2.steamgriddb.com/logo/984866d32efb12f24c9ec497f3fad041.png','https://img-eshop.cdn.nintendo.net/i/dbc8c55a21688b446a5c57711b726956483a14ef8c5ddb861f897c0595ccb6b5.jpg','https://www.youtube.com/embed/591V2QKOQZQ','Win 7+, 4GB RAM, GTX 650, 15GB storage','Hades II announced');
INSERT INTO "games" VALUES (12,'Celeste','Matt Makes Games','Platformer','Precision platformer with emotional story.','10+','https://www.pngmart.com/files/22/Celeste-Game-Logo-PNG-Image.png','https://img.itch.zone/aW1nLzEwMjQyNTgucG5n/original/kDcm5O.png','https://www.youtube.com/embed/iofYDsP4bUs','Win 7+, 2GB RAM, Intel HD Graphics, 1GB storage','Accessibility options added');
INSERT INTO "games" VALUES (13,'Red Dead Redemption 2','Rockstar Games','Action','Western open-world adventure.','18+','https://www.pngmart.com/files/22/Red-Dead-Redemption-Logo-PNG-Transparent-Image.png','https://reflector.uindy.edu/wp-content/uploads/2018/11/what-we-want-in-red-dead-redemption-2-online.jpg','https://www.youtube.com/embed/eaW0tYpxyp0','Win 10, 12GB RAM, GTX 1060, 150GB storage','Online mode updates');
INSERT INTO "games" VALUES (14,'GTA V','Rockstar Games','Action','Crime sandbox with multiplayer.','18+','https://www.pngmart.com/files/13/GTA-V-Logo-PNG-File.png','https://roadtovrlive-5ea0.kxcdn.com/wp-content/uploads/2014/11/gtav-featured.jpg','https://www.youtube.com/embed/QkkoHAzjnUs','Win 10, 8GB RAM, GTX 660, 80GB storage','GTA Online: New heist missions');
INSERT INTO "games" VALUES (15,'Among Us','Innersloth','Party','Social deduction game in space.','10+','https://www.pngmart.com/files/23/Among-Us-Logo-PNG.png','https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/945360/capsule_616x353.jpg?t=1757444903','https://www.youtube.com/embed/NSJ4cESNQfE','Win 7+, 1GB RAM, Intel HD Graphics, 250MB storage','New roles added');
INSERT INTO "games" VALUES (16,'Fall Guys','Mediatonic','Party','Multiplayer obstacle course chaos.','7+','https://www.pngmart.com/files/23/Fall-Guys-Logo-PNG-Isolated-HD.png','https://techcrunch.com/wp-content/uploads/2022/05/fall-guys-free-to-play.png?w=1024','https://www.youtube.com/embed/0T2z4s-0rX8','Win 10, 4GB RAM, GTX 660, 2GB storage','Season 6: New maps');
INSERT INTO "games" VALUES (17,'Terraria','Re-Logic','Sandbox','2D sandbox with crafting and combat.','10+','https://www.pngkey.com/png/full/201-2011625_terraria-logo-png-terraria-game.png','https://img-eshop.cdn.nintendo.net/i/dac3a26570b5ca1ddf703bf0add7cc7c527f71a2b56521baf69e20c7a573c610.jpg','https://www.youtube.com/embed/w7uOhFTrrq0','Win 7+, 2GB RAM, Intel HD Graphics, 500MB storage','Labor of Love update');
INSERT INTO "games" VALUES (18,'Dead Cells','Motion Twin','Roguelike','Roguelike metroidvania with fast combat.','16+','https://www.nicepng.com/png/full/192-1925657_logo-icon-dead-cells-game-logo.png','https://cdn1.epicgames.com/spt-assets/697909f81fb44bcbade50cc93d2e78d2/dead-cells-yi5ph.png','https://www.youtube.com/embed/RAq3Zf0zv7g','Win 7+, 4GB RAM, GTX 660, 1GB storage','Castlevania DLC released');
INSERT INTO "games" VALUES (19,'Doom Eternal','id Software','FPS','Fast-paced demon-slaying FPS.','18+','https://cdn2.unrealengine.com/egs-doometernal-idsoftware-ic1-400x400-128d6d411d8d.png?resize=1&w=480&h=270&quality=medium','https://cdn1.epicgames.com/offer/b5ac16dc12f3478e99dcfea07c13865c/EGS_DOOMEternal_idSoftware_S1_2560x1440-06b46993a4b6c19a9e614f2dd1202215','https://www.youtube.com/embed/FkklG9MA0vM','Win 10, 8GB RAM, GTX 1060, 50GB storage','Horde Mode added');
INSERT INTO "games" VALUES (20,'Portal 2','Valve','Puzzle','Puzzle platformer with portals.','10+','https://www.pngmart.com/files/22/Portal-2-Logo-PNG-Pic.png','https://assets.nintendo.com/image/upload/q_auto/f_auto/store/software/switch/70010000050313/75484f73fedd25cb830c5d93fbb3fca643a5ec0b09df2815291ead880bc7d6b1','https://www.youtube.com/embed/uxjNDE2f','Win 7+, 2GB RAM, Intel HD Graphics, 8GB storage','Community maps support added');
INSERT INTO "games" VALUES (21,'Subnautica','Unknown Worlds','Survival','Underwater survival and exploration on an alien planet.','12+','https://www.pngmart.com/files/22/Subnautica-Game-Logo-PNG-HD.png','https://assets.nintendo.com/image/upload/q_auto/f_auto/store/software/switch/70010000030089/0500a5492e479ace4bdbfcf93048cb4b1464d3c5836a566e9f16f03d4d8b15ba','https://www.youtube.com/embed/diZ9b8z1YDw','Win 7+, 8GB RAM, GTX 550 Ti, 20GB storage','Below Zero expansion released');
INSERT INTO "games" VALUES (22,'Slay the Spire','MegaCrit','Card/Roguelike','Deck-building roguelike with strategic combat.','10+','https://cdn2.steamgriddb.com/logo_thumb/4d8bb121c305148c417a383070377063.png','https://raiseyourgame.com/wp-content/uploads/2024/01/Slay_792x447.jpg','https://www.youtube.com/embed/1yY2WFCpGdY','Win 7+, 4GB RAM, GTX 460, 1GB storage','New character mod support');
INSERT INTO "games" VALUES (23,'Ori and the Blind Forest','Moon Studios','Platformer','Emotional platformer with stunning visuals and music.','10+','https://cdn2.steamgriddb.com/logo_thumb/d123141180647a764278488cfd2f7569.png','https://assets.nintendo.com/image/upload/c_fill,w_1200/q_auto:best/f_auto/dpr_2.0/ncom/en_US/games/switch/o/ori-and-the-blind-forest-definitive-edition-switch/hero','https://www.youtube.com/embed/1K9jBL2syJk','Win 7+, 4GB RAM, GTX 550, 8GB storage','Definitive Edition released');
INSERT INTO "games" VALUES (24,'Rocket League','Psyonix','Sports','Soccer with rocket-powered cars.','7+','https://www.pngmart.com/files/23/Rocket-League-Logo-PNG-Photos.png','https://cdn1.epicgames.com/offer/9773aa1aa54f4f7b80e44bef04986cea/EGS_RocketLeague_PsyonixLLC_S1_2560x1440-4c231557ef0a0626fbb97e0bd137d837','https://www.youtube.com/embed/om0zG7Tg2kU','Win 7+, 4GB RAM, GTX 660, 20GB storage','Season 13: New arena and car packs');
INSERT INTO "games" VALUES (25,'Dota 2','Valve','MOBA','Multiplayer online battle arena with deep strategy.','13+','https://1000logos.net/wp-content/uploads/2019/04/Dota-2-Logo.png','https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/570/capsule_616x353.jpg?t=1762820658','https://www.youtube.com/embed/-cSFPIwMEq4','Win 7+, 4GB RAM, GTX 650, 15GB storage','The International 2025 qualifiers live');
INSERT INTO "games" VALUES (26,'Sea of Thieves','Rare','Adventure','Pirate-themed multiplayer adventure on the high seas.','13+','https://mir-s3-cdn-cf.behance.net/project_modules/hd/1973dc135898109.61f005682874d.png','https://cms-assets.xboxservices.com/assets/a0/26/a0261fcf-e92f-48d6-83a1-9f4424a7c1b6.jpg?n=467176942_GLP-Page-Hero-1084_1920x1080_03.jpg\','https://www.youtube.com/embed/r5JIBaasuE8','Win 10, 8GB RAM, GTX 1050 Ti, 50GB storage','Season 11: New voyages and cosmetics');
INSERT INTO "games" VALUES (27,'The Forest','Endnight Games','Horror','Survival horror in a mysterious forest.','18+','https://images.launchbox-app.com/9164ef96-0b68-4903-8050-940fef9b8d05.png','https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/242760/capsule_616x353.jpg?t=1699381053','https://www.youtube.com/embed/4qTtVMM3uqQ','Win 7+, 8GB RAM, GTX 560, 5GB storage','Sons of the Forest sequel released');
INSERT INTO "games" VALUES (28,'Cuphead','Studio MDHR','Platformer','Run-and-gun platformer with 1930s cartoon art style.','10+','https://wallpapers.com/images/hd/cuphead-logo-graphic-vt9s8lr3m7o0tv26.jpg','https://www.nintendo.com/eu/media/images/10_share_images/games_15/nintendo_switch_download_software_1/H2x1_NSwitchDS_Cuphead.jpg','https://www.youtube.com/embed/NN-9SQXoi50','Win 7+, 3GB RAM, Intel HD Graphics, 4GB storage','Delicious Last Course DLC released');
INSERT INTO "games" VALUES (29,'Inside','Playdead','Puzzle','Atmospheric puzzle-platformer with dark storytelling.','16+','https://www.pngkey.com/png/full/380-3800484_inside-logo-inside.png','https://img.opencritic.com/game/2848/o/Jo0HjaKf.jpg','https://www.youtube.com/embed/E1yFZgB_5kU','Win 8+, 4GB RAM, GTX 460, 3GB storage','Xbox Game Pass availability');
INSERT INTO "reviews" VALUES (1,13,8,'This is an amazing gammememememe','2025-12-14 12:30','HAD SO MUCH FUN PLAYING THIS!!!!!',10);
INSERT INTO "user_library" VALUES (8,14);
INSERT INTO "user_library" VALUES (8,26);
INSERT INTO "user_library" VALUES (8,9);
INSERT INTO "user_library" VALUES (8,13);
INSERT INTO "user_library" VALUES (8,3);
INSERT INTO "user_library" VALUES (8,8);
INSERT INTO "users" VALUES (8,'yatharthjain','yatharth.jain@education.nsw.gov.au','scrypt:32768:8:1$kFyWE1v4uXhFc2ZN$4111ede968fd9c0e35872a96f325f80e2280a363044743cdfe1548214fdeb978b5b591c170dc1611635cdd5ffcb0428573f77f23858a99fe21b7c46226e891a6','static/uploads\white-menu-icon-12.jpg','awdaweawdawdw',NULL);
INSERT INTO "users" VALUES (9,'tester','tester@gmail.com','scrypt:32768:8:1$PatHYTcwVnXOWjmO$b18eeda45f512c0b739bda724a3647edfebac5ec9fc457a9098de12d4c3ee98c90442334156d3583598979eed464704e685727a15e6e2b0c6cfec6a8586d4d36',NULL,NULL,NULL);
INSERT INTO "users" VALUES (10,'suchet','suchet@gmail.com','scrypt:32768:8:1$aQ34xz7D61WSvp7c$557e2c88396253286e634f0fd7c3e8070b932495c9d9898a7e04fc12d1a7b08d1fb9a1b4683696c022fe54d9109ae3013be78602c50b7e83186ff4a7893646aa',NULL,NULL,NULL);
COMMIT;
