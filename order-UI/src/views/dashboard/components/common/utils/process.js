export class DomainProcessor {
	constructor(callback) {
		this.callback = callback;
	}

	handler() {
		this.callback();
	}
}
