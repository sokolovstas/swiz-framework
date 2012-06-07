/**
 * Created by IntelliJ IDEA.
 * User: Sokolov Stanislav
 * Date: 12/1/11
 * Time: 2:57 PM
 */
package org.swizframework.utils.chain
{
	import org.swizframework.events.ChainEvent;

	public class ChainChainStep extends BaseChainStep implements IAutonomousChainStep
	{
		public var waitForChain:Chain;


		public function ChainChainStep( chain:Chain )
		{
			waitForChain = chain;
		}


		public function doProceed():void
		{
			if ( !waitForChain )
			{
				complete();
				return;
			}
			waitForChain.addEventListener( ChainEvent.CHAIN_COMPLETE, completeHandler );
			waitForChain.addEventListener( ChainEvent.CHAIN_FAIL, failHandler );
			waitForChain.start();
		}


		// ========================================
		// public methods
		// ========================================

		/**
		 * Result handler for an associated pending asynchronous operation.
		 */
		protected function completeHandler( event:ChainEvent ):void
		{
			complete();
		}


		/**
		 * Fault handler for an associated pending asynchronous operation.
		 */
		protected function failHandler( event:ChainEvent ):void
		{
			error();
		}
	}
}
