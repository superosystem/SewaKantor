import React from "react";
import { Arrow } from "assets";

const TableHead = ({ handleSelectAll, isChecked, getClassNamesFor, requestSort }) => {
    return (
        <thead className="text-xs text-gray-500 bg-gray-50">
            <tr>
                <th scope="col" className="p-4">
                    <div className="flex items-center">
                        <input
                            id="checkbox-all-search"
                            type="checkbox"
                            onChange={handleSelectAll}
                            checked={isChecked}
                            className="w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-secondary"
                        />
                        <label
                            htmlFor="checkbox-all-search"
                            className="sr-only"
                        >
                            checkbox
                        </label>
                    </div>
                </th>
                <th scope="col" className="py-3 px-6">
                    <div className="flex justify-center">
                        <p className="my-auto">Office ID</p>
                        <button
                            onClick={() => requestSort('id')}
                            className={getClassNamesFor('id')}
                        >
                            <img src={Arrow} alt="arrow" />
                        </button>
                    </div>
                </th>
                <th scope="col" className="py-3 px-3">
                    <div className="flex justify-center">
                        <p className="my-auto">Name Office</p>
                        <button
                            onClick={() => requestSort('title')}
                            className={getClassNamesFor('title')}
                        >
                            <img src={Arrow} alt="arrow" />
                        </button>
                    </div>
                </th>
                <th scope="col" className="py-3 px-6">
                    <div className="flex justify-center">
                        <p className="my-auto">Type</p>
                        <button
                            onClick={() => requestSort('office_type')}
                            className={getClassNamesFor('office_type')}
                        >
                            <img src={Arrow} alt="arrow" />
                        </button>
                    </div>
                </th>
                <th scope="col" className="py-3 px-6">
                    <div className="flex justify-center">
                        <p className="my-auto">Price</p>
                        <button
                            onClick={() => requestSort('price')}
                            className={getClassNamesFor('price')}
                        >
                            <img src={Arrow} alt="arrow" />
                        </button>
                    </div>
                </th>
                <th scope="col" className="py-3 px-6">
                    <div className="flex justify-center">
                        <p className="my-auto">Capacity</p>
                        <button
                            onClick={() => requestSort('accommodate')}
                            className={getClassNamesFor('accommodate')}
                        >
                            <img src={Arrow} alt="arrow" />
                        </button>
                    </div>
                </th>
                <th scope="col" className="py-3 px-6">
                    <div className="flex justify-center">
                        <p className="my-auto">Total Booked</p>
                        <button
                            onClick={() => requestSort('id')}
                            className={getClassNamesFor('id')}
                        >
                            <img src={Arrow} alt="arrow" />
                        </button>
                    </div>
                </th>
                <th scope="col" className="py-3 px-6 text-center">
                    Action
                </th>
            </tr>
        </thead>
    );
};

export default TableHead;