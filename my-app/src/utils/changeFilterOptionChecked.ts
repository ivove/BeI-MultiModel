import { IFilter } from "../types";

export const changeFilterOptionChecked = (filters: IFilter[], name: string, checked: boolean): void => {
    filters.forEach(filter => {
        filter.options.forEach(filterOption => {
            if (+filterOption.id===Number(name)) {
                filterOption.checked=checked;
            }
        });
    });
}