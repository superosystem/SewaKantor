import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import APIFacility from "apis/restApis/Facility";

const initialState = {
    data: [],
    status: "idle",
    error: null,
};

export const fetchFacility = createAsyncThunk("fetch/facility", async() => {
    try {
        const response = await APIFacility.getAllFacility();
        return response.data;
    } catch (err) {
        console.log(err);
    }
});

const facilitySlice = createSlice({
    name: "facility",
    initialState,
    extraReducers(builder) {
        builder
            .addCase(fetchFacility.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(fetchFacility.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = action.payload;
            })
            .addCase(fetchFacility.rejected, (state, action) => {
                state.status = "failed";
            });
    },
});

export default facilitySlice.reducer;