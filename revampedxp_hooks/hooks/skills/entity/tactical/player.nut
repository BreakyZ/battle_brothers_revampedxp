::ModXpRevamped.HooksMod.hook("scripts/entity/tactical/player", function( q )
{	
	q.m.CombatStats.DamageTotalContribution <- 0.0;
	q.m.CombatStats.PercentContribution <- 0.0

	q.onActorKilled = @(__original) function( _actor, _tile, _skill )
	{
		local actor_xp = _actor.getXPValue();
		local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
		local total_damage_done_and_taken = 0.0

		foreach( bro in brothers ) {
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageDealtHitpoints;
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageDealtArmor;
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageReceivedHitpoints;
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageReceivedArmor;

			total_damage_done_and_taken += bro.m.CombatStats.DamageTotalContribution.tofloat();

		}


		if (total_damage_done_and_taken == 0)
		{
			//this is if you're cheating, some insta kill damage and things I don't know about yet
			__original( _actor, _tile, _skill );
			return;
		}

		foreach( bro in brothers ) {
			bro.m.CombatStats.PercentContribution = bro.m.CombatStats.DamageTotalContribution.tofloat() / total_damage_done_and_taken.tofloat();
			if (bro.getSkills().hasSkill("trait.oath_of_distinction"))
			{
				bro.m.CombatStats.PercentContribution += 0.4 * bro.m.CombatStats.PercentContribution;
			}
			bro.addXP(this.Math.floor(bro.m.CombatStats.PercentContribution * actor_xp));
			if (bro.getCurrentProperties().IsAllyXPBlocked)
				{
					continue;
				}

			bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
		}

		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.isInReserves() && bro.getSkills().hasSkill("perk.legend_pacifist"))
			{
				bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
			}
		}
	}
});