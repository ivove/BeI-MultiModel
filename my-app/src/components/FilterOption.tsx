import React, { ChangeEvent } from "react";
import { IFilterOption } from "../types";
import { getFilterOptionCount } from "../utils";

interface IFilterOptionProps {
    filteroption: IFilterOption;
    filterCallBack: (name: string, checked:boolean) => void;
    filterCounts: any;
}
export function FilterOption({ filteroption,filterCallBack, filterCounts }: IFilterOptionProps) {
    return (
        <div className="d-flex justify-content-between">
        <label className="list-group-item">
            <input className="form-check-input me-1" 
            type="checkbox" 
            name={filteroption.id.toString()} 
            value=""
            checked={filteroption.checked}
            onChange={(event:ChangeEvent<HTMLInputElement>) => filterCallBack(event.target.name,event.target.checked)} />
            {filteroption.name}
            
        </label>
        <span className="badge bg-primary mt-2 pt-2">{getFilterOptionCount(+filteroption.id,filterCounts)}</span>
        </div>
    );
}