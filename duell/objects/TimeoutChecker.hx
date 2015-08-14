/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell.objects;

import duell.helpers.ThreadHelper;

class TimeoutChecker
{
	private var timeout: Float;
	private var ticked: Bool;
	private var finished: Bool;
	private var onTimeout: Void->Void;
	public function new(timeout: Float, onTimeout: Void->Void): Void
	{
		this.timeout = timeout;
		this.onTimeout = onTimeout;
	}

	public function tick(): Void
	{
		ticked = true;
	}

	public function finish(): Void
	{
		finished = true;
	}

	public function start(): Void
	{
		if (timeout == 0)
		{
			finished = true;
			return;
		}

		finished = false;
		ThreadHelper.runInAThread(
						function ()
						{
							ticked = true;

							var timeleft = timeout;
							while(!finished) /// something else can finish
							{
								if (timeleft <= 0)
								{
									if (!ticked)
									{
										finished = true;

										onTimeout();
										break;
									}
									ticked = false;
									timeleft = timeout;
								}
								Sys.sleep(1);
								timeleft -= 1;
							}
						}
		);
	}
}
