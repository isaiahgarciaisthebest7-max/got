@echo off
setlocal EnableDelayedExpansion
title Knight RPG: The Ultimate Matrix
color 0a

:: ===== INITIAL BOOT & TITLE =====
:title_screen
cls
echo ==========================================================
echo                  KNIGHT RPG: ULTIMATE
echo ==========================================================
echo  1. New Game
echo  2. Load Game
echo  3. Exit
echo ==========================================================
set choice=
set /p choice=Select an option: 

if "!choice!"=="1" goto new_game
if "!choice!"=="2" goto load_game
if "!choice!"=="3" exit
goto title_screen

:: ===== INITIAL BUILD =====
:new_game
set prestige=0
set p_multi=1

:char_select
cls
echo ==========================================================
echo                  CHOOSE YOUR DESTINY
echo ==========================================================
if !prestige! GTR 0 echo   *** REBIRTH LEVEL: !prestige! (Stats x!p_multi!) ***
if !prestige! GTR 0 echo.
echo 1) Paladin     (Passive: Holy Armor - Takes 10%% less damage)
echo 2) Pyromancer  (Passive: Fireball - Magic deals 2x damage)
echo 3) Assassin    (Passive: Shadow Step - +15%% Dodge Chance)
echo 4) Necromancer (Passive: Vampirism - Magic siphons 50%% HP)
echo ==========================================================
set class_choice=
set /p class_choice=Select Class: 

if "!class_choice!"=="1" (set class=Paladin & set maxhp=200 & set maxmana=50)
if "!class_choice!"=="2" (set class=Pyromancer & set maxhp=90 & set maxmana=150)
if "!class_choice!"=="3" (set class=Assassin & set maxhp=120 & set maxmana=80)
if "!class_choice!"=="4" (set class=Necromancer & set maxhp=110 & set maxmana=100)
:: Fallback if invalid input
if "!class!"=="" goto char_select

set level=1
set xp=0
set /a nextxp=50 * p_multi
set /a gold=150 * p_multi

:: Crafting Mats
set bones=0
set dark_iron=0
set dragon_souls=0

:: Upgrades
set sword_up=0
set armor_up=0
set amulet_up=0
set boots_up=0

:: Pets
if "!pet_name!"=="" set pet_name=None
if "!pet_dmg!"=="" set pet_dmg=0

:: Apply Prestige Multiplier to Base Stats
set /a maxhp=maxhp * p_multi
set /a maxmana=maxmana * p_multi
set hp=!maxhp!
set mana=!maxmana!
set sword=1
set w_name=Wooden Sword
set potions=5

goto menu

:: ===== MAIN HUB =====
:menu
cls
echo ==========================================================
echo  [!class!] Level: !level! ^| Rebirth: !prestige! ^| Gold: !gold!g
echo  HP: !hp!/!maxhp! ^| Mana: !mana!/!maxmana! ^| XP: !xp!/!nextxp!
echo ==========================================================
echo  Weapon: !w_name! (+!sword_up!)
echo  Pet: !pet_name! (Auto-Damage: !pet_dmg!)
echo  Upgrades: Armor(+!armor_up!) Amulet(+!amulet_up!) Boots(+!boots_up!)
echo  Materials: !bones! Bones ^| !dark_iron! Dark Iron ^| !dragon_souls! Souls
echo ==========================================================
echo  1. Explore Wilds (Grind Mats)   6. Crafting Forge
echo  2. The Endless Tower (Bosses)   7. Pet Sanctuary
echo  3. Kingdom Shop                 8. REBIRTH (Level 50+)
echo  4. Blacksmith (Upgrades)        9. Rest at Inn (Free)
echo  5. Abilities & Stats            0. Save Game
echo ==========================================================
set choice=
set /p choice=Where to, Hero?: 

