#Name: ImmersiveEngineering.zs
#Author: Feed the Beast

print("Initializing 'ImmersiveEngineering.zs'...");

#lightning rod base
recipes.remove(<ImmersiveEngineering:metalMultiblock>);
recipes.addShaped(<ImmersiveEngineering:metalMultiblock>, [[<ImmersiveEngineering:coil:2>, <IC2:blockFenceIron>, <ImmersiveEngineering:coil:2>], [<StevesCarts:ModuleComponents:49>, <IC2:blockFenceIron>, <StevesCarts:ModuleComponents:49>], [<ore:blockDarkSteel>, <ore:blockDarkSteel>, <ore:blockDarkSteel>]]);

#wire
recipes.remove(<ImmersiveEngineering:coil:2>);
recipes.remove(<ImmersiveEngineering:coil:1>);
recipes.remove(<ImmersiveEngineering:coil>);
recipes.addShaped(<ImmersiveEngineering:coil:2> * 2, [[null, <ore:ingotSteel>, null], [<ore:ingotSteel>, <ImmersiveEngineering:material>, <ore:ingotSteel>], [null, <ore:ingotSteel>, null]]);
recipes.addShaped(<ImmersiveEngineering:coil:1> * 2, [[null, <ore:ingotElectrum>, null], [<ore:ingotElectrum>, <ImmersiveEngineering:material>, <ore:ingotElectrum>], [null, <ore:ingotElectrum>, null]]);
recipes.addShaped(<ImmersiveEngineering:coil> * 2, [[null, <ore:ingotCopper>, null], [<ore:ingotCopper>, <ore:treatedStick>, <ore:ingotCopper>], [null, <ore:ingotCopper>, null]]);

#powerGen
recipes.remove(<ImmersiveEngineering:metalDevice:9>);
recipes.remove(<ImmersiveEngineering:metalDevice:10>);
recipes.remove(<ImmersiveEngineering:woodenDevice:2>);
recipes.remove(<ImmersiveEngineering:woodenDevice:1>);
recipes.remove(<ImmersiveEngineering:woodenDevice:3>);
recipes.addShaped(<ImmersiveEngineering:metalDevice:9>, [[<ore:ingotIron>, <ImmersiveEngineering:metalDevice:3>, <ore:ingotIron>], [<ore:dustRedstone>, <ImmersiveEngineering:storage:9>, <ore:dustRedstone>], [<ore:ingotSteel>, <ore:ingotSteel>, <ore:ingotSteel>]]);
recipes.addShaped(<ImmersiveEngineering:metalDevice:10>, [[<ore:ingotConstantan>, <ImmersiveEngineering:metalDevice:7>, <ore:ingotConstantan>], [<ore:ingotEnderium>, <ImmersiveEngineering:storage:10>, <ore:ingotEnderium>], [<ore:ingotEnderium>, <ore:ingotEnderium>, <ore:ingotEnderium>]]);
recipes.addShaped(<ImmersiveEngineering:woodenDevice:3>, [[<ImmersiveEngineering:material:5>, <ImmersiveEngineering:material:5>, <ImmersiveEngineering:material:5>], [<ImmersiveEngineering:material:5>, <IC2:itemRecipePart:12>, <ImmersiveEngineering:material:5>], [<ImmersiveEngineering:material:5>, <ImmersiveEngineering:material:5>, <ImmersiveEngineering:material:5>]]);
recipes.addShaped(<ImmersiveEngineering:woodenDevice:1>, [[<ImmersiveEngineering:material:1>, <ImmersiveEngineering:material:1>, <ImmersiveEngineering:material:1>], [<ImmersiveEngineering:material:1>, <IC2:itemRecipePart:11>, <ImmersiveEngineering:material:1>], [<ImmersiveEngineering:material:1>, <ImmersiveEngineering:material:1>, <ImmersiveEngineering:material:1>]]);
recipes.addShaped(<ImmersiveEngineering:woodenDevice:2>, [[<ImmersiveEngineering:material:2>, <ImmersiveEngineering:material:2>, <ImmersiveEngineering:material:2>], [<ImmersiveEngineering:material:2>, <IC2:itemRecipePart:11>, <ImmersiveEngineering:material:2>], [<ImmersiveEngineering:material:2>, <ImmersiveEngineering:material:2>, <ImmersiveEngineering:material:2>]]);

#drill heads
recipes.remove(<ImmersiveEngineering:drillhead>);
recipes.remove(<ImmersiveEngineering:drillhead:1>);
recipes.addShaped(<ImmersiveEngineering:drillhead:1>, [[<minecraft:iron_ingot>, <minecraft:iron_ingot>, null], [<minecraft:iron_block>, <minecraft:iron_block>, <GraviSuite:advDDrill:*>], [<minecraft:iron_ingot>, <minecraft:iron_ingot>, null]]);
recipes.addShaped(<ImmersiveEngineering:drillhead>, [[<ore:ingotSteel>, <ore:ingotSteel>, null], [<ore:blockSteel>, <ore:blockSteel>, <IC2:itemToolIridiumDrill:*>], [<ore:ingotSteel>, <ore:ingotSteel>, null]]);

#light engineering block
recipes.remove(<ImmersiveEngineering:metalDecoration:7>);
recipes.addShaped(<ImmersiveEngineering:metalDecoration:7>, [[<ore:ingotIron>, <ImmersiveEngineering:material:11>, <ore:ingotIron>], [<ore:ingotCopper>, <Railcraft:cube:4>, <ore:ingotCopper>], [<ore:ingotIron>, <ImmersiveEngineering:material:11>, <ore:ingotIron>]]);

#blueprints
recipes.addShaped(<ImmersiveEngineering:blueprint:2>, [[<ImmersiveEngineering:metal:20>, null, <ImmersiveEngineering:metal:20>], [<ImmersiveEngineering:metal:20>, <ImmersiveEngineering:blueprint>, <ImmersiveEngineering:metal:20>], [<ImmersiveEngineering:metal:20>, <minecraft:emerald_block>, <ImmersiveEngineering:metal:20>]]);
recipes.addShaped(<ImmersiveEngineering:blueprint:1>, [[<ore:ingotHOPGraphite>, <ore:blockEmerald>, <ore:ingotHOPGraphite>], [<ore:ingotHOPGraphite>, <ImmersiveEngineering:blueprint>, <ore:ingotHOPGraphite>], [<ore:ingotHOPGraphite>, <ore:blockEmerald>, <ore:ingotHOPGraphite>]]);

#core sample drill
recipes.remove(<ImmersiveEngineering:metalDevice:14>);
recipes.addShaped(<ImmersiveEngineering:metalDevice:14>, [[<ImmersiveEngineering:metalDecoration:1>, <BuildCraft|Factory:miningWellBlock>, <ImmersiveEngineering:metalDecoration:1>], [<ImmersiveEngineering:metalDecoration:1>, <ore:fenceSteel>, <ImmersiveEngineering:metalDecoration:1>], [<ImmersiveEngineering:metalDecoration:5>, <ImmersiveEngineering:drillhead:1>, <ImmersiveEngineering:metalDecoration:5>]]);

#coal coke fix
recipes.addShapeless(<Railcraft:fuel.coke>, [<ImmersiveEngineering:material:6>]);

#remove ores from excavator
mods.immersiveengineering.Excavator.removeMineral("Platinum");

print("Initialized 'ImmersiveEngineering.zs'");