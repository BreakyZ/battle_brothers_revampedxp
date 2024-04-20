::ModXpRevamped.HooksMod.hook("scripts/entity/tactical/player", function( q )
{	
	q.m.CombatStats.DamageTotalContribution <- 0;

	q.onActorKilled = @(__original) function( _actor, _tile, _skill )
	{
		local actor_xp = _actor.getXPValue();
		local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
		local total_damage_done_and_taken = 0
		local percent_contribution = 0

		foreach( bro in brothers ) {
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageDealtHitpoints;
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageDealtArmor;
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageReceivedHitpoints;
			bro.m.CombatStats.DamageTotalContribution += bro.m.CombatStats.DamageReceivedArmor;

			total_damage_done_and_taken += bro.m.CombatStats.DamageTotalContribution
		}
		if (total_damage_done_and_taken == 0)
		{
			total_damage_done_and_taken = _actor.Hitpoints
		}
		foreach( bro in brothers ) {
			percent_contribution = bro.m.CombatStats.DamageTotalContribution / total_damage_done_and_taken 
			if (bro.getSkills().hasSkill("trait.oath_of_distinction"))
			{
				percent_contribution += 0.4 * percent_contribution
			}

			bro.addXP(percent_contribution * actor_xp)
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