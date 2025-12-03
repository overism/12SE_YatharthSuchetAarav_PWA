DROP TABLE IF EXISTS games;
CREATE TABLE games (
    gameID INTEGER PRIMARY KEY AUTOINCREMENT,
    gameName TEXT NOT NULL,
    gameDev TEXT NOT NULL,
    genre TEXT NOT NULL,
    gameDesc TEXT NOT NULL,
    ageRating TEXT NOT NULL,
    logo hyperlink NOT NULL,
    banner hyperlink NOT NULL,
    trailer hyperlink NOT NULL,
    patchNotes TEXT,
    sysReqs TEXT
);

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    revID INTEGER PRIMARY KEY AUTOINCREMENT,
    gameID INTEGER NOT NULL,
    revDescription TEXT NOT NULL,
    revRating INTEGER NOT NULL,
    FOREIGN KEY (gameID) REFERENCES games (gameID)
);

INSERT INTO games (gameID, gameName, gameDev, genre, gameDesc, ageRating, logo, banner, trailer, sysReqs, patchNotes)
VALUES (1, 'Elden Ring', 'FromSoftware', 'RPG', 'An open-world action RPG set in a dark fantasy realm.', '17+', 'https://i.imgur.com/eldenringlogo.png', 'https://i.imgur.com/eldenringbanner.jpg', 'https://www.youtube.com/watch?v=AKXiKBnzpBQ', 'Windows 10, 12GB RAM, GTX 1060, 60GB storage', 'Patch 1.09: PvP balancing, ray tracing support');

INSERT INTO games VALUES (2, 'Stardew Valley', 'ConcernedApe', 'Simulation', 'A farming simulator with RPG elements and cozy village life.', '10+', 'https://i.imgur.com/stardewlogo.png', 'https://i.imgur.com/stardewbanner.jpg', 'https://www.youtube.com/watch?v=ot7uXNQskhs', 'Windows 7+, 2GB RAM, Intel HD Graphics, 500MB storage', '1.6 Update: New crops, festivals, multiplayer fixes');

INSERT INTO games VALUES (3, 'Valorant', 'Riot Games', 'FPS', 'Tactical 5v5 shooter with unique agent abilities.', '16+', 'https://i.imgur.com/valorantlogo.png', 'https://i.imgur.com/valorantbanner.jpg', 'https://www.youtube.com/watch?v=2O1bH4YJ1XU', 'Windows 10, 8GB RAM, GTX 1050 Ti, 30GB storage', 'Episode 8: New map “Drift”, agent tweaks');

INSERT INTO games VALUES (4, 'Hollow Knight', 'Team Cherry', 'Platformer', 'A hand-drawn metroidvania with deep lore and challenging combat.', '12+', 'https://i.imgur.com/hollowknightlogo.png', 'https://i.imgur.com/hollowknightbanner.jpg', 'https://www.youtube.com/watch?v=UAO2urG23S4', 'Windows 7+, 4GB RAM, GeForce 9800GTX+, 9GB storage', 'Silksong teaser released, no release date yet');

INSERT INTO games VALUES (5, 'Minecraft', 'Mojang Studios', 'Sandbox', 'Sandbox game with building, exploration, and survival mechanics.', '7+', 'https://i.imgur.com/minecraftlogo.png', 'https://i.imgur.com/minecraftbanner.jpg', 'https://www.youtube.com/watch?v=MmB9b5njVbA', 'Windows 10, 4GB RAM, Intel HD Graphics 4000, 1GB storage', '1.20 Trails & Tales update: Camels, archaeology');

INSERT INTO games VALUES (6, 'Cyberpunk 2077', 'CD Projekt Red', 'RPG', 'Futuristic RPG in Night City.', '18+', 'https://i.imgur.com/cyberpunklogo.png', 'https://i.imgur.com/cyberpunkbanner.jpg', 'https://youtu.be/qIcTM8WXFjk', 'Win 10, 16GB RAM, RTX 2060, 70GB storage', 'Phantom Liberty DLC released');

INSERT INTO games VALUES (7, 'The Witcher 3', 'CD Projekt Red', 'RPG', 'Fantasy RPG with monster hunting.', '18+', 'https://i.imgur.com/witcher3logo.png', 'https://i.imgur.com/witcher3banner.jpg', 'https://youtu.be/c0i88t0Kacs', 'Win 10, 8GB RAM, GTX 970, 50GB storage', 'Next-gen update with ray tracing');

