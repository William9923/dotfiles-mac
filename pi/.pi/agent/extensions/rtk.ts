/**
 * RTK pi extension — rewrites bash commands via `rtk rewrite` for token savings.
 * Requires: rtk >= 0.23.0 in PATH.
 *
 * Thin delegating wrapper: rewrite logic lives in the rtk binary registry.
 */

import { execFileSync } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

function rtkAvailable(): boolean {
	try {
		execFileSync("which", ["rtk"], { stdio: "ignore" });
		return true;
	} catch {
		return false;
	}
}

function rewriteCommand(command: string): string {
	try {
		const rewritten = execFileSync("rtk", ["rewrite", command], {
			encoding: "utf8",
			stdio: ["ignore", "pipe", "ignore"],
		}).trim();
		return rewritten && rewritten !== command ? rewritten : command;
	} catch {
		return command;
	}
}

export default function (pi: ExtensionAPI) {
	if (!rtkAvailable()) {
		console.warn("[rtk] rtk binary not found in PATH — extension disabled");
		return;
	}

	pi.on("tool_call", async (event) => {
		if (!isToolCallEventType("bash", event)) return;
		const command = event.input.command;
		if (!command) return;

		const rewritten = rewriteCommand(command);
		if (rewritten !== command) {
			event.input.command = rewritten;
		}
	});
}
