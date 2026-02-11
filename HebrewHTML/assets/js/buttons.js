(function () {
	function setupToggle({ btnId, bodyClass, storageKey, labelShow, labelHide }) {
		const btn = document.getElementById(btnId);
		if (!btn) return;

		function setState(hide) {
			document.body.classList.toggle(bodyClass, hide);
			btn.textContent = hide ? labelShow : labelHide;
			try { localStorage.setItem(storageKey, hide ? '1' : '0'); } catch (e) { }
		}

		// Restore last state
		let hide = false;
		try { hide = localStorage.getItem(storageKey) === '1'; } catch (e) { }
		setState(hide);

		btn.addEventListener('click', function () {
			hide = !document.body.classList.contains(bodyClass);
			setState(hide);
		});
	}

	setupToggle({
		btnId: 'toggle-tr',
		bodyClass: 'hide-tr',
		storageKey: 'interlinear_hide_tr',
		labelShow: 'Show transliteration',
		labelHide: 'Hide transliteration',
	});

	setupToggle({
		btnId: 'toggle-gl',
		bodyClass: 'hide-gl',
		storageKey: 'interlinear_hide_gl',
		labelShow: 'Show translation',
		labelHide: 'Hide translation',
	});
})();