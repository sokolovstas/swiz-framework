/**
 * Created by IntelliJ IDEA.
 * User: Sokolov Stanislav
 * Date: 9/27/11
 * Time: 11:37 AM
 */
package org.swizframework.utils.chain
{

	import flash.events.Event;

	import mx.logging.ILogger;
	import mx.logging.Log;

	import org.swizframework.events.ChainEvent;

	import org.swizframework.events.ChainEvent;
	import org.swizframework.utils.async.IAsynchronousOperation;
	import org.swizframework.utils.chain.AbstractChain;
	import org.swizframework.utils.chain.BaseChainStep;
	import org.swizframework.utils.chain.IAutonomousChainStep;
	import org.swizframework.utils.chain.IChain;
	import org.swizframework.utils.services.SwizResponder;

	public class AdvancedFunctionChainStep extends BaseChainStep implements IAutonomousChainStep
	{
		public var functionRef:Function;
		public var functionArgArray:Array;
		public var functionThisArg:*;
		public var returnValue:*;


		public function AdvancedFunctionChainStep( functionRef:Function, functionArgArray:Array = null, functionThisArg:* = null )
		{
			this.functionRef = functionRef;
			this.functionArgArray = functionArgArray;
			this.functionThisArg = functionThisArg;
		}


		public function doProceed():void
		{
			var logger:ILogger = Log.getLogger( 'FunctionChainStep' );
			returnValue = functionRef.apply( functionThisArg, functionArgArray );
			if ( returnValue is IAsynchronousOperation )
			{
				returnValue.addResponder( new SwizResponder( resultHandler, faultHandler ) );
			}
			else if ( returnValue is AbstractChain )
			{
				var lenghtEvent:ChainEvent = new ChainEvent(ChainEvent.LENGTH_CHANGED);
				lenghtEvent.data = ( returnValue as AbstractChain ).stepsTotal;
				chain.dispatchEvent( lenghtEvent );

				returnValue.addEventListener( ChainEvent.LENGTH_CHANGED, returnValue_lengthChangedHandler )
				returnValue.addEventListener( ChainEvent.CHAIN_COMPLETE, resultHandler );
				returnValue.addEventListener( ChainEvent.CHAIN_FAIL, faultHandler );
				returnValue.start();
			}
			else
			{
				complete();
			}
		}


		// ========================================
		// public methods
		// ========================================

		/**
		 * Result handler for an associated pending asynchronous operation.
		 */
		protected function resultHandler( data:Object ):void
		{
			complete();
		}


		/**
		 * Fault handler for an associated pending asynchronous operation.
		 */
		protected function faultHandler( info:Object ):void
		{
			error();
		}


		private function returnValue_lengthChangedHandler( event:ChainEvent ):void
		{
			chain.dispatchEvent( event );
		}
	}
}
