/**
 * Swap Enter & Shift-Enter
 *
 * Makes enter insert a newline and shift+enter submit.
 * Works around a pi bug where the editor's newLine handler has hardcoded
 * shift+enter fallbacks that bypass the keybinding config.
 *
 * See: newling-bug.md
 */

import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { matchesKey } from "@earendil-works/pi-tui";

class SwapEnterEditor extends CustomEditor {
	handleInput(data: string): void {
		// Intercept shift+enter BEFORE super.handleInput() runs the
		// buggy hardcoded newLine check. If submit is bound to
		// shift+enter, call submitValue() and return immediately.
		if (matchesKey(data, "shift+enter") || matchesKey(data, "shift+return")) {
			const submitKeys = this.keybindings.getKeys("tui.input.submit");
			const shiftEnterIsSubmit =
				submitKeys.includes("shift+enter") || submitKeys.includes("shift+return");
			if (shiftEnterIsSubmit) {
				this.submitValue();
				return;
			}
		}

		// Intercept plain enter BEFORE super.handleInput(). If enter
		// is bound to newLine, insert a newline and return immediately.
		if (matchesKey(data, "enter") || matchesKey(data, "return")) {
			const newLineKeys = this.keybindings.getKeys("tui.input.newLine");
			const enterIsNewLine =
				newLineKeys.includes("enter") || newLineKeys.includes("return");
			if (enterIsNewLine) {
				this.addNewLine();
				return;
			}
		}

		// Everything else: delegate to the normal handler
		super.handleInput(data);
	}
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setEditorComponent((tui, theme, kb) => new SwapEnterEditor(tui, theme, kb));
	});
}