if "!choice!"=="1" goto explore
if "!choice!"=="2" goto tower
if "!choice!"=="3" goto shop
if "!choice!"=="4" goto blacksmith
if "!choice!"=="5" goto skills
if "!choice!"=="6" goto craft
if "!choice!"=="7" goto pets
if "!choice!"=="8" goto rebirth
if "!choice!"=="9" goto rest
if "!choice!"=="0" goto save_game
goto menu

:: ===== SAVE / LOAD =====
:save_game
cls
echo Saving game...
(
echo prestige=!prestige!
echo p_multi=!p_multi!
echo class=!class!
echo maxhp=!maxhp!
echo maxmana=!maxmana!
echo hp=!hp!
echo mana=!mana!
echo level=!level!
echo xp=!xp!
echo nextxp=!nextxp!
echo gold=!gold!
echo bones=!bones!
echo dark_iron=!dark_iron!
echo dragon_souls=!dragon_souls!
echo sword_up=!sword_up!
echo armor_up=!armor_up!
echo amulet_up=!amulet_up!
echo boots_up=!boots_up!
echo pet_name=!pet_name!
echo pet_dmg=!pet_dmg!
echo sword=!sword!
echo w_name=!w_name!
echo potions=!potions!
) > knight_save.ini
echo.
echo Game successfully saved to knight_save.ini!
pause
goto menu

:load_game
cls
if not exist knight_save.ini (
    echo No save file found! Please start a New Game.
    pause
    goto title_screen
)
echo Loading game...
for /f "delims=" %%a in (knight_save.ini) do set "%%a"
echo Game Loaded successfully!
pause
goto menu

:: ===== STATS & ABILITIES (Fixed Bug) =====
:skills
cls
set /a base_dmg=5 + (sword * 10) + (sword_up * 5) + (level * 2)
set /a base_dmg=!base_dmg! * p_multi
set /a base_magic=20 + (amulet_up * 15) + (level * 5)
set /a base_magic=!base_magic! * p_multi
set /a current_dodge=boots_up * 2 + 5
if "!class!"=="Assassin" set /a current_dodge+=15

echo ==========================================================
echo                YOUR STATS AND ABILITIES
echo ==========================================================
echo  CLASS: !class!
echo  Rebirth Multiplier: x!p_multi!
echo.
echo  COMBAT STATS:
echo  - Average Melee Damage: !base_dmg! (+ Random Variance)
echo  - Base Magic Damage:    !base_magic! (Costs 20 Mana)
echo  - Dodge Chance:         !current_dodge!%%
echo.
echo  ACTIVE PASSIVE ABILITY:
if "!class!"=="Paladin" echo  [Holy Armor] All incoming damage is reduced by 10%%.
if "!class!"=="Pyromancer" echo  [Fireball] Your Magic attacks deal double damage!
if "!class!"=="Assassin" echo  [Shadow Step] Your base dodge chance is permanently increased by 15%%.
if "!class!"=="Necromancer" echo  [Vampirism] 50%% of Magic Damage dealt is returned to you as HP.
echo ==========================================================
pause
goto menu

:: ===== REST =====
:rest
cls
echo You rest by the fire...
timeout /t 1 >nul
set hp=!maxhp!
set mana=!maxmana!
echo.
echo HP and Mana fully restored!
pause
goto menu

:: ===== PET SANCTUARY =====
:pets
cls
echo ======= MYSTIC PET SANCTUARY =======
echo Gold: !gold!g
echo.
echo 1) Buy Dire Wolf (500g)     [+15 Auto-Dmg]
echo 2) Buy Shadow Panther (1500g)[+40 Auto-Dmg]
echo 3) Buy Baby Dragon (4000g)  [+100 Auto-Dmg]
echo 4) Leave
echo ========================================
set pet_c=
set /p pet_c=Choose: 

