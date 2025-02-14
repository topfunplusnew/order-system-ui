import { ref } from '@vue/composition-api';

export function useCounter() {
	const count = ref(0);

	const handleProcess = () => {
		count.value++;
	};
	return {
		count,
		handleProcess
	};
}
