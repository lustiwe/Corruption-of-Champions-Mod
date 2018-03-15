/**
 * Created by aimozg on 27.01.14.
 */
package classes.Perks
{
	import classes.PerkClass;
	import classes.PerkType;
	import classes.GlobalFlags.*;

	public class SpellcastingAffinityPerk extends PerkType
	{

		override public function desc(params:PerkClass = null):String
		{
			var amt:Number = params.value1;
			if (kGAMECLASS.flags[kFLAGS.EASY_MODE_ENABLE_FLAG] < 0) amt /= 2; //Hard Mode
			return "Reduces spell costs by " + amt + "%.";
		}

		public function SpellcastingAffinityPerk()
		{
			super("Spellcasting Affinity","Spellcasting Affinity", "Reduces spell costs.");
		}
	}
}