if "!pet_c!"=="1" if !gold! GEQ 500 (set /a gold-=500 & set pet_name=Dire Wolf & set pet_dmg=15 & echo Bought Dire Wolf! & pause & goto pets)
if "!pet_c!"=="2" if !gold! GEQ 1500 (set /a gold-=1500 & set pet_name=Shadow Panther & set pet_dmg=40 & echo Bought Shadow Panther! & pause & goto pets)
if "!pet_c!"=="3" if !gold! GEQ 4000 (set /a gold-=4000 & set pet_name=Baby Dragon & set pet_dmg=100 & echo Bought Baby Dragon! & pause & goto pets)
if "!pet_c!"=="4" goto menu
echo Not enough gold or invalid option.
pause
goto pets

:: ===== CRAFTING FORGE =====
:craft
cls
echo ======= ANCIENT CRAFTING FORGE =======
echo Your Materials: !bones! Bones, !dark_iron! Dark Iron, !dragon_souls! Souls
echo.
echo 1) Bloodletter (Req: 10 Bones, 5 Dark Iron) [Power: 15]
echo 2) Void Blade  (Req: 20 Dark Iron, 2 Souls) [Power: 30]
echo 3) Infinity Edge(Req: 10 Souls, 50,000g)    [Power: 100]
echo 4) Leave
echo ========================================
set c_c=
set /p c_c=Craft what?: 

if "!c_c!"=="1" if !bones! GEQ 10 if !dark_iron! GEQ 5 (
    set /a bones-=10 & set /a dark_iron-=5
    set sword=15 & set w_name=Bloodletter & echo Crafted Bloodletter! & pause & goto craft
)
if "!c_c!"=="2" if !dark_iron! GEQ 20 if !dragon_souls! GEQ 2 (
    set /a dark_iron-=20 & set /a dragon_souls-=2
    set sword=30 & set w_name=Void Blade & echo Crafted Void Blade! & pause & goto craft
)
if "!c_c!"=="3" if !dragon_souls! GEQ 10 if !gold! GEQ 50000 (
    set /a dragon_souls-=10 & set /a gold-=50000
    set sword=100 & set w_name=INFINITY EDGE & echo CRAFTED THE INFINITY EDGE! & pause & goto craft
)
if "!c_c!"=="4" goto menu
echo Missing materials or invalid option!
pause
goto craft

:: ===== BLACKSMITH =====
:blacksmith
cls
set /a sc=!sword_up!*100 + 50
set /a ac=!armor_up!*100 + 50
set /a amc=!amulet_up!*150 + 100
set /a bc=!boots_up!*150 + 100

echo ======= ROYAL BLACKSMITH =======
echo Gold: !gold!g
echo.
echo 1) Sharpen Weapon (+Dmg)   Cost: !sc!g
echo 2) Reinforce Armor (+HP)   Cost: !ac!g
echo 3) Enchant Amulet (+Mana)  Cost: !amc!g
echo 4) Lighten Boots (+Dodge)  Cost: !bc!g
echo 5) Leave
echo ========================================
set b_c=
set /p b_c=Upgrade: 

if "!b_c!"=="1" if !gold! GEQ !sc! (set /a gold-=sc & set /a sword_up+=1 & echo Weapon Sharpened! & pause & goto blacksmith)
if "!b_c!"=="2" if !gold! GEQ !ac! (set /a gold-=ac & set /a armor_up+=1 & set /a maxhp+=25 & set hp=!maxhp! & echo Armor Reinforced! & pause & goto blacksmith)
if "!b_c!"=="3" if !gold! GEQ !amc! (set /a gold-=amc & set /a amulet_up+=1 & set /a maxmana+=20 & set mana=!maxmana! & echo Amulet Enchanted! & pause & goto blacksmith)
if "!b_c!"=="4" if !gold! GEQ !bc! (set /a gold-=bc & set /a boots_up+=1 & echo Boots Lightened! & pause & goto blacksmith)
if "!b_c!"=="5" goto menu
echo Not enough gold or invalid option!
pause
goto blacksmith

:: ===== SHOP =====
:shop
cls
echo ======= MERCHANTS TENT =======
echo Gold: !gold!g
echo.
echo 1) Iron Sword (200g) [Power: 3]
echo 2) Steel Claymore (800g) [Power: 8]
echo 3) Buy 5 Health Potions (100g)
echo 4) Leave
echo ========================================
set s_c=
set /p s_c=Buy: 

if "!s_c!"=="1" if !gold! GEQ 200 (set /a gold-=200 & set sword=3 & set w_name=Iron Sword & echo Bought Iron Sword! & pause & goto shop)
if "!s_c!"=="2" if !gold! GEQ 800 (set /a gold-=800 & set sword=8 & set w_name=Steel Claymore & echo Bought Steel Claymore! & pause & goto shop)
if "!s_c!"=="3" if !gold! GEQ 100 (set /a gold-=100 & set /a potions+=5 & echo Bought 5 Health Potions! & pause & goto shop)
if "!s_c!"=="4" goto menu
echo Not enough gold or invalid option.
pause
goto shop

:: ===== EXPLORE (GRINDING) =====
:explore
set /a rnd_enc=%random% %% 3
if !rnd_enc!==0 (set enemy=Forest Goblin & set loot_type=bones)
if !rnd_enc!==1 (set enemy=Wild Boar & set loot_type=bones)
if !rnd_enc!==2 (set enemy=Bandit Scout & set loot_type=bones)

set /a enemyhp=30 * p_multi + (level * 10)
set /a enemydmg=5 * p_multi + (level * 2)
goto fightstart

:: ===== TOWER (BOSSES) =====
:tower
set /a t_floor=(level / 5) + 1
echo Entering Tower Floor !t_floor!...
timeout /t 1 >nul
if !t_floor! LSS 3 (
    set enemy=Tower Sentinel
    set /a enemyhp=150 * p_multi + (level * 20)
    set /a enemydmg=15 * p_multi + (level * 5)
    set loot_type=dark_iron
) else if !t_floor! LSS 6 (
    set enemy=Apex Dragon
    set /a enemyhp=500 * p_multi + (level * 50)
    set /a enemydmg=35 * p_multi + (level * 10)
    set loot_type=dragon_souls
) else (
    set enemy=Corrupted Titan
    set /a enemyhp=1000 * p_multi + (level * 75)
    set /a enemydmg=60 * p_multi + (level * 15)
    set loot_type=dragon_souls
)
goto fightstart

:: ===== COMBAT ENGINE =====
:fightstart
set /a start_enemyhp=!enemyhp!

:fightloop
cls
echo ==========================================================
echo   ENEMY: !enemy! 
echo   HP: [!enemyhp! / !start_enemyhp!]
echo ==========================================================
echo   YOUR HP: !hp!/!maxhp!  ^| MANA: !mana!/!maxmana!  ^|  POTIONS: !potions!
echo ==========================================================
echo 1) Attack         3) Use Potion (Heal 50%%)
echo 2) Cast Magic     4) Flee
set action=
set /p action=Action: 

if "!action!"=="1" goto attack
if "!action!"=="2" goto magic
if "!action!"=="3" goto heal
if "!action!"=="4" goto menu
goto fightloop

:attack
set /a dmg=5 + (sword * 10) + (sword_up * 5) + (level * 2) + (%random% %% 10)
set /a dmg=!dmg! * p_multi
set /a enemyhp-=dmg
echo.
echo You struck the enemy with your !w_name! for !dmg! damage!
goto pet_phase

:magic
if !mana! LSS 20 (echo Not enough mana! & timeout /t 1 >nul & goto fightloop)
set /a mana-=20
set /a dmg=20 + (amulet_up * 15) + (level * 5)
set /a dmg=!dmg! * p_multi

:: Apply Pyromancer Passive
if "!class!"=="Pyromancer" (
    set /a dmg=!dmg!*2
    echo *FIREBALL PASSIVE TRIGGERED!*
)

set /a enemyhp-=dmg
echo.
echo You blasted the enemy with magic for !dmg! damage!

:: Apply Necromancer Passive
if "!class!"=="Necromancer" (
    set /a heal_amount=!dmg!/2
    set /a hp+=!heal_amount!
    if !hp! GTR !maxhp! set hp=!maxhp!
    echo *VAMPIRISM PASSIVE!* Siphoned !heal_amount! HP!
)
goto pet_phase

:heal
if !potions! LSS 1 (echo No potions left! & timeout /t 1 >nul & goto fightloop)
set /a potions-=1
set /a heal_amt=maxhp / 2
set /a hp+=heal_amt
if !hp! GTR !maxhp! set hp=!maxhp!
echo.
echo You drank a potion and healed for !heal_amt! HP!
goto pet_phase

:pet_phase
if "!pet_name!" NEQ "None" (
    set /a enemyhp-=pet_dmg
    echo !pet_name! attacks for !pet_dmg! damage!
)
if !enemyhp! LEQ 0 goto win

:enemy_turn
:: Dodge Mechanic with Assassin Passive
set /a dodge_chance=boots_up * 2 + 5
if "!class!"=="Assassin" set /a dodge_chance+=15

set /a dodge_roll=%random% %% 100
if !dodge_roll! LSS !dodge_chance! (
    echo.
    echo You dodged the enemy attack!
    pause
    goto fightloop
)

:: Enemy Damage with Paladin Passive
set /a edmg=enemydmg + (%random% %% 5)
if "!class!"=="Paladin" (
    set /a reduced=!edmg!/10
    set /a edmg-=!reduced!
)

set /a hp-=edmg
echo.
echo !enemy! hits you for !edmg! damage!
if !hp! LEQ 0 goto gameover
pause
goto fightloop

:: ===== VICTORY & LEVEL UP LOOP =====
:win
set /a r_gold=(20 + (%random% %% 30) + (level * 5)) * p_multi
set /a r_xp=(30 + (%random% %% 20) + (level * 10)) * p_multi

echo.
echo === VICTORY ===
echo Gained !r_gold! Gold and !r_xp! XP!
set /a gold+=r_gold
set /a xp+=r_xp

:: Loot Drops
set /a drop_roll=%random% %% 100
if "!loot_type!"=="bones" if !drop_roll! LSS 50 (set /a bones+=1 & echo Found a Monster Bone!)
if "!loot_type!"=="dark_iron" if !drop_roll! LSS 40 (set /a dark_iron+=1 & echo Found Dark Iron!)
if "!loot_type!"=="dragon_souls" if !drop_roll! LSS 20 (set /a dragon_souls+=1 & echo Found a Dragon Soul!)

:: Level up loop handles gaining multiple levels at once
:level_check
if !xp! GEQ !nextxp! (
    set /a xp-=nextxp
    set /a level+=1
    set /a nextxp+=75 * p_multi
    set /a maxhp+=20
    set /a maxmana+=10
    set hp=!maxhp!
    set mana=!maxmana!
    echo *** LEVEL UP! You are now Level !level! ***
    goto level_check
)
pause
goto menu

:: ===== REBIRTH =====
:rebirth
cls
if !level! LSS 50 (
    echo You must be Level 50 to Rebirth!
    pause
    goto menu
)
echo !!! WARNING !!!
echo Rebirth will reset your Level, Gold, Gear, and Upgrades.
echo You will keep your Pets, Materials, and gain a permanent stat Multiplier!
set rb_c=
set /p rb_c=Type YES to Rebirth: 

if /I "!rb_c!"=="YES" (
    set /a prestige+=1
    set /a p_multi+=1
    :: Wipe stats, but variables like !bones!, !pet_name! remain intact
    set gold=0
    set sword_up=0
    set armor_up=0
    set amulet_up=0
    set boots_up=0
    set sword=1
    set w_name=Wooden Sword
    echo.
    echo You have been REBORN. The universe expands.
    pause
    goto char_select
)
goto menu

:gameover
cls
echo =====================================
echo              YOU DIED
echo =====================================
echo The realm falls to darkness...
pause
goto title_screen
