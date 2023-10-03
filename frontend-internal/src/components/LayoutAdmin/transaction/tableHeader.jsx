import { Arrow } from "assets";
export default function THead({ handleSelectAll, isChecked, getClassNamesFor, requestSort }) {
  return (
    <>
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
              <label htmlFor="checkbox-all-search" className="sr-only">
                checkbox
              </label>
            </div>
          </th>
          <th scope="col" className="py-3 px-6">
            <div className="flex items-center">
              ID
              <button
                onClick={() => requestSort('id')}
                className={getClassNamesFor('id')}
              >
                <img src={Arrow} alt="arrow" />
              </button>
            </div>
          </th>
          <th scope="col" className="py-3 px-3">
            <div className="flex items-center">
              Full Name
              <button
                onClick={() => requestSort(`user_full_name`)}
                className={getClassNamesFor('user_full_name')}
              >
                <img src={Arrow} alt="arrow" />
              </button>
            </div>
          </th>
          <th scope="col" className="py-3 px-6">
            <div className="flex items-center">
              Type
              <button
                onClick={() => requestSort('offices_office_type')}
                className={getClassNamesFor('offices_office_type')}
              >
                <img src={Arrow} alt="arrow" />
              </button>
            </div>
          </th>
          <th scope="col" className="py-3 px-6">
            <div className="flex items-center">
              Date
              <button
                onClick={() => requestSort('check_in_date')}
                className={getClassNamesFor('check_in_date')}
              >
                <img src={Arrow} alt="arrow" />
              </button>
            </div>
          </th>
          <th scope="col" className="py-3 px-6">
            <div className="flex ">
              <p className="my-auto">Check IN (Time)</p>
              <button
                onClick={() => requestSort('check_in')}
                className={getClassNamesFor('check_in')}
              >
                <img src={Arrow} alt="arrow" />
              </button>
            </div>
          </th>
          <th scope="col" className="py-3 px-6">
            <div className="flex">
              <p className="my-auto">Price(Rp)</p>
              <button
                onClick={() => requestSort('price')}
                className={getClassNamesFor('price')}
              >
                <img src={Arrow} alt="arrow" />
              </button>
            </div>
          </th>
          <th scope="col" className="py-3 px-6 text-center">
            <div className="flex items-center">
              Status
              <button
                onClick={() => requestSort('status')}
                className={getClassNamesFor('status')}
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
    </>
  );
}
