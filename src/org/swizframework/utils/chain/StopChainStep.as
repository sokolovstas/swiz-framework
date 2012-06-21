/**
 * Created by IntelliJ IDEA.
 * User: Sokolov Stanislav
 * Date: 6/21/12
 * Time: 2:35 PM
 */
package org.swizframework.utils.chain
{

	public class StopChainStep extends BaseChainStep implements IAutonomousChainStep
	{
		public function StopChainStep()
		{
		}
		public function doProceed():void
		{
			error();
		}
	}
}
