import { createAsyncThunk, createSlice, createEntityAdapter } from "@reduxjs/toolkit";
import APITransaction from "apis/restApis/Transaction";

const initialState = {
    data: [],
    loading: false,
    status: "idle",
    error: null,
};

export const fetchTransaction = createAsyncThunk("fetch/transaction", async() => {
    try {
        const res = await APITransaction.getAllTransaction();
        return res.data.data;
    } catch (error) {
        console.log(error);
    }
});

export const updateTransaction = createAsyncThunk("update/transaction", async(data) => {
    try {
        const res = await APITransaction.updateTransaction(data);
        return res.data;
    } catch (error) {
        console.log(error);
    }
});

export const deleteTransaction = createAsyncThunk("delete/transaction", async(id) => {
    try {
        const res = await APITransaction.deleteTransaction(id);
        return res;
    } catch (error) {
        console.log(error);
    }
});

const transactionEntity = createEntityAdapter({
    selectId: (transactions) => transactions.id,
});

const transactionSlice = createSlice({
    name: "transactions",
    initialState,
    extraReducers(builder) {
        builder
            .addCase(fetchTransaction.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(fetchTransaction.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = action.payload;
            })
            .addCase(fetchTransaction.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(updateTransaction.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(updateTransaction.fulfilled, (state, action) => {
                state.data = state.data.map((val) => {
                    if (val.id === action.payload.id) {
                        return action.payload;
                    }
                    return val;
                });
                state.loading = false;
            })
            .addCase(updateTransaction.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(deleteTransaction.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(deleteTransaction.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = state.data.filter((item) => item.id !== action.payload.id);
            })
            .addCase(deleteTransaction.rejected, (state, action) => {
                state.status = "failed";
            });
    },
});

export default transactionSlice.reducer;