/**
 * Created by IntelliJ IDEA.
 * User: Sokolov Stanislav
 * Date: 9/20/11
 * Time: 8:24 PM
 */
package org.swizframework.utils.chain
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class Chain extends BaseCompositeChain
	{
		public var faultHandler:Function;
		// ========================================
		// protected properties
		// ========================================

		/**
		 * Backing variable for <code>dispatcher</code> getter/setter.
		 */
		protected var _dispatcher:IEventDispatcher;

		// ========================================
		// public properties
		// ========================================

		/**
		 * Target Event dispatcher.
		 */
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}


		public function set dispatcher( value:IEventDispatcher ):void
		{
			_dispatcher = value;
		}


		// ========================================
		// constructor
		// ========================================

		/**
		 * Constructor.
		 */
		public function Chain( dispatcher:IEventDispatcher, mode:String = ChainType.SEQUENCE, stopOnError:Boolean = true )
		{
			super( mode, stopOnError );

			this.dispatcher = dispatcher;
		}


		// ========================================
		// public methods
		// ========================================

		/**
		 * Add an EventChainStep to this EventChain.
		 */
		public function addEvent( event:Event, dispatcher:IEventDispatcher = null ):Chain
		{
			if ( dispatcher )
				addStep( new EventChainStep( event, dispatcher ) );

			if ( !dispatcher )
				addStep( new EventChainStep( event, this.dispatcher ) );
			return this;
		}


		/**
		 * Add an CommandChainStep to this EventChain.
		 */
		public function addAsyncCommand( asyncMethod:Function, asyncMethodArgs:Array = null, resultHandler:Function = null, faultHandler:Function = null, handlerArgs:Array = null ):Chain
		{
			var step:AsyncCommandChainStep = new AsyncCommandChainStep( asyncMethod, asyncMethodArgs, resultHandler, faultHandler, handlerArgs );
			addStep( step );
			return this;
		}


		/**
		 * Add an CommandChainStep to this EventChain.
		 */
		public function addFunction( functionRef:Function, functionArgArray:Array = null, functionThisArg:* = null ):Chain
		{
			addStep( new AdvancedFunctionChainStep( functionRef, functionArgArray, functionThisArg ) );
			return this;
		}



		/**
		 * Add an PauseChainStep to this EventChain.
		 */
		public function addPause():Chain
		{
			addStep( new PauseChainStep() );
			return this;
		}


		/**
		 * Add an another chain to this EventChain.
		 */
		public function addChain( chain:Chain ):Chain
		{
			addStep( new ChainChainStep( chain ) );
			return this;
		}


		/**
		 * @inheritDoc
		 */
		override public function doProceed():void
		{
			if ( currentStep is EventChainStep )
				EventChainStep( currentStep ).dispatcher ||= dispatcher;

			super.doProceed();
		}


		override public function error():void
		{
			if ( faultHandler )
			{
				faultHandler();
			}
			else
			{
				fail();
			}
		}
	}
}
