/**
 * Created by IntelliJ IDEA.
 * User: Sokolov Stanislav
 * Date: 9/13/11
 * Time: 11:36 AM
 */
package org.swizframework.utils.chain
{

	import flash.utils.setTimeout;

	import org.swizframework.utils.chain.BaseChainStep;
	import org.swizframework.utils.chain.IAutonomousChainStep;

	public class PauseChainStep extends BaseChainStep implements IAutonomousChainStep
	{
		public function PauseChainStep()
		{
		}


		public function doProceed():void
		{
			setTimeout( complete, 200 );
		}
	}
}
