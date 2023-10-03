import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import APIPromo from "apis/restApis/Promo";

const initialState = {
    data: [],
    loading: false,
};

export const fetchPromo = createAsyncThunk("fetch/promo", async() => {
    try {
        const res = await APIPromo.getAllPromo();
        return res.data.promo;
    } catch (err) {
        console.log(err);
    }
});

export const createPromo = createAsyncThunk("create/promo", async(data) => {
    try {
        const res = await APIPromo.createPromo(data);
        return res;
    } catch (err) {
        console.log(err);
    }
});

export const updatePromo = createAsyncThunk("update/promo", async(data) => {
    try {
        const res = await APIPromo.updatePromo(data);
        return res;
    } catch (err) {
        console.log(err);
    }
});

export const deletePromo = createAsyncThunk("delete/promo", async(id) => {
    try {
        const res = await APIPromo.deletePromo(id);
        return res;
    } catch (err) {
        console.log(err);
    }
});

const promoSlice = createSlice({
    name: "promo",
    initialState,
    extraReducers(builder) {
        builder
            .addCase(fetchPromo.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(fetchPromo.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = action.payload;
            })
            .addCase(fetchPromo.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(updatePromo.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(updatePromo.fulfilled, (state, action) => {
                state.data = state.data.map((val) => {
                    if (val.id === action.payload.id) {
                        return action.payload;
                    }
                    return val;
                });
                state.currentDetail = action.payload;
                state.loading = false;
            })
            .addCase(updatePromo.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(createPromo.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(createPromo.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = action.payload;
            })
            .addCase(createPromo.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(deletePromo.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(deletePromo.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = state.data.filter((item) => item.id !== action.payload.id);
            })
            .addCase(deletePromo.rejected, (state, action) => {
                state.status = "failed";
            });
    },
});

export default promoSlice.reducer;