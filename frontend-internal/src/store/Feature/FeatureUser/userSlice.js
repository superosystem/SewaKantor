import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import APIUser from "apis/restApis/User";

const initialState = {
    data: [],
    status: "idle",
    error: null,
};

export const fetchUsers = createAsyncThunk("fetch/users", async() => {
    try {
        const response = await APIUser.getAllUsers();
        return response.data;
    } catch (err) {
        console.log(err);
    }
});

export const searchUsers = createAsyncThunk("search/users", async() => {
    try {
        const response = await APIUser.searchUsersByEmail();
        return response.data;
    } catch (err) {
        console.log(err);
    }
});

export const updateUser = createAsyncThunk("updateUser/user", async(data) => {
    try {
        const res = await APIUser.updateUsers(data);
        return res.data;
    } catch (error) {
        console.log(error);
    }
});

export const deleteUser = createAsyncThunk("delete/user", async(id) => {
    try {
        const res = await APIUser.deleteUsers(id);
        return res.data;
    } catch (error) {
        console.log(error);
    }
});

const userSlice = createSlice({
    name: "users",
    initialState,
    extraReducers(builder) {
        builder
            .addCase(fetchUsers.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(fetchUsers.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = action.payload;
            })
            .addCase(fetchUsers.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(updateUser.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(updateUser.fulfilled, (state, action) => {
                state.data = state.data.map((val) => {
                    if (val.id === action.payload.id) {
                        return action.payload;
                    }
                    return val;
                });
                state.loading = false;
            })
            .addCase(updateUser.rejected, (state, action) => {
                state.status = "failed";
            })
            .addCase(deleteUser.pending, (state, action) => {
                state.status = "loading";
            })
            .addCase(deleteUser.fulfilled, (state, action) => {
                state.status = "succeeded";
                state.data = state.data.filter((item) => item.id !== action.payload.id);
            })
            .addCase(deleteUser.rejected, (state, action) => {
                state.status = "failed";
            });
    },
});

export default userSlice.reducer;