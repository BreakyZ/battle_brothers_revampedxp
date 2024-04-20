::ModXpRevamped <- {
	ID = "revampedxp_hooks",
	Name = "Mod XP Revamped",
	Version = "1.0.0"
};

::ModXpRevamped.HooksMod <- ::Hooks.register(::ModXpRevamped.ID, ::ModXpRevamped.Version, ::ModXpRevamped.Name);


// add which mods are needed to run this mod
::ModXpRevamped.HooksMod.require("mod_msu >= 1.2.6", "mod_modern_hooks");

// like above you can add as many parameters to determine the queue order of the mod before adding the parameter to run the callback function. 
::ModXpRevamped.HooksMod.queue(">mod_msu", ">mod_legends", ">mod_sellswords", function()
{
	// define mod class of this mod
	::ModXpRevamped.Mod <- ::MSU.Class.Mod(::ModXpRevamped.ID, ::ModXpRevamped.Version, ::ModXpRevamped.Name);

	// load hook files
	::include("revampedxp_hooks/load.nut");
}, ::Hooks.QueueBucket.Normal);