INSERT INTO games VALUES (8, 'Apex Legends', 'Respawn', 'Battle Royale', 'Battle royale with hero abilities.', '16+', 'https://i.imgur.com/apexlogo.png', 'https://i.imgur.com/apexbanner.jpg', 'https://youtu.be/innmNewjkuk', 'Win 10, 8GB RAM, GTX 660, 22GB storage', 'Season 20: New legend “Conduit”');

INSERT INTO games VALUES (9, 'Fortnite', 'Epic Games', 'Battle Royale', 'Battle royale with building mechanics.', '13+', 'https://i.imgur.com/fortnitelogo.png', 'https://i.imgur.com/fortnitebanner.jpg', 'https://youtu.be/2gUtfBmw86Y', 'Win 10, 8GB RAM, GTX 960, 30GB storage', 'OG Chapter returns');

INSERT INTO games VALUES (10, 'League of Legends', 'Riot Games', 'MOBA', 'MOBA with strategic team battles.', '13+', 'https://i.imgur.com/lollogo.png', 'https://i.imgur.com/lolbanner.jpg', 'https://youtu.be/BGtROJeMPeE', 'Win 7+, 4GB RAM, Intel HD Graphics, 15GB storage', 'Patch 13.22: Champion reworks');

INSERT INTO games VALUES (11, 'Hades', 'Supergiant Games', 'Roguelike', 'Roguelike dungeon crawler with Greek mythology.', '16+', 'https://i.imgur.com/hadeslogo.png', 'https://i.imgur.com/hadesbanner.jpg', 'https://youtu.be/591V2QKOQZQ', 'Win 7+, 4GB RAM, GTX 650, 15GB storage', 'Hades II announced');

INSERT INTO games VALUES (12, 'Celeste', 'Matt Makes Games', 'Platformer', 'Precision platformer with emotional story.', '10+', 'https://i.imgur.com/celestelogo.png', 'https://i.imgur.com/celestebanner.jpg', 'https://youtu.be/iofYDsP4bUs', 'Win 7+, 2GB RAM, Intel HD Graphics, 1GB storage', 'Accessibility options added');

INSERT INTO games VALUES (13, 'Red Dead Redemption 2', 'Rockstar Games', 'Action', 'Western open-world adventure.', '18+', 'https://i.imgur.com/rdr2logo.png', 'https://i.imgur.com/rdr2banner.jpg', 'https://youtu.be/eaW0tYpxyp0', 'Win 10, 12GB RAM, GTX 1060, 150GB storage', 'Online mode updates');

INSERT INTO games VALUES (14, 'GTA V', 'Rockstar Games', 'Action', 'Crime sandbox with multiplayer.', '18+', 'https://i.imgur.com/gtavlogo.png', 'https://i.imgur.com/gtavbanner.jpg', 'https://youtu.be/QkkoHAzjnUs', 'Win 10, 8GB RAM, GTX 660, 80GB storage', 'GTA Online: New heist missions');

INSERT INTO games VALUES (15, 'Among Us', 'Innersloth', 'Party', 'Social deduction game in space.', '10+', 'https://i.imgur.com/amonguslogo.png', 'https://i.imgur.com/amongusbanner.jpg', 'https://youtu.be/NSJ4cESNQfE', 'Win 7+, 1GB RAM, Intel HD Graphics, 250MB storage', 'New roles added');

INSERT INTO games VALUES (16, 'Fall Guys', 'Mediatonic', 'Party', 'Multiplayer obstacle course chaos.', '7+', 'https://i.imgur.com/fallguyslogo.png', 'https://i.imgur.com/fallguysbanner.jpg', 'https://youtu.be/0T2z4s-0rX8', 'Win 10, 4GB RAM, GTX 660, 2GB storage', 'Season 6: New maps');

INSERT INTO games VALUES (17, 'Terraria', 'Re-Logic', 'Sandbox', '2D sandbox with crafting and combat.', '10+', 'https://i.imgur.com/terraria_logo.png', 'https://i.imgur.com/terraria_banner.jpg', 'https://youtu.be/w7uOhFTrrq0', 'Win 7+, 2GB RAM, Intel HD Graphics, 500MB storage', 'Labor of Love update');

INSERT INTO games VALUES (18, 'Dead Cells', 'Motion Twin', 'Roguelike', 'Roguelike metroidvania with fast combat.', '16+', 'https://i.imgur.com/deadcellslogo.png', 'https://i.imgur.com/deadcellsbanner.jpg', 'https://youtu.be/RAq3Zf0zv7g', 'Win 7+, 4GB RAM, GTX 660, 1GB storage', 'Castlevania DLC released');

INSERT INTO games VALUES (19, 'Doom Eternal', 'id Software', 'FPS', 'Fast-paced demon-slaying FPS.', '18+', 'https://i.imgur.com/doometernallogo.png', 'https://i.imgur.com/doometernalbanner.jpg', 'https://youtu.be/FkklG9MA0vM', 'Win 10, 8GB RAM, GTX 1060, 50GB storage', 'Horde Mode added');

INSERT INTO games VALUES (20, 'Portal 2', 'Valve', 'Puzzle', 'Puzzle platformer with portals.', '10+', 'https://i.imgur.com/portal2logo.png', 'https://i.imgur.com/portal2banner.jpg', 'https://youtu.be/uxjNDE2f', 'Win 7+, 2GB RAM, Intel HD Graphics, 8GB storage', 'Community maps support added');

INSERT INTO games VALUES (21, 'Subnautica', 'Unknown Worlds', 'Survival', 'Underwater survival and exploration on an alien planet.', '12+', 'https://i.imgur.com/subnauticalogo.png', 'https://i.imgur.com/subnauticabanner.jpg', 'https://youtu.be/diZ9b8z1YDw', 'Win 7+, 8GB RAM, GTX 550 Ti, 20GB storage', 'Below Zero expansion released');

INSERT INTO games VALUES (22, 'Slay the Spire', 'MegaCrit', 'Card/Roguelike', 'Deck-building roguelike with strategic combat.', '10+', 'https://i.imgur.com/slaythespirelogo.png', 'https://i.imgur.com/slaythespirebanner.jpg', 'https://youtu.be/1yY2WFCpGdY', 'Win 7+, 4GB RAM, GTX 460, 1GB storage', 'New character mod support');

INSERT INTO games VALUES (23, 'Ori and the Blind Forest', 'Moon Studios', 'Platformer', 'Emotional platformer with stunning visuals and music.', '10+', 'https://i.imgur.com/orilogo.png', 'https://i.imgur.com/oribanner.jpg', 'https://youtu.be/1K9jBL2syJk', 'Win 7+, 4GB RAM, GTX 550, 8GB storage', 'Definitive Edition released');

INSERT INTO games VALUES (24, 'Rocket League', 'Psyonix', 'Sports', 'Soccer with rocket-powered cars.', '7+', 'https://i.imgur.com/rocketleaguelogo.png', 'https://i.imgur.com/rocketleaguebanner.jpg', 'https://youtu.be/om0zG7Tg2kU', 'Win 7+, 4GB RAM, GTX 660, 20GB storage', 'Season 13: New arena and car packs');

INSERT INTO games VALUES (25, 'Dota 2', 'Valve', 'MOBA', 'Multiplayer online battle arena with deep strategy.', '13+', 'https://i.imgur.com/dota2logo.png', 'https://i.imgur.com/dota2banner.jpg', 'https://youtu.be/-cSFPIwMEq4', 'Win 7+, 4GB RAM, GTX 650, 15GB storage', 'The International 2025 qualifiers live');

INSERT INTO games VALUES (26, 'Sea of Thieves', 'Rare', 'Adventure', 'Pirate-themed multiplayer adventure on the high seas.', '13+', 'https://i.imgur.com/seaofthieveslogo.png', 'https://i.imgur.com/seaofthievesbanner.jpg', 'https://youtu.be/r5JIBaasuE8', 'Win 10, 8GB RAM, GTX 1050 Ti, 50GB storage', 'Season 11: New voyages and cosmetics');

INSERT INTO games VALUES (27, 'The Forest', 'Endnight Games', 'Horror', 'Survival horror in a mysterious forest.', '18+', 'https://i.imgur.com/theforestlogo.png', 'https://i.imgur.com/theforestbanner.jpg', 'https://youtu.be/4qTtVMM3uqQ', 'Win 7+, 8GB RAM, GTX 560, 5GB storage', 'Sons of the Forest sequel released');

INSERT INTO games VALUES (28, 'Cuphead', 'Studio MDHR', 'Platformer', 'Run-and-gun platformer with 1930s cartoon art style.', '10+', 'https://i.imgur.com/cupheadlogo.png', 'https://i.imgur.com/cupheadbanner.jpg', 'https://youtu.be/NN-9SQXoi50', 'Win 7+, 3GB RAM, Intel HD Graphics, 4GB storage', 'Delicious Last Course DLC released');

INSERT INTO games VALUES (29, 'Inside', 'Playdead', 'Puzzle', 'Atmospheric puzzle-platformer with dark storytelling.', '16+', 'https://i.imgur.com/insidelogo.png', 'https://i.imgur.com/insidebanner.jpg', 'https://youtu.be/E1yFZgB_5kU', 'Win 8+, 4GB RAM, GTX 460, 3GB storage', 'Xbox Game Pass availability